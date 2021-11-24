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
 '(org-latex-default-class "default")
 '(org-latex-classes
   (append `(("default" ,(concat "\\documentclass{default}\n"
                                 "\\def\\pc{100}\n"
                                 "\\definecolor{bg}{HTML}{ffffff}")
              ("\\section{%s}" . "\\section*{%s}")
              ("\\subsection{%s}" . "\\subsection*{%s}")
              ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
              ("\\paragraph{%s}" . "\\paragraph*{%s}")
              ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
           org-latex-classes)))

(defun mh//convert-latex-src-block-to-export-block (node)
  "Convert a LaTeX src block to an export block.
NODE is the node in the parse tree corresponding to the LaTeX src block.

Expand the source block to include all parameters and noweb references."
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

;;(org-babel-expand-body:latex body params)
;; we need body and params. use (org-babel-get-src-block-info). params is (nth 2 info) and body is (org-babel--expand-body info)

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

(provide 'c-ox-latex)
;;; c-ox-latex.el ends here
