;;; c-ob-latex.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'ob-latex)

(defun latex-preamble-by-backend (params)
  "Set the latex source block preamble."
  (concat "\\documentclass"
          (let ((width (cdr (assoc :_width params))))
            (if width
                (concat "[width="
                        width
                        "]")))
          "{"
          "_standalone"
          ;;(cdr (assoc :_class params))
          "}"
          ;; All of the following are color settings and only need to
          ;; be performed for for images.
          (if (assoc :_image params)
              (concat
               ;; The background color is necessary in graphics in
               ;; order to be able to overlay elements on top of
               ;; other elements. For example, the legend in a tikz
               ;; plot should have its background block out any part
               ;; of the graphic underneath the legend. Setting the
               ;; foreground color is not necessary because we can
               ;; replace this with SVG's currentColor to get
               ;; context-aware color setting.
               "\\definecolor{bg}{HTML}{"
               (mh//by-backend '((html . "ffffff")
                                 ;; TODO xcolor produces a slightly different
                                 ;; color than emacs.
                                 ;; Netlify complains about the '#', so we remove it.
                                 (t . (substring (face-background 'default) 1 nil))))
               "}\n"
               ;; pc stands for percentage and allows us to set
               ;; colors in a way that works in the context of light
               ;; and dark backgrounds, without changing the
               ;; contents of the LaTeX source block. For example,
               ;; we can use `blue!\pc`, which would give us normal
               ;; blue in html export but light blue in an org-mode
               ;; context.
               "\\def\\pc{"
               (mh//by-backend `((html . "100")
                                 (t . ,(if (mh//light-backgroundp)
                                           "100"
                                         "20"))))
               "}\n"
               ;; Circuitikz requires the background color to fill
               ;; nodes since it uses this to block out
               ;; imperfections of the way that certain things are
               ;; drawn. See
               ;; https://github.com/circuitikz/circuitikz/issues/331.
               "\\ctikzset{-o/.style = {bipole nodes={none}{ocirc, fill=bg}}}\n"
               "\\ctikzset{o-/.style = {bipole nodes={ocirc, fill=bg}{none}}}\n"
               "\\ctikzset{o-o/.style = {bipole nodes={ocirc, fill=bg}{ocirc, fill=bg}}}\n"
               "\\ctikzset{*-o/.style = {bipole nodes={circ}{ocirc, fill=bg}}}\n"
               "\\ctikzset{o-*/.style = {bipole nodes={ocirc, fill=bg}{circ}}}\n"))))

(custom-set-variables
 '(org-babel-latex-preamble
   (lambda (params)
     (latex-preamble-by-backend params)))
 '(org-babel-latex-begin-env
   (lambda (_)
     "\\begin{document}"))
 '(org-babel-latex-end-env
   (lambda (_)
     "\\end{document}"))
 ;; This is used when converting a PDF file to an SVG file during
 ;; latex source block evaluation. It is not used for latex
 ;; fragments/snippets.
 `(org-babel-latex-pdf-svg-process
   ;; I deliberately do not replace the background color with
   ;; 'none'. This produces undesirable results in cases where the
   ;; background color must be overlayed onto graphical elements in a
   ;; background layer (e.g., the legend of a tikz plot).
   ,(concat "inkscape --pdf-poppler %f "
            "--export-text-to-path "
            "--export-plain-svg "
            "--export-filename=%O"
            " && sed -i 's/#000000/currentColor/g; s/rgb(0.,0.,0.)/currentColor/g' %O")))

(defun mh//org-src-block-latex-post ()
  ""
  (let* ((elem (org-element-at-point))
         (class-mathp (not (mh//header-match elem ":_image")))
         (wrap-str "attr_wrap(data=*this*)")
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
         (class-mathp (not (mh//header-match elem ":_image"))))
    (if org-export-current-backend
        (let ((backend org-export-current-backend))
          (if (or (string= backend "latex")
                  (and (string= backend "html") class-mathp))
              "value latex"
            "file link replace"))
      "file link replace")))

(defun mh//org-src-block-latex-result-filename ()
  "Name of the file produced by the LaTeX source block at point."
  (let* ((elem (org-element-at-point))
         (class-mathp (not (mh//header-match elem ":_image")))
         (filename (concat "tmp/"
                           (sha1 (mh//org-src-block-contents))
                           ;; If this is not a math block (:_class math) and it's
                           ;; being evaluated for display within org-mode, we
                           ;; append the current background color to the file
                           ;; name. This forces org-mode to reevaluate the block
                           ;; whenever the background color changes. This is
                           ;; necessary, because although we can inherit the
                           ;; foreground color from the context (SVG's
                           ;; currentColor), we must hardcode the background color.
                           (unless class-mathp
                             (concat "-"
                                     (substring (face-background 'default) 1 nil)))
                           ".svg")))
    (cond
     ((equal org-export-current-backend nil)
      filename)
     ((equal org-export-current-backend 'latex)
      nil)
     ((equal org-export-current-backend 'html)
      (if class-mathp
          nil
        filename)))))

(defun mh//org-src-block-latex-file-description ()
  ""
  (let* ((elem (org-element-at-point))
         (clickablep (mh//header-match elem ":_clickable")))
    (if (and (equal org-export-current-backend 'html))
        (concat "file:" (mh//org-src-block-latex-result-filename))
      [])))

(defun mh//org-src-block-latex-wrap ()
  (let* ((elem (org-element-at-point))
         (class-mathp (not (mh//header-match elem ":_image")))
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
                   (mh//org-src-block-latex-result-filename)))
        (:file-desc . (lambda ()
                        (mh//org-src-block-latex-file-description)))
        (:post . (lambda ()
                   (mh//org-src-block-latex-post)))))

(provide 'c-ob-latex)
;;; c-ob-latex.el ends here
