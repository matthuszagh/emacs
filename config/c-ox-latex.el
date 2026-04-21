;;; c-ox-latex.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'ox-latex)

(custom-set-variables
 ;; use lualatex as the latex compiler. TODO is this needed if we use
 ;; latexmk in `org-latex-pdf-process'?
 '(org-latex-compiler "lualatex")
 '(org-latex-pdf-process
   '("latexmk -f -interaction=nonstopmode -output-directory=%o %f"))
 '(org-latex-default-class "_article")
 '(org-latex-classes
   `(("_article" ,(concat "\\documentclass{_article}\n"
                          "\\def\\pc{100}\n"
                          "\\definecolor{bg}{HTML}{ffffff}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
 ;; Include all necessary packages in the document class.
 '(org-latex-default-packages-alist nil)
 ;; TODO what's the difference between
 ;; `org-latex-default-packages-alist' and `org-latex-packages-alist'?
 '(org-latex-packages-alist nil)
 '(org-latex-default-figure-position "htb")
 ;; use minted instead of listings for code blocks
 '(org-latex-listings 'minted)
 ;; Do not specify a default image width. This makes it possible to
 ;; use the intrinsic image size, which is preferable since images
 ;; should be designed explicitly for inclusion in the LaTeX
 ;; file. When images do require a non-intrinsic width, this must be
 ;; specified manually.
 '(org-latex-image-default-width nil)
 ;; Require images be explicitly centered. Otherwise, they're always
 ;; wrapped in a center environment.
 '(org-latex-images-centered nil)
 ;; Use our own labels and CUSTOM_ID for cross-references. This is
 ;; necessary for org-ref to work.
 '(org-latex-prefer-user-labels t)
 ;; Language-specific environments.
 '(org-latex-custom-lang-environments
   '((python "\\begin{code}[%o]{python}
%s\\end{code}")
     (sage "\\begin{code}[%o]{sage}
%s\\end{code}")))
 '(org-latex-caption-above nil))

(defun mh//convert-latex-src-block-to-export-block (node)
  "Convert a LaTeX src block to an export block.
NODE is the node in the parse tree corresponding to the LaTeX src
block.  This also expands the source block to include all
parameters and noweb references."
  (let ((begin (org-ml-get-property :begin node))
        (end (org-ml-get-property :end node)))
    (goto-char begin)
    (let* ((info (org-babel-get-src-block-info))
           (params (nth 2 info))
           (body (org-babel--expand-body info)))
      (delete-region begin end)
      (insert (concat "#+BEGIN_EXPORT latex\n"
                      (org-babel-expand-body:latex body params)
                      "\n"
                      "#+END_EXPORT\n\n")))))

;; TODO LaTeX export stupidly cannot insert latex source blocks
;; directly into the resulting tex file. When :exports code is used,
;; the latex code goes into a listing or minted. When :results value
;; latex is used, it gets wrapped into a results environment, which
;; doesn't exist. So, we use pre export hooks to remedy this. This
;; should be fixed in org itself.

(defun mh//convert-latex-blocks-for-latex-export ()
  "Convert LaTeX src blocks in the current buffer to export blocks."
  (org-api/map-nodes-recursive-in-current-buffer
   'mh//convert-latex-src-block-to-export-block
   '((:and src-block
      (:language "latex")))))

(defun mh//latex-export-remove-results-blocks (backend)
  "Remove results blocks.
BACKEND is the export backend."
  (when (org-export-derived-backend-p backend 'latex)
    (org-api/map-nodes-recursive-in-current-buffer
     'org-api/delete-node
     '((:and special-block
        (:type "results"))))))

(defun mh//remove-file-link-descriptions ()
  "Remove file link descriptions."
  (goto-char 0)
  (while (re-search-forward "\\[\\[file:\\(.*\\)\\]\\[file:.*\\]\\]" nil t)
    (replace-match (concat "[[file:"
                           (match-string-no-properties 1)
                           "]]"))))

(defun mh//latex-export-remove-file-link-descriptions (backend)
  "Remove file link descriptions during LaTeX export."
  (when (org-export-derived-backend-p backend 'latex)
    (mh//remove-file-link-descriptions)))

(defun mh//latex-export-latex-src-block-convert (backend)
  "Replace LaTeX src blocks with LaTeX export blocks.
BACKEND is the export backend."
  (when (org-export-derived-backend-p backend 'latex)
    (mh//convert-latex-blocks-for-latex-export)))

(add-hook 'org-export-before-processing-hook
          'mh//latex-export-remove-results-blocks)
(remove-hook 'org-export-before-processing-hook
             'mh//latex-export-remove-results-blocks)
;; run after code blocks executed
(add-hook 'org-export-before-parsing-hook
          'mh//latex-export-remove-results-blocks)
;; TODO
(remove-hook 'org-export-before-parsing-hook
             'mh//latex-export-remove-results-blocks)

(add-hook 'org-export-before-processing-hook
          'mh//latex-export-latex-src-block-convert)
;; TODO
(remove-hook 'org-export-before-processing-hook
             'mh//latex-export-latex-src-block-convert)

(add-hook 'org-export-before-processing-hook
          'mh//latex-export-remove-file-link-descriptions)

;; Move author, date and title after \begin{document}. This should be
;; customizable in org. Some document classes require these in the
;; preamble, and others require it in the document. See
;; https://tex.stackexchange.com/questions/92702/should-i-place-title-author-date-in-the-preamble-or-after-begindocument.
(defun mh//org-latex-template (contents info)
  "Return complete document string after LaTeX conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options."
  (let ((title (org-export-data (plist-get info :title) info))
	(spec (org-latex--format-spec info)))
    (concat
     ;; Time-stamp.
     (and (plist-get info :time-stamp-file)
	  (format-time-string "%% Created %Y-%m-%d %a %H:%M\n"))
     ;; LaTeX compiler.
     (org-latex--insert-compiler info)
     ;; Document class and packages.
     (org-latex-make-preamble info)
     ;; Possibly limit depth for headline numbering.
     (let ((sec-num (plist-get info :section-numbers)))
       (when (integerp sec-num)
	 (format "\\setcounter{secnumdepth}{%d}\n" sec-num)))
     ;; Hyperref options.
     (let ((template (plist-get info :latex-hyperref-template)))
       (and (stringp template)
            (format-spec template spec)))
     ;; Document start.
     "\\begin{document}\n\n"
     ;; Author.
     (let ((author (and (plist-get info :with-author)
			(let ((auth (plist-get info :author)))
			  (and auth (org-export-data auth info)))))
	   (email (and (plist-get info :with-email)
		       (org-export-data (plist-get info :email) info))))
       (cond ((and author email (not (string= "" email)))
	      (format "\\author{%s\\thanks{%s}}\n" author email))
	     ((or author email) (format "\\author{%s}\n" (or author email)))))
     ;; Date.
     (let ((date (and (plist-get info :with-date) (org-export-get-date info))))
       (format "\\date{%s}\n" (org-export-data date info)))
     ;; Title and subtitle.
     (let* ((subtitle (plist-get info :subtitle))
	    (formatted-subtitle
	     (when subtitle
	       (format (plist-get info :latex-subtitle-format)
		       (org-export-data subtitle info))))
	    (separate (plist-get info :latex-subtitle-separate)))
       (concat
	(format "\\title{%s%s}\n" title
		(if separate "" (or formatted-subtitle "")))
	(when (and separate subtitle))))

     ;; Title command.
     (let* ((title-command (plist-get info :latex-title-command))
            (command (and (stringp title-command)
                          (format-spec title-command spec))))
       (org-element-normalize-string
	(cond ((not (plist-get info :with-title)) nil)
	      ((string= "" title) nil)
	      ((not (stringp command)) nil)
	      ((string-match "\\(?:[^%]\\|^\\)%s" command)
	       (format command title))
	      (t command))))
     ;; Table of contents.
     (let ((depth (plist-get info :with-toc)))
       (when depth
	 (concat (when (integerp depth)
		   (format "\\setcounter{tocdepth}{%d}\n" depth))
		 (plist-get info :latex-toc-command))))
     ;; Document's body.
     contents
     ;; Creator.
     (and (plist-get info :with-creator)
	  (concat (plist-get info :creator) "\n"))
     ;; Document end.
     "\\end{document}")))

;; TODO remove this when we've customized org.
(advice-add 'org-latex-template :override 'mh//org-latex-template)

(defun mh/org-export-latex ()
  "Call `org-latex-export-to-latex' asynchronously."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (async-start (lambda ()
                   (load "~/.config/emacs/pre-init.el")
                   (load "~/.config/emacs/straight/repos/straight.el/bootstrap.el")
                   (load "~/.config/emacs/config/c-no-littering.el")
                   (load "~/.config/emacs/config/c-org.el")
                   (load "~/.config/emacs/config/c-org-ml.el")
                   (load "~/.config/emacs/config/c-org-api.el")
                   (load "~/.config/emacs/config/c-org-texnum.el")
                   (load "~/.config/emacs/config/c-ob.el")
                   (load "~/.config/emacs/config/c-ob-latex.el")
                   (load "~/.config/emacs/config/c-ox.el")
                   (load "~/.config/emacs/config/c-ox-latex.el")
                   (find-file file-name)
                   (org-latex-export-to-latex))
                 (lambda (_)
                   (message "mh/org-export-latex complete")))))

(defun mh/latex-export-filter-final-output-remove-results (text backend info)
  "Remove all results environments, but keep their content."
  (when (org-export-derived-backend-p backend 'latex)
    (replace-regexp-in-string
     "\\\\end{results}\n" ""
     (replace-regexp-in-string "\\\\begin{results}\n" "" text))))

(defun mh/latex-export-filter-final-output-use-fancyvrb (text backend info)
  "Replace verbatim with Verbatim."
  (when (org-export-derived-backend-p backend 'latex)
    (replace-regexp-in-string "verbatim" "Verbatim" text)))

;; TODO custom-set-variables doesn't work for this.
(setq org-export-filter-final-output-functions
      (append org-export-filter-final-output-functions
              '(mh/latex-export-filter-final-output-remove-results)
              '(mh/latex-export-filter-final-output-use-fancyvrb)))

(provide 'c-ox-latex)
;;; c-ox-latex.el ends here
