;;; c-ob.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (and (featurep 'org-api)
             (featurep 'org-texnum))
  (mh:log-init "ERROR" "attempted to load 'c-ob before 'org-api and 'org-texnum"))

(org-babel-lob-ingest (concat user-emacs-directory "config/lob.org"))

(require 's)

(setq org-babel-latex-pdf-svg-process (concat "inkscape --pdf-poppler %f -T -l -o %O"
                                              " && sed -i 's/#000000/currentColor/g; s/#111111/none/g' %O"))

;; TODO customizations if patch accepted
(defun latex-preamble-by-backend (params)
  "Set the latex source block preamble."
  (concat "\\documentclass{"
          (cdr (assoc :_class params))
          "}"))

(setq org-babel-latex-preamble
      (lambda (params)
        (latex-preamble-by-backend params)))

(setq org-babel-latex-begin-env
      (lambda (_)
        "\\begin{document}"))

(setq org-babel-latex-end-env
      (lambda (_)
        "\\end{document}"))

(use-package ox-latex
  :config
  (defun mh//concat-list (list)
    (let ((res ""))
      (dolist (elem list)
        (setq res (concat res elem)))
      res))

  (defun mh//header-match (elem match)
    "Returns `t' if MATCH is explicitly a header of ELEM.
Explicit in this context means that it's literally written in the
file rather than being provided as a default header argument."
    (let* ((elem (org-element-at-point))
           (elem-header (append (list (org-element-property :parameters elem))
                                (org-element-property :header elem)))
           (matchp nil))
      (dolist (elt elem-header)
        (if (string-match match elt)
            (setq matchp t)))
      matchp))

  (defun mh//org-src-block-contents ()
    (let ((elem (org-element-at-point)))
      (concat (org-element-property :value elem)
              (mh//concat-list (org-element-property :header elem)))))

  (defun mh//org-src-block-result-filename ()
    (let* ((elem (org-element-at-point))
           (class-mathp (mh//header-match elem ":_class math")))
      (if (and org-export-current-backend class-mathp)
          nil
        (concat "tmp/"
        	(sha1 (mh//org-src-block-contents))
                ".svg"))))

  (defun mh//org-src-block-latex-post ()
    ""
    (let* ((elem (org-element-at-point))
           (class-mathp (mh//header-match elem ":_class math"))
           (wrap-str "attr_wrap(htmlwidth=\"100%\", orgwidth=\"1000\", name=\"\", data=*this*)")
           (backend org-export-current-backend))
      (if backend
          ;; for latex, we still want to wrap the caption if it's a
          ;; figure
          (if (string= backend "latex")
              (if class-mathp
                  nil
                wrap-str)
            (if (and (string= backend "html") class-mathp)
                "latexml_proc(data=*this*)"
              wrap-str))
        wrap-str)))

  (defun mh//org-src-block-latex-results ()
    ""
    (let* ((elem (org-element-at-point))
           (class-mathp (mh//header-match elem ":_class math")))
      (if org-export-current-backend
          (let ((backend org-export-current-backend))
            (if (or (string= backend "latex")
                    (and (string= backend "html") class-mathp))
                "latex"
              "file link replace"))
        "file link replace")))

  (defun mh//org-src-block-latex-file-description ()
    ""
    (let* ((elem (org-element-at-point))
           (clickablep (mh//header-match elem ":_clickable"))
           (backend org-export-current-backend))
      (if (and clickablep (string= backend "html"))
          (concat "file:" (mh//org-src-block-result-filename))
        [])))

  (defun mh//org-src-block-latex-wrap ()
    (let* ((elem (org-element-at-point))
           (class-mathp (mh//header-match elem ":_class math"))
           (backend org-export-current-backend))
      (if backend
          (if (string= backend "latex")
              nil
            (if (and (string= backend "html") class-mathp)
                nil
              "results"))
        "results")))

  (setq org-babel-default-header-args:latex
        `((:exports . "results")
          (:results . (lambda ()
                        (mh//org-src-block-latex-results)))
          (:wrap . (lambda ()
                     (mh//org-src-block-latex-wrap)))
          (:cache . "yes")
          (:file . (lambda ()
                     (mh//org-src-block-result-filename)))
          (:file-desc . (lambda ()
                          (mh//org-src-block-latex-file-description)))
          (:post . (lambda ()
                     (mh//org-src-block-latex-post)))))

  (setq org-html-with-latex 'html)
  (setq org-latex-to-html-convert-command
        "latexmlc 'literal:%i' --profile=math --preload=siunitx.sty 2>/dev/null | head -c -1")

  (defun by-backend (blist)
    (let ((ret nil))
      (if org-export-current-backend
          (let* ((backend-name org-export-current-backend)
                 (elem (assoc backend-name blist)))
            (if elem
                (setq ret (cdr elem))))
        (let ((elem (assoc t blist)))
          (setq ret (cdr elem))))
      (eval ret))))

(defun mh/update-eqn-numbers-in-section ()
  ""
  (interactive)
  (let ((beg (if (org-before-first-heading-p) (point-min)
	       (save-excursion
		 (org-with-limited-levels (org-back-to-heading t) (point)))))
	(end (org-with-limited-levels (org-entry-end-position)))
        (count 1))
    (save-excursion
      (goto-char beg)
      (while (re-search-forward
              (rx (or "\\tag" "number=")
                  "{"
                  (group (+ digit))
                  "}") end t)
        (replace-match (format "%d" count) nil nil nil 1)
        (setq count (1+ count))))))

(defun mh/org-in-latex-blockp ()
  "Indicate if we're inside a latex source block."
  (let ((elem (org-ml-parse-element-at (point))))
    (if (and (org-ml-is-type 'src-block elem)
             (string-equal (org-ml-get-property :language elem) "latex"))
        t
      nil)))

(require 'org-api)
(require 'org-texnum)

(defun mh//convert-latex-src-block-to-export-block (node)
  "Convert a LaTeX src block to an export block.
NODE is the node in the parse tree corresponding to the LaTeX src block."
  (let ((begin (org-ml-get-property :begin node))
        (value (org-ml-get-property :value node))
        (end (org-ml-get-property :end node)))
    (goto-char begin)
    (delete-region begin end)
    (insert (concat "#+BEGIN_EXPORT latex\n"
                    value
                    "\n"
                    "#+END_EXPORT\n\n"))))

(defun mh//convert-latex-blocks-for-latex-export ()
  "Convert LaTeX src blocks in the current buffer to export blocks."
  (org-api/map-nodes-recursive-in-current-buffer 'mh//convert-latex-src-block-to-export-block
                                                 '((:and src-block
                                                    (:language "latex")))))

(defun mh//latex-export-remove-results-blocks (backend)
  "Remove results blocks.
BACKEND is the export backend."
  (when (org-export-derived-backend-p backend 'latex)
    (org-api/map-nodes-recursive-in-current-buffer 'org-api/delete-node
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

(add-hook 'org-export-before-processing-hook
          'mh//latex-export-latex-src-block-convert)

(add-hook 'org-export-before-processing-hook
          'mh//latex-export-remove-file-link-descriptions)

(provide 'c-ob)
;;; c-ob.el ends here
