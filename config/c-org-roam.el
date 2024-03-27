;;; c-org-roam.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;; TODO
;;
;; Node searching goals:
;;
;; - match first on node titles (over outlines)
;; - prioritize top-level, then first nested level, then 2nd, etc.
;; - for matches in same level, order by match score
;; - matching tags should probably involve adding an explicit tag:... in the search.
;;   This can be added any number of times
;; - TODO do I want to search outline? There should probably be a special syntax for this
;; - add state search (e.g., state:TODO). Don't include DONE items by default.
;;
;; Better node filtering/finding:
;;
;; - Perform search on all nodes. This should sort all nodes in terms
;;   of a match score.
;; - First 100 should then be presented.
;;
;; TODO do I need to replace `org-roam-db-sync' with?
;;
;; (dolist (file (org-roam-list-files))
;;   (with-current-buffer (find-file-noselect file)
;;     (org-roam-db-update-file file)))

;;; Code:

(if (featurep 'straight)
  (progn
    (straight-use-package 'org-roam)))

;; this must be set before org-roam is loaded
(setq org-roam-v2-ack t)
(require 'org-roam)

(require 'dash)

;; (add-hook 'org-roam-mode 'org-roam-db-autosync-mode)

;; TODO I'm not sure how to update the modified timestamp. The obvious
;; way to determine this is to update the node at point during a
;; save. But, this will miss nodes that changed and also produce false
;; positives.
(defun mh//org-update-node-timestamps ()
  "Initialize created and modified properties of current org node
if they don't exist.  Otherwise, update modified to the current
time if the contents of the node changed.")

(defun mh//org-update-last-modified ()
  ""
  (save-excursion
    (goto-char 0)
    ;; MODIFIED must be present at buffer position 1000 or less,
    ;; to prevent accidentally changing a non-header property
    ;; value. Additionally, this avoids the computational cost of
    ;; traversing the full buffer.
    (if (search-forward "MODIFIED: " 1000 t)
        (progn
          (delete-region (point) (line-end-position))
          (let ((now (format-time-string "[%Y-%m-%d %a %H:%M]")))
            (insert now))))))
;; (add-hook 'org-roam-mode (lambda ()
;;                            (add-hook 'before-save-hook
;;                                      'mh//org-update-last-modified 0 t)))

(custom-set-variables `(org-roam-capture-templates
                        `(("d" "default" plain "%?"
                           :if-new
                           ;; slug is a suitable converted filename (e.g. spaces
                           ;; converted to underscores)
                           (file+head "${slug}.org"
                                      ,(concat ":PROPERTIES:\n"
                                               ":ID: %(org-id-new)\n"
                                               ":END:\n"
                                               "#+TITLE: ${title}\n"
                                               "#+filetags: \n"
                                               "#+CREATED: %(mh/time-stamp)\n"
                                               "#+MODIFIED: %(mh/time-stamp)\n"))
                           :unnarrowed t)
                          ("r" "ref" plain ""
                           :if-new
                           (file+head "${slug}.org"
                                      ,(concat ":PROPERTIES:\n"
                                               ":ID: %(org-id-new)\n"
                                               ":ROAM_REFS: cite:${citekey}\n"
                                               ":END:\n"
                                               "#+TITLE: ${title}\n"
                                               "#+filetags:\n"
                                               "#+CREATED: %(mh/time-stamp)\n"
                                               "#+MODIFIED: %(mh/time-stamp)\n\n"
                                               "* outline\n"
                                               ":PROPERTIES:\n"
                                               ":NOTER_DOCUMENT: %(orb-process-file-field \"${citekey}\")\n"
                                               ":END:\n"
                                               "%(mh/pdf-outline-to-org-headline \"%(orb-process-file-field \"${citekey}\")\" 1)\n"))
                           :unnarrowed t)))
                      `(org-roam-directory "~/doc/notes/wiki"))

(defface mh-org-roam-node-outline-prefix-face
  '((t :extend t))
  "Face for the outline prefix when displaying a node.")

(defface mh-org-roam-node-outline-suffix-face '((t nil))
  "Face for the outline suffix when displaying a node.")

(defface mh-org-roam-node-tags-face '((t nil))
  "Face for the tags when displaying a node.")

(defun mh/org-add-ids-to-headlines-in-file ()
  "Add ID properties to all headlines in the current file which
do not already have one.
Taken from https://stackoverflow.com/a/16247032/5710525."
  (interactive)
  (org-map-entries 'org-id-get-create))

;; For wiki files, add the ID property to all headings in the current
;; file before saving. The automatic ID feature is useful because it
;; allows headings to be registered as nodes and easy to find. This
;; benefit is not present for org files outside the wiki and adding a
;; property drawer to every heading adds visual clutter.
(add-hook 'org-mode-hook
          (lambda ()
            (if buffer-file-name
                (let ((curr-file-dir (substring (file-name-directory buffer-file-name) 0 -1))
                      (wiki-dir (expand-file-name org-roam-directory)))
                  (if (string-equal curr-file-dir wiki-dir)
                      (add-hook 'before-save-hook 'mh/org-add-ids-to-headlines-in-file nil 'local))))))

(defun mh/org-roam-node-full-path (node)
  "Org-roam NODE outline path, including the appended title."
  (let* ((outline (append (org-roam-node-olp node)
                          `(,(org-roam-node-title node))))
         (level (org-roam-node-level node)))
    (if (> level 0)
        (let* ((file (org-roam-node-file node))
               (title (car (org-roam-db-query
                            [:select title :from nodes
                             :where (and (= file $s1)
                                         (= level 0))]
                            file))))
          (setq outline (append title outline))))
    outline))

(defun mh/org-roam-node-real-display-match (node)
  "Take an org-roam NODE and compute a (DISPLAY . REAL) whose sole
purpose is for matching and to be fast.  Display will be further
transformed later for appearance."
  (let ((display (mapconcat (lambda (x) x)
                            (append (mh/org-roam-node-full-path node)
                                    (org-roam-node-tags node))
                            " ")))
    `(,display . ,node)))

(defun mh/org-roam-node-candidates ()
  "Candidates for mh/org-roam-node-find."
  (let ((nodes (org-roam-node-list)))
    (mapcar 'mh/org-roam-node-real-display-match nodes)))

(defun mh//org-roam-node-find-node-filter (node-display-real)
  "Outline string to display for an org-roam node."
  ;; `outline-display' is a list of each headline path in the outline
  ;; we display. We initialize it to the full path and then remove
  ;; elements as needed.
  (let* ((node (cdr node-display-real))
         (outline-path (append (org-roam-node-olp node)
                               `(,(org-roam-node-title node))))
         (level (org-roam-node-level node))
         (outline-display outline-path)
         (tags-width 15)
         (full-tags-display (org-add-props (mapconcat
                                            (lambda (v)
                                              (concat (or (cdr (assoc "tags" org-roam-node-template-prefixes))
                                                          "")
                                                      v))
                                            (org-roam-node-tags node) " ")
                                nil 'face 'mh-org-roam-node-tags-face))
         (tags-display (substring full-tags-display
                                  nil
                                  (min (length full-tags-display) tags-width)))
         ;; Total helm window width. Using the currently active window
         ;; instead of the helm window can use the width of the
         ;; minibuffer instead.
         (window-width (mh/window-width (helm-window)))
         ;; Maximum acceptable path width. Leave room for tags and a
         ;; space between the path and tags.
         (path-width (- window-width tags-width 1)))
    ;; if the current node is not the file-level node, append the file
    ;; level node to `outline-display', which otherwise isn't part of
    ;; the outline path.
    (if (> level 0)
        (let* ((file (org-roam-node-file node))
               (title (car (org-roam-db-query
                            [:select title :from nodes
                             :where (and (= file $s1)
                                         (= level 0))]
                            file))))
          (setq outline-display (append title outline-display))))
    ;; stylize parts of the outline according to custom faces
    (setq outline-display
          (--map-last t (org-add-props it nil 'face 'mh-org-roam-node-outline-suffix-face)
	              (--map (org-add-props it nil 'face 'mh-org-roam-node-outline-prefix-face)
                             outline-display)))
    ;; `(length outline-display)' computes the string length of all
    ;; separators. 2 computes the maximum difference between the
    ;; string length of '...' and a headline string, in case on
    ;; headline is shorter than 3 chars.
    (while (and (>= (+ (-sum (cl-map 'list 'length outline-display))
                       (length outline-display)
                       2)
                    path-width)
                ;; Don't remove the first or last headline path. Deal
                ;; with this case later.
                (>= (length outline-display) 2))
      (setq outline-display (-remove-at 1 outline-display)))
    ;; Remove the first headline path if the first and last
    ;; collectively exceed `path-width'.
    (if (>= (+ (-sum (cl-map 'list 'length outline-display))
               (length outline-display)
               2)
            path-width)
        (setq outline-display (-remove-at 0 outline-display)))
    (let ((outline-string (car outline-display)))
      ;; The total headline path exceeded the max width, so we cut out
      ;; one or more path elements.
      (if (< (length outline-display)
             (length outline-path))
          (if (eq (length outline-display) 1)
              (concat ".../" outline-string)
            (setq outline-string (concat outline-string "/..."))))
      (let ((index 1))
        (while (< index (length outline-display))
	  (setq outline-string (concat outline-string "/"
                                       (nth index outline-display)))
          (setq index (+ 1 index))))
      ;; Still need to present (DISPLAY . REAL) since action needs
      ;; real.
      `(,(concat outline-string
                 (make-string (- window-width
                                 (length outline-string)
                                 1
                                 tags-width)
                              (string-to-char " "))
                 tags-display)
        .
        ,node))))

(defun mh/org-roam-node-find-filtered-candidate-transformer (candidates source)
  ""
  (mapcar #'mh//org-roam-node-find-node-filter candidates))

(defvar mh-org-roam-node-cache nil
  "Cache for mh/org-roam-node-find.")

(defun mh/update-org-roam-node-cache ()
  "Update mh-org-roam-node-cache."
  ;; First ensure the database is up-to-date.
  (org-roam-db-sync)
  (setq mh-org-roam-node-cache (mh/org-roam-node-candidates)))

;; TODO nodes not updating
(defun mh/update-org-roam-node-cache-async ()
  "Update mh-org-roam-node-cache asynchronously."
  (interactive)
  (async-start (lambda ()
                 (load "~/.config/emacs/straight/repos/straight.el/bootstrap.el")
                 (load "~/.config/emacs/config/c-no-littering.el")
                 (load "~/.config/emacs/config/c-org-roam.el")
                 ;; Minimize the time this update locks the database,
                 ;; which prevents use.
                 (let* ((original-file org-roam-db-location)
                        (org-roam-db-location
                         (concat (file-name-directory original-file)
                                 "org-roam.new.db")))
                   (copy-file original-file org-roam-db-location t)
                   (org-roam-db-sync)
                   (rename-file org-roam-db-location original-file t))
                 (mh/org-roam-node-candidates))
               (lambda (result)
                 (setq mh-org-roam-node-cache result)
                 (message "mh/update-org-roam-node-cache-async complete"))))

(defun mh//org-roam-node-candidate-predicate (candidate)
  ""
  (let ((node (cdr candidate)))
    ;; TODO
    ;; - consider aliases
    (helm-mm-3-match (org-roam-node-title node))))

(defun mh//org-roam-node-candidate-filter (candidates)
  ""
  (-filter 'mh//org-roam-node-candidate-predicate candidates))

(defun mh//org-roam-node-candidate-comparator (candidate1 candidate2)
  ""
  ;; TODO
  ;; - consider aliases
  (let* ((node1 (cdr candidate1))
         (node2 (cdr candidate2))
         (level1 (org-roam-node-level node1))
         (level2 (org-roam-node-level node2)))
    (if (< level1 level2)
        t
      (if (> level1 level2)
          nil
        (let ((title1 (org-roam-node-title node1))
              (title2 (org-roam-node-title node2)))
          (> (helm-score-candidate-for-pattern title1 helm-pattern)
             (helm-score-candidate-for-pattern title2 helm-pattern)))))))

(defun mh//org-roam-node-candidate-sort (candidates)
  ""
  (-sort 'mh//org-roam-node-candidate-comparator candidates))

(defun mh//org-roam-node-candidates ()
  ""
  (let ((candidates mh-org-roam-node-cache))
    (--> candidates
         mh//org-roam-node-candidate-filter
         mh//org-roam-node-candidate-sort)))


;; TODO mode-line doesn't appear
;;
;; TODO the shortest elements don't always appear first. I believe
;; this is because those nodes are filtered out by
;; `candidate-number-limit'. I might need to customize matching so
;; that short nodes are preferred. I think the reason is actually a
;; little different. Shorter candidates are only preferred when they
;; produce an exact score tie with
;; `helm-fuzzy-matching-default-sort-fn-1'. I think I may need to
;; provide my own custom fuzzy matching to some extent. I need several
;; behaviors:
;;
;; - suppression of all nodes under a matching node. subnodes that
;;   also match should still be displayed though
;; - matching performed before candidate limiting

(defun mh/org-roam-node-read (&optional initial-input filter-fn sort-fn require-match)
  "Personal version of `org-roam-node-read'."
  (interactive)
  (helm
   :sources `(,(helm-build-sync-source "org-roam-node"
                 :candidates 'mh//org-roam-node-candidates
                 :candidate-number-limit 100
                 :candidate-transformer filter-fn
                 :requires-pattern 1
                 :match-dynamic t
                 :filtered-candidate-transformer '(mh/org-roam-node-find-filtered-candidate-transformer))
              ,(helm-build-dummy-source "new node"
                 :action (lambda (node)
                           (org-roam-capture-
                            :node (org-roam-node-create :title node)
                            :templates nil
                            :props '(:finalize find-file)))))
   :buffer "*org-roam-node*"
   :prompt "node: "
   :input initial-input))

;; TODO it would probably be better to have a customization that
;; allowed customizing this, rather than needing to override it.
(advice-add 'org-roam-node-read :override #'mh/org-roam-node-read)

(defun mh/org-roam-node-find-todo ()
  "Search all org-roam nodes labelled TODO."
  (interactive)
  (funcall-interactively 'org-roam-node-find
                         nil
                         nil
                         (lambda (nodes)
                           (-filter (lambda (x)
                                      (equal "TODO" (org-roam-node-todo (cdr x))))
                                    nodes))))


(defun mh//maybe-update-org-roam-node-cache ()
  "Update `mh-org-roam-node-cache' if not currently being updated."
  (unless (-find (lambda (x)
                   (equal "*emacs*" (buffer-name x)))
                 (buffer-list))
    (mh/update-org-roam-node-cache-async)))

;; Update the org-roam node cache after saving, but don't do it if
;; we're already updating the cache.
(add-hook 'org-mode-hook (lambda ()
                           (add-hook 'after-save-hook
                                     #'mh//maybe-update-org-roam-node-cache 0 t)))
;; (remove-hook 'org-mode-hook (lambda ()
;;                               (add-hook 'after-save-hook
;;                                         #'mh//maybe-update-org-roam-node-cache 0 t)))

;; Update node cache after Emacs initialization.
(add-hook 'after-init-hook #'mh//maybe-update-org-roam-node-cache)

;; TODO persist the node cache across sessions.

(defun mh/org-roam-screenshot (fname)
  "Take a screenshot and save it to the wiki data folder."
  (interactive "sFile name (excluding .png extension): ")
  (let ((fpath (expand-file-name
                (concat org-roam-directory "/data/" fname ".png"))))
    (if (and (file-exists-p fpath)
             (not (string-equal (read-string "Overwrite [y/n]?: ") "y")))
        (display-warning :warning
          (concat "File " fpath " already exists\n"))
      (call-process "import" nil "*ImageMagick import*" nil fpath)
      (mh/org-insert-file-image fpath))))

(provide 'c-org-roam)
;;; c-org-roam.el ends here
