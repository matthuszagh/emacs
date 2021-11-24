;;; c-org-roam.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'org-roam))

;; this must be set before org-roam is loaded
(setq org-roam-v2-ack t)
(require 'org-roam)

(setq org-roam-directory "~/doc/notes/wiki")

;; (add-hook 'org-roam-mode 'org-roam-db-autosync-mode)

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
(add-hook 'org-roam-mode (lambda ()
                           (add-hook 'before-save-hook
                                     'mh//org-update-last-modified 0 t)))

(custom-set-variables `(org-roam-capture-templates
                        `(("d" "default" plain "%?"
                           :if-new
                           ;; slug is a suitable converted filename (e.g. spaces
                           ;; converted to underscores)
                           (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
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
                           (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
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
                           :unnarrowed t))))

(defface mh-org-roam-node-outline-prefix-face
  '((t :extend t))
  "Face for the outline prefix when displaying a node.")

(defface mh-org-roam-node-outline-suffix-face '((t nil))
  "Face for the outline suffix when displaying a node.")

(defface mh-org-roam-node-tags-face '((t nil))
  "Face for the tags when displaying a node.")

;; TODO also look at `org-format-outline-path'. Probably not
;; exactly what I want, but it does something similar.
(setq mh//org-roam-helm-tags-width 25)
(cl-defmethod org-roam-node-outline ((node org-roam-node))
  "Outline string to display for an org-roam node."
  ;; `outline-display' is a list of each headline path in the outline
  ;; we display. We initialize it to the full path and then remove
  ;; elements as needed.
  (let* ((outline-path (append (org-roam-node-olp node)
                               `(,(org-roam-node-title node))))
         (level (org-roam-node-level node))
         (outline-display outline-path)
         (tags-width 15)
         (path-width (- (mh/window-width) mh//org-roam-helm-tags-width)))
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
      outline-string)))

(cl-defmethod org-roam-node-tags-stylized ((node org-roam-node))
  "Tags string to display for an org-roam node."
  ;; `outline-display' is a list of each headline path in the outline
  ;; we display. We initialize it to the full path and then remove
  ;; elements as needed.
  (org-add-props (mapconcat
                  (lambda (v)
                    (concat (or (cdr (assoc "tags" org-roam-node-template-prefixes))
                                "")
                            v))
                  (org-roam-node-tags node) " ")
      nil 'face 'mh-org-roam-node-tags-face))

(custom-set-variables `(org-roam-node-display-template
                        (lambda ()
                          (let ((tags-width 25))
                            (concat "${outline:"
                                    (number-to-string (- (mh/window-width)
                                                         tags-width 1))
                                    "} ${tags-stylized:"
                                    (number-to-string tags-width)
                                    "}")))))

(provide 'c-org-roam)
;;; c-org-roam.el ends here
