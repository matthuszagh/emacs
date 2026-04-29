;;; c-org.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (progn
      (straight-use-package 'org)
      (straight-use-package 'org-contrib)))

(require 'org)

(add-hook 'org-babel-after-execute-hook
          #'org-display-inline-images)

(require 'org-element)
(setq org-startup-with-latex-preview t)
(setq org-startup-with-inline-images t)
(setq org-startup-folded t)

;; show invisible text when editing it
(setq org-catch-invisible-edits 'show)

;; place archives in the current file under the top-level 'archive' headline
(setq org-archive-location "::* archive")

;; Remove "<" and ">" as pair elements in org-mode's syntax table. "<"
;; and ">" are used extensively in TeX snippets not as pair elements.

;; TODO this doesn't seem to fix everything. `check-parens' still
;; calls out unmatched "<" and ">" delimiters and I get messages about
;; mismatched parentheses. However, the
;; `mh/org-mode-remove-angle-bracket-syntax' solution does work.
;;
;; (modify-syntax-entry ?< "." org-mode-syntax-table)
;; (modify-syntax-entry ?> "." org-mode-syntax-table)
;; ;; ;; this can be undone with the following, if ever desired
;; ;; (modify-syntax-entry ?< "(>" org-mode-syntax-table)
;; ;; (modify-syntax-entry ?> ")<" org-mode-syntax-table)

(defun mh/org-mode-remove-angle-bracket-syntax ()
  "In Org-mode, make < and > regular punctuation (not parens)."
  (modify-syntax-entry ?< "." (syntax-table))
  (modify-syntax-entry ?> "." (syntax-table)))

(add-hook 'org-mode-hook #'mh/org-mode-remove-angle-bracket-syntax)

;; Also disable "<" and ">" in electric-pair mode, to prevent them
;; being inserted together.
(defun mh/inhibit-electric-pair-angle-brackets (char)
  "Prevent electric pairing of angle brackets in Org-mode."
  (and (eq major-mode 'org-mode)
       (eq char ?<)))
(add-hook
 'org-mode-hook
 (lambda ()
   (setq-local
    electric-pair-inhibit-predicate
    (lambda (c)
      (or (mh/inhibit-electric-pair-angle-brackets c)
          (when (default-value 'electric-pair-inhibit-predicate)
            (funcall (default-value 'electric-pair-inhibit-predicate) c)))))))

(custom-set-variables
 ;; Remove all emphasis markers. Strikethrough is annoying when using
 ;; '+' in math, '/' and '~' which mess up paths, and I've had issues
 ;; with underline '_' as well. Finally, I don't use the others and I
 ;; think Org did a poor job with their emphasis marker choice.
 '(org-emphasis-alist nil)
 ;; Don't fontify emphasis markers
 '(org-fontify-emphasized-text nil)
 ;; Collapse/shrink all tables on startup
 '(org-startup-shrink-all-tables t)
 ;; Don't hide emphasis markers. For some reason, these are still
 ;; hidden even when they're disabled.
 '(org-hide-emphasis-markers nil)
 '(org-latex-regexps
   ;; only use \(\) for latex fragment delimiters
   '(("\\(" "\\\\([^\000]*?\\\\)" 0 nil)))
 ;; Disable lining up values in property drawers. The default value is
 ;; "%-10s %s". There are property keys that are longer than 10
 ;; characters, so using this value doesn't line them up anyway. And,
 ;; any time you add a property longer than the current max property,
 ;; you'd need to change this value and update all drawers. Finally, I
 ;; don't see much of a benefit to lining up values.
 '(org-property-format "%s %s")
 ;; Disable cache persistance between Emacs sessions. This seems to
 ;; interfere with the org-roam node cache. In fact, org-persist seems
 ;; to be the source of all sorts of woes. For example, I was
 ;; constantly running into an issue in which tramp would try to
 ;; connect to a remote host when seemingly unrelated command was run
 ;; (like closing emacs). This was caused by the org-persist cache,
 ;; which is located in ~/.cache/org-persist.
 '(org-element-cache-persistent nil))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; Don't block parent headings from being marked 'DONE' when child
;; headings are still in a 'TODO' state. This is `nil' by default,
;; but it doesn't hurt to be explicit.
(setq org-enforce-todo-dependencies nil)

;; always use :noweb in org babel source blocks.
(setq org-babel-default-header-args
      (cons '(:noweb . "yes")
            (assq-delete-all :noweb org-babel-default-header-args)))


;; allow the use of :hidden to hide certain source blocks when a
;; buffer is opened. All others will be visible by default.
(defun mh//individual-visibility-source-blocks ()
  "Fold some blocks in the current buffer."
  (interactive)
  (org-show-block-all)
  (org-block-map
   (lambda ()
     (let ((case-fold-search t))
       (when (and
              (save-excursion
                (beginning-of-line 1)
                (looking-at org-block-regexp))
              (cl-assoc
               ':hidden
               (cl-third
                (org-babel-get-src-block-info))))
         (org-hide-block-toggle))))))
(add-hook 'org-mode-hook (function mh//individual-visibility-source-blocks))

;; use habits
(add-to-list 'org-modules 'org-habit)
(setq org-habit-show-habits nil)

;; property inheritance
(setq org-use-property-inheritance t)

;; agenda view
(setq org-agenda-custom-commands
      '(("c" "Custom agenda view"
         ((tags-todo "hardware|electronics|mechanical_engineering"
                     ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("HOLD")))
                      (org-agenda-overriding-header "Hardware")
                      (org-agenda-prefix-format "  ")
                      (org-agenda-hide-tags-regexp ".*")))
          (tags-todo "software"
                     ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("HOLD")))
                      (org-agenda-overriding-header "Software")))
          (tags-todo "nix"
                     ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("HOLD")))
                      (org-agenda-overriding-header "Nix")))
          (tags-todo "emacs"
                     ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("HOLD")))
                      (org-agenda-overriding-header "Emacs")))
          (tags-todo "read"
                     ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("HOLD")))
                      (org-agenda-overriding-header "Prioritized Reading Material")))))))

;; todo statistics should display all recursive children
(setq org-hierarchical-todo-statistics nil)
;; ;; set default image background color
;; (defun org-display-inline-images--with-color-theme-background-color (args)
;;   "Specify background color of Org-mode inline image through modify `ARGS'."
;;   (let* ((file (car args))
;;          (type (cadr args))
;;          (data-p (caddr args))
;;          (props (cdddr args)))
;;     ;; get this return result style from `create-image'
;;     (append (list file type data-p)
;;             (list :background "white")
;;             props)))

;; (advice-add 'create-image :filter-args
;;             #'org-display-inline-images--with-color-theme-background-color)
;; (advice-remove 'create-image #'org-display-inline-images--with-color-theme-background-color)

;; look for a specified attribute width, otherwise fallback to
;; actual image width
(setq org-image-actual-width nil)

;; fontify when not in polymode
(setq org-src-fontify-natively t)

;; preserve src block indentation
;; this works better with aggressive-indent-mode
(setq org-edit-src-content-indentation 0)
(setq org-src-preserve-indentation t)

;; Don't pretty display things like pi. This makes it harder to
;; edit latex code.
(setq org-pretty-entities nil)
;; When displaying pretty entities, don't display
;; super/subscripts.
(setq org-pretty-entities-include-sub-superscripts nil)

;; permit still typing emphasis characters as normal characters
;; see https://emacs.stackexchange.com/a/16746/20317
(defun mh/org-entity-get-name (char)
  "Return the entity name for CHAR. For example, return \"ast\" for *."
  (let ((ll (append org-entities-user
                    org-entities))
        e name utf8)
    (catch 'break
      (while ll
        (setq e (pop ll))
        (when (not (stringp e))
          (setq utf8 (nth 6 e))
          (when (string= char utf8)
            (setq name (car e))
            (throw 'break name)))))))

(defun mh/org-insert-org-entity-maybe (&rest args)
  "When the universal prefix C-u is used before entering any character,
  insert the character's `org-entity' name if available.

  If C-u prefix is not used and if `org-entity' name is not available, the
  returned value `entity-name' will be nil."
  ;; It would be fine to use just (this-command-keys) instead of
  ;; (substring (this-command-keys) -1) below in emacs 25+.
  ;; But if the user pressed "C-u *", then
  ;;  - in emacs 24.5, (this-command-keys) would return "^U*", and
  ;;  - in emacs 25.x, (this-command-keys) would return "*".
  ;; But in both versions, (substring (this-command-keys) -1) will return
  ;; "*", which is what we want.
  ;; http://thread.gmane.org/gmane.emacs.orgmode/106974/focus=106996
  (let ((pressed-key (substring (this-command-keys) -1))
        entity-name)
    (when (and (listp args) (eq 4 (car args)))
      (setq entity-name (mh/org-entity-get-name pressed-key))
      (when entity-name
        (setq entity-name (concat "\\" entity-name "{}"))
        (insert entity-name)
        (message (concat "Inserted `org-entity' "
                         (propertize entity-name
                                     'face 'font-lock-function-name-face)
                         " for the symbol "
                         (propertize pressed-key
                                     'face 'font-lock-function-name-face)
                         "."))))
    entity-name))

;; Run `org-self-insert-command' only if `mh/org-insert-org-entity-maybe'
;; returns nil.
(advice-add 'org-self-insert-command :before-until #'mh/org-insert-org-entity-maybe)
(advice-remove 'org-self-insert-command #'mh/org-insert-org-entity-maybe)

;; `org-adapt-indentation' indents heading contents to the beginning of the heading. This is nice
;; in a way, but limits the amount of horizontal space when you have deeply-nested headings.
(setq org-adapt-indentation nil)
(setq org-log-done 'time)
(setq org-todo-keywords
      '((sequence "HOLD" "TODO" "FILE" "|" "DONE" "CANCELLED")))
(setq org-capture-templates
      '(("b" "pdf" entry (file "~/doc/notes/wiki.org")
         "* %f
:PROPERTIES:
:NOTER_DOCUMENT: %F
:END:
* outline
%(mh/pdf-outline-to-org-headline \"%F\" 1)")
        ("p" "productivity" entry (file+headline "~/doc/notes/projects/productivity.org" "refile")
         "* TODO %^{PROMPT}")
        ("w" "work" entry (file+headline "~/doc/notes/projects/work.org" "refile")
         "* TODO %^{PROMPT}")))
(setq org-agenda-files '("~/doc/notes/wiki"))
;; use the current file for refile
(setq org-refile-targets '((nil . (:maxlevel . 100))))
;; show candidates as slash-delimited (i.e. science/physics)
(setq org-refile-use-outline-path t)
;; allows helm to get all completion candidates
(setq org-outline-path-complete-in-steps nil)
;; speed up refile
(setq org-refile-use-cache t)
(setq org-agenda-follow-mode t)
;; include plain lists in org cycling, which folds lists by default when a heading is first
;; expanded.
(setq org-cycle-include-plain-lists 'integrate)
;; Set file for the current entry.
(defun org-set-property-file (file)
  (interactive
   (list
    (read-file-name "file: " "~/library/")))
  (org-set-property "Filepath" (concat "[[file:" file "]]")))
;; Outline percentage completion includes all children of node rather than just the direct
;; children.
(setq org-checkbox-hierarchical-statistics nil)

(setq org-html-with-latex 'html)
(setq org-latex-to-html-convert-command
      "latexmlc 'literal:%i' --profile=math --preload=siunitx.sty 2>/dev/null | head -c -1")

(custom-set-variables
 ;; TODO change to _standalone?
 ;; LaTeX preamble for fragments.
 '(org-format-latex-header "\\PassOptionsToPackage{usenames}{xcolor}
\\documentclass[preview]{standalone}
%% Declared math operators
\\usepackage{math_local}
\\usepackage{common_local}"))

;; (defun mh//org-ascent-match-text-baseline (imagefile imagetype)
;;   ""
;;   (if (eq imagetype 'svg)
;;       (let* ((viewbox (split-string
;;                        (xml-get-attribute (car (xml-parse-file imagefile)) 'viewBox)))
;;              (min-y (string-to-number (nth 1 viewbox)))
;;              (height (string-to-number (nth 3 viewbox)))
;;              (ascent (round (* -100 (/ min-y height)))))
;;         (if (or (< ascent 0) (> ascent 100))
;;             'center
;;           ascent))
;;     'center))

(defun mh//org-latex-scale (imagedata imagetype)
  "Scale inline LaTeX fragments to match the height of the surrounding text."
  (let* ((emacs-font-decipt (float (face-attribute 'default :height)))
         ;; standalone document class uses article, which defaults to 10pt
         (latex-font-decipt 100.0)
	 ;; scale factor to equalize height of Emacs and LaTeX text
         (scale-factor 1.14))
    (* scale-factor (/ emacs-font-decipt latex-font-decipt))))

(defun mh/update-org-latex-fragments-in-buffer ()
  "Clear and redisplay all LaTeX fragments in the current buffer."
  (interactive)
  (if (eq major-mode 'org-mode)
      (progn
        (org-clear-latex-preview)
        ;; 16 corresponds to the C-u C-u arg prefix.
        (org-latex-preview 16))))

;; update latex overlays when scaling the frame
(advice-add 'mh/zoom-in :after #'mh/update-org-latex-fragments-in-buffer)
(advice-add 'mh/zoom-out :after #'mh/update-org-latex-fragments-in-buffer)
(advice-add 'mh/zoom-in-selected-frame :after #'mh/update-org-latex-fragments-in-buffer)
(advice-add 'mh/zoom-out-selected-frame :after #'mh/update-org-latex-fragments-in-buffer)

(setq org-latex-fragment-overlay-ascent #'org--match-text-baseline-ascent)
(setq org-latex-fragment-scale #'mh//org-latex-scale)

;; (defun mh//org--make-preview-overlay (beg end image &optional imagetype)
;;   "Build an overlay between BEG and END using IMAGE file.
;; Argument IMAGETYPE is the extension of the displayed image,
;; as a string.  It defaults to \"png\"."
;;   (let ((ov (make-overlay beg end))
;; 	(imagetype (or (intern imagetype) 'png)))
;;     ;; Set the :ascent (vertical position) of the latex fragment
;;     ;; overlay as 100*(min-y/height), where min-y and height are
;;     ;; extracted from the SVG file's viewbox.
;;     (let ((image-ascent (if (eq imagetype 'svg)
;;                             (let* ((viewbox (split-string
;;                                              (xml-get-attribute (car (xml-parse-file image)) 'viewBox)))
;;                                    (min-y (string-to-number (nth 1 viewbox)))
;;                                    (height (string-to-number (nth 3 viewbox)))
;;                                    (ascent (round (* -100 (/ min-y height)))))
;;                               (if (or (< ascent 0) (> ascent 100))
;;                                   'center
;;                                 ascent))
;;                           'center)))
;;       (overlay-put ov 'org-overlay-type 'org-latex-overlay)
;;       (overlay-put ov 'evaporate t)
;;       (overlay-put ov
;; 		   'modification-hooks
;; 		   (list (lambda (o _flag _beg _end &optional _l)
;; 			   (delete-overlay o))))
;;       (overlay-put ov
;; 		   'display
;; 		   (list 'image :type imagetype :file image :ascent image-ascent)))))

;; (advice-add 'org--make-preview-overlay :override #'mh//org--make-preview-overlay)
;; (advice-remove 'org--make-preview-overlay #'mh//org--make-preview-overlay)

;; change default latex packages. grffile prevents asymptote from
;; working correctly. inputenc and fontenc aren't needed with
;; luatex.

;; Don't automatically attempt to resolve open clocks when
;; clocking in. Functionally, this is a nice feature, but it
;; creates a significant delay when there are many agenda
;; files. The proper solution seems to be to call
;; `org-resolve-clocks' manually.
(setq org-clock-auto-clock-resolution nil)

;; Use footnotes for references.
(setq org-footnote-section "references")

;; always leave a newline at the end of a heading section. `auto'
;; doesn't seem to be good enough at guessing.
(setq org-blank-before-new-entry
      '((heading . t)
        (plain-list-item . auto)))

(custom-set-variables
 '(org-columns-default-format (concat "%60ITEM(Task) "
                                      "%CLOCKSUM")))
;; keep the same column format in the agenda columns view
(setq org-agenda-overriding-columns-format org-columns-default-format)

(setq luasvgm
      `(luasvgm :programs ("latex" "dvisvgm" "sed")
                :description "dvi > svg"
                :message "you need to install latex, dvisvgm, and sed."
                :image-input-type "dvi"
                :image-output-type "svg"
		:latex-compiler ("latex -output-directory=%o %f")
                :image-converter (,(concat "dvisvgm --no-fonts --exact-bbox -o %O %f"
                                           " && sed -i 's/#000000/currentColor/g; s/#ffffff/none/g' %O"))))

(custom-set-variables
 '(org-format-latex-options '(:foreground "Black"
                              :background "Transparent"
                              :scale 1.0
                              :html-foreground "Black"
                              :html-background "Transparent"
                              :html-scale 1.0
                              :matchers
                              ;; Only delimit with \(\).
                              ("\\("))))

(add-to-list 'org-preview-latex-process-alist luasvgm)
(setq org-preview-latex-default-process 'luasvgm)

;; fontify latex fragments (inline latex) natively
(setq org-highlight-latex-and-related '(native))

;; list of programs to use for opening links from org-mode
(setq org-file-apps '((auto-mode . emacs)
                      ("\\.mm\\'" . default)
                      ("\\.x?html?\\'" . default)
                      ("\\.pdf\\'" . default)
                      ("\\.gif\\'" . (lambda (file link)
                                       (let ((my-image (create-image file))
                                             (tmpbuf (get-buffer-create "*gif")))
                                         (switch-to-buffer tmpbuf)
                                         (erase-buffer)
                                         (insert-image my-image)
                                         (call-interactively 'image-mode)
                                         (image-animate my-image))))))

(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((C . t)
   (awk . t)
   (calc . t)
   (clojure . t)
   (comint . t)
   (css . t)
   (ditaa . t)
   (dot . t)
   (emacs-lisp . t)
   (fortran . t)
   (gnuplot . t)
   (haskell . t)
   (java . t)
   (js . t)
   (latex . t)
   (lilypond . t)
   (lisp . t)
   (lua . t)
   (makefile . t)
   (matlab . t)
   (maxima . t)
   (ocaml . t)
   (octave . t)
   (org . t)
   (perl . t)
   (plantuml . t)
   (python . t)
   (ref . t)
   (ruby . t)
   (sass . t)
   (scheme . t)
   (screen . t)
   (shell . t)
   (sql . t)
   (sqlite . t)))

;; org crypt
(require 'org-crypt)

(setq org-crypt-disable-auto-save t)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
(setq org-crypt-key "huszaghmatt@gmail.com")

;; identify org headlines with UUIDs
;; see https://writequit.org/articles/emacs-org-mode-generate-ids.html
(require 'org-id)
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

;; don't bastardize windows when editing a source block
(setq org-src-window-setup 'other-window)

;; make contrib files visible
;; TODO modify this for nixpkgs
(add-to-list 'load-path (concat user-emacs-directory "straight/repos/org/contrib/lisp") t)

(setq mh-latex-scale 1.0)
(defun mh/increase-latex-scale ()
  (interactive)
  (setq mh-latex-scale (+ mh-latex-scale 0.1))
  (call-interactively 'revert-buffer))

(defun mh/decrease-latex-scale ()
  (interactive)
  (setq mh-latex-scale (- mh-latex-scale 0.1))
  (call-interactively 'revert-buffer))

(defun mh/org-set-property-from-link ()
  (interactive)
  (org-set-property (org-read-property-name)
                    (org-insert-link)))

(defun mh/org-clear-cache ()
  (interactive
   (org-refile-cache-clear)))

(defun mh/org-mktmp (&optional fname)
  "Make a temporary directory and return the path of that
directory plus `FNAME', if `FNAME' is provided. If not simply
return the directory path. The temporary directory is given a
unique name based on the full org header path. This is meant as a
convenient way to create temporary directories for noweb babel
files from an org buffer."
  (let* ((tmpdir (sha1 (mapconcat 'identity (org-get-outline-path t) "/")))
         (dir (concat "/tmp/" tmpdir)))
    (mkdir dir t)
    (if fname
        (concat dir "/" fname)
      dir)))

(defun mh/org-toggle-hide-emphasis-markers ()
  (interactive)
  "Toggle `org-hide-emphasis-markers'."
  (if (eq t org-hide-emphasis-markers)
      (setq org-hide-emphasis-markers nil)
    (setq org-hide-emphasis-markers t)))

(defun mh//org-pdf-outline-headline-to-noter-format (node)
  "Convert the old outline format (with trailing page number in parentheses) to new noter page format.
NODE is the node representing the headline node."
  (let* ((headline-text (org-ml-get-property :raw-value node))
         (begin (org-ml-get-property :begin node))
         (match-position (string-match "\\(.*\\) (\\([1-9]+\\))" headline-text)))
    (if match-position
        (let ((headline-no-number (substring headline-text (match-beginning 1)
                                             (match-end 1)))
              (page-number (substring headline-text (match-beginning 2)
                                      (match-end 2))))
          (goto-char begin)
          (org-edit-headline headline-no-number)
          (org-set-property "NOTER_PAGE" page-number)
          (message (concat "Converted legacy headline `"
                           headline-no-number
                           "' "
                           "with number `"
                           page-number
                           "' to noter format."))))))

(defun mh/update-all-pdf-outline-headlines-from-legacy-to-noter ()
  "Convert all headlines from the legacy format in which the
page number is a trailing number in parentheses to the new org
noter format.

TODO this works but is slow."
  (interactive)
  (org-api/map-nodes-recursive-in-current-buffer
   'mh//org-pdf-outline-headline-to-noter-format
   '(headline)))

(defun mh/org-adapt-line-length-to-visual-line-mode ()
  "Remove line breaks in org-mode inserted by fill-column."
  (interactive)
  (setq-local fill-column 1000000)
  (org-api/map-nodes-recursive-in-current-buffer
   (lambda (node)
     (let ((begin (org-ml-get-property :begin node)))
       (goto-char begin)
       (org-fill-paragraph)))
   '((:or paragraph item))))

(defun mh/org-replace-common-legacy-symbols-in-current-buffer ()
  ""
  (interactive)
  (mh/replace-all-alist-items-in-current-buffer
   '(("_{in}" . "_{\\\\mathrm{in}}")
     ("_{out}" . "_{\\\\mathrm{out}}")
     ("_{\\\\mathit{CC}}" . "_{\\\\mathrm{CC}}")
     ("_{CC}" . "_{\\\\mathrm{CC}}")
     ("_{EE}" . "_{\\\\mathrm{EE}}")
     ("_{CE}" . "_{\\\\mathrm{CE}}")
     ("_{BE}" . "_{\\\\mathrm{BE}}")
     ("V_T" . "V_{\\\\mathrm{T}}")
     ("V_A" . "V_{\\\\mathrm{A}}")
     ("V_E" . "V_{\\\\mathrm{E}}")
     ("R_E" . "R_{\\\\mathrm{E}}")
     ("I_E" . "I_{\\\\mathrm{E}}")
     ("V_B" . "V_{\\\\mathrm{B}}")
     ("R_B" . "R_{\\\\mathrm{B}}")
     ("I_B" . "I_{\\\\mathrm{B}}")
     ("V_C" . "V_{\\\\mathrm{C}}")
     ("R_C" . "R_{\\\\mathrm{C}}")
     ("I_C" . "I_{\\\\mathrm{C}}")
     ("_{load}" . "_{\\\\mathrm{load}}")
     ("_{source}" . "_{\\\\mathrm{source}}")
     (",>=stealth" . ""))))

(defun mh/org-replace-old-latex-blocks-in-current-buffer ()
  "WARNING: this function isn't very robust and can only be run once."
  (interactive)
  (mh/replace-all-alist-items-in-current-buffer
   '(;; aligned blocks in latex fragment
     ("\\\\(\\\\begin{aligned}" . "#+begin_src latex :hidden\n\\\\begin{align}")
     ("\\\\end{aligned}\\\\)" . "\\\\end{align}\n#+end_src")
     ;; aligned without inline math delimiter
     ;; TODO can't be run twice
     ("\\\\begin{aligned}" . "#+begin_src latex :hidden\n\\\\begin{align}")
     ("\\\\end{aligned}" . "\\\\end{align}\n#+end_src")
     ;; align* without inline math delimiter
     ;; TODO can't be run twice
     ("\\\\begin{align\\*}" . "#+begin_src latex :hidden\n\\\\begin{align}")
     ("\\\\end{align\\*}" . "\\\\end{align}\n#+end_src")
     ;; circuitikz blocks
     ;; TODO can't be run twice
     ("\\\\begin{circuitikz}" . "#+begin_src latex :hidden\n\\\\begin{circuitikz}")
     ("\\\\end{circuitikz}" . "\\\\end{circuitikz}\n#+end_src")
     ;; latex fragments that should really be src display blocks
     ("^\\\\(\n" . "#+begin_src latex :hidden\n\\\\begin{equation}\n")
     ("^\\\\)" . "\\\\end{equation}\n#+end_src")
     ;; latex blocks
     ("^\\\\begin{latex}" . "#+begin_src latex :hidden")
     ("^\\\\end{latex}" . "#+end_src"))))

(defun mh/org-insert-file-image (file)
  "Insert an inline image at point from FILE into an Org buffer."
  (interactive "fFile: ")
  (let ((prefix (if (string-equal (file-name-extension file) "svg")
                    ""
                  ;; limit size to not get huge images and slow things down
                  "#+ATTR_ORG: :width 250\n"))
        (id (mh//rand-hex-string 7)))
    (insert
     (concat prefix
             "#+NAME: fig:" id "\n"
             "[[file:"
             (file-relative-name file)
             "]]"))
    ;; add reference to kill ring
    (kill-new (concat "cref:fig:" id)))
  (org-display-inline-images))

(defun mh/org-insert-sections-personal-machine ()
  "Insert sections for a personal machine wiki page."
  (interactive)
  (insert
   (concat "* specifications\n"
           "* options\n"
           "* operating instructions\n"
           "** installation\n"
           "** interface\n"
           "*** front panel\n"
           "**** connectors\n"
           "*** back panel\n"
           "**** connectors\n"
           "* theory of operation\n"
           "** hardware\n"
           "** software\n"
           "* applications\n"
           "* construction\n"
           "** assembly locator\n"
           "** circuit assemblies\n"
           "*** components\n"
           "*** component locator\n"
           "*** images\n"
           "** exploded views\n"
           "* assembly and disassembly\n"
           "* functional verification\n"
           "* troubleshooting\n"
           "* maintenance\n"
           "** preliminary maintenance\n"
           "*** non-volatile storage backup\n"
           "*** components that require immediate replacement\n"
           "** general maintenance\n"
           "*** component aging and failure\n"
           "*** cleaning\n"
           "* calibration and adjustment\n"
           "* accessories\n"
           "* modifications\n"
           "* machines\n"
           "** status\n"
           "** options\n"
           "** initial instrument state\n"
           "*** visual inspection\n"
           "**** exterior\n"
           "**** interior\n"
           "** functional verification log\n"
           "** calibration and adjustment log\n"
           "** repair log\n"
           "** modifications\n")))

(defun mh/org-insert-sections-circuit ()
  "Insert sections for a circuit wiki page."
  (interactive)
  (insert
   (concat "** schematic\n"
           "** operation\n"
           "** configuration\n"
           "** simulation\n"
           "** limitations\n"
           "** alternatives\n"
           "** variants\n"
           "** references\n"
           "** glossary\n")))

;; TODO doesn't quite work with org-fragtog yet.
(defun mh/org-open-overlay-file-at-point ()
  "Open the file storing the latex fragment at point."
  (interactive)
  (let ((pt (point)))
    ;; If we're using a package like org-fragtog, we won't know we're
    ;; at an overlay if we keep the cursor positioned over it.
    (save-excursion
      (org-back-to-heading-or-point-min)
      (org-display-inline-images t t)
      ;;(goto-char 0)
      (let ((ov (overlays-at pt)))
        (if (eq nil ov)
            (message "There is no overlay at the current position.")
          (let ((image (get-char-property pt 'display)))
            (find-file (image-property image :file))))))))

(defun mh/heading-filepath ()
  (file-truename
   (car (s-split "]" (car (last (s-split "file:" (org-entry-get (point) "NOTER_DOCUMENT" t))))))))

(defun mh/open-book-from-outline ()
  (interactive)
  (setq file (mh/heading-filepath))
  (setq page (string-to-number (org-entry-get (point) "NOTER_PAGE" t)))
  (find-file-other-window file)
  (pdf-view-goto-page page))

(defun mh/pdf-outline-to-org-headline (file base-depth)
  "Return a set of org headings from a pdf in FILE.
BASE-DEPTH is the depth (i.e. number of '*') of the destination
org file headline, and TODOP asks whether we should turn the
outline into a set of todo entries. Set 1 for yes and 0 for no.

Do not call this directly! It will simply discard the result. Use
org-capture instead."
  (interactive
   "fPDF file: \nnHeadline Depth: \n")
  (let ((outline (pdf-info-outline file))
        (org-outline ""))
    (dolist (item outline)
      (let-alist item
        (setq i (+ .depth base-depth))
        (while (> i 0)
          (setq org-outline (concat org-outline "*"))
          (setq i (- i 1)))
        (setq org-outline (concat org-outline " HOLD " .title "\n"))
        (setq org-outline (concat org-outline ":PROPERTIES:\n"
                                  ":NOTER_PAGE: " (number-to-string .page) "\n"
                                  ":END:\n"))))
    org-outline))

;; TODO laas-mathp sort of already does this.
(defun mh/org-latex-math-p ()
  "Indicates whether point is within a LaTeX math environment within an org buffer."
  (or (and (org-inside-LaTeX-fragment-p)
           (texmathp))
      (and (org-in-src-block-p)
           (equal (org-element-property :language (org-element-at-point))
                  "latex")
           (texmathp))))

(defun mh/org-screenshot (fname)
  "Take a screenshot and save it to the data subdirectory of the current directory."
  (interactive "sFile name (excluding .png extension): ")
  (let ((fpath (expand-file-name
                (concat (file-name-directory buffer-file-name)
                        "/data/" fname ".png"))))
    (if (and (file-exists-p fpath)
             (not (string-equal (read-string "Overwrite [y/n]?: ") "y")))
        (display-warning :warning
          (concat "File " fpath " already exists\n"))
      (call-process "import" nil "*ImageMagick import*" nil fpath)
      (mh/org-insert-file-image fpath))))

(defun mh/org-clocktable-problem-split-formatter (ipos tables params)
  "Custom formatter for clocktable to separate time spent on problems/exercises vs. everything else."
  (let ((problem-time 0)
        (non-problem-time 0)
        (case-fold-search t)) ;; case-insensitive matching
    (dolist (row (nth 2 tables)) ;; row = (level headline tags time ...)
      (let* ((headline (nth 1 row))
             (time (nth 3 row))
             ;; This assumes headline includes the full path like "Chapter > Section > Exercises"
             ;; You can inspect this in the default clocktable output
             )
        (if (string-match "\\b\\(problems\\|exercises\\)\\b" headline)
            (setq problem-time (+ problem-time time))
          (setq non-problem-time (+ non-problem-time time)))))
    (insert "* Clock summary\n")
    (insert (format "- Problems/Exercises: %s\n" (org-duration-from-minutes problem-time)))
    (insert (format "- Reading/Notes:      %s\n" (org-duration-from-minutes non-problem-time)))
    (insert (format "- Total:              %s\n" (org-duration-from-minutes (+ problem-time non-problem-time))))))

(defun mh/org-clocktable-formatter (ipos tables params)
  (let ((problem-time 0)
        (exercise-time 0)
        (notes-time 0)
        (summary-time 0))))

(defun mh/org-sort-top-level-headings ()
  "Sort all top-level headings in the current Org buffer alphanumerically.
The sort is case-insensitive and ignores TODO keywords, priorities,
tags, and statistics cookies. Content before the first heading is
preserved.  Written by Claude Opus
4.5 (https://claude.ai/chat/625fd895-b7b4-4fc1-8f6a-25412a700b83)."
  (interactive)
  (let (entries preamble)
    (save-excursion
      ;; Collect preamble (content before first heading)
      (goto-char (point-min))
      (setq preamble
            (if (re-search-forward "^\\* " nil t)
                (buffer-substring (point-min) (match-beginning 0))
              (user-error "No top-level headings found")))
      ;; Collect all top-level entries (heading + entire subtree)
      (goto-char (point-min))
      (while (re-search-forward "^\\* \\(.+\\)$" nil t)
        (let ((title (match-string-no-properties 1))
              (beg (match-beginning 0))
              end)
          (save-excursion
            (setq end (if (re-search-forward "^\\* " nil t)
                          (match-beginning 0)
                        (point-max))))
          (push (cons (mh//org-sort--extract-plain-title title)
                      (buffer-substring beg end))
                entries))))
    ;; Sort alphanumerically by plain title (case-insensitive)
    (setq entries (sort entries (lambda (a b)
                                  (string< (downcase (car a))
                                           (downcase (car b))))))
    ;; Replace buffer contents
    (erase-buffer)
    (insert preamble)
    (dolist (entry entries)
      (insert (cdr entry)))))

(defun mh//org-sort--extract-plain-title (heading-text)
  "Extract plain title from HEADING-TEXT, removing Org metadata.
Strips TODO keywords, priority cookies, tags, and statistics cookies.
Written by Claude Opus
4.5 (https://claude.ai/chat/625fd895-b7b4-4fc1-8f6a-25412a700b83)."
  (let ((text heading-text))
    ;; Remove TODO keywords (matches org-todo-regexp if available)
    (when (and (boundp 'org-todo-regexp) org-todo-regexp)
      (setq text (replace-regexp-in-string
                  (concat "^" org-todo-regexp " +") "" text)))
    ;; Remove priority cookie [#A], [#B], etc.
    (setq text (replace-regexp-in-string "^\\[#[A-Z]\\] +" "" text))
    ;; Remove statistics cookies [1/3] or [50%]
    (setq text (replace-regexp-in-string "\\[\\(?:[0-9]+/[0-9]+\\|[0-9]+%\\)\\] *" "" text))
    ;; Remove tags at end :tag1:tag2:
    (setq text (replace-regexp-in-string "\\s-+:[[:alnum:]_@#%:]+:\\s-*$" "" text))
    ;; Trim whitespace
    (string-trim text)))

(define-advice org-latex-preview (:around (orig &rest args) mh/skip-on-tramp)
  "Don't render latex previews for remote buffers — latex would run
  on the remote host but the .tex file is generated locally."
  (if (file-remote-p default-directory)
      (message "Skipping org-latex-preview for remote buffer")
    (apply orig args)))

(provide 'c-org)
;;; c-org.el ends here
