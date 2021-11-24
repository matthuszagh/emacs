;;; c-ob.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This file provides customizations for org source code blocks.  In
;; particular, it sets the environment those source blocks see and
;; handles how they are executed.
;;
;;; Code:

(unless (and (featurep 'org-api)
             (featurep 'org-texnum))
  (mh:log-init "ERROR" "attempted to load 'c-ob before 'org-api and 'org-texnum"))

(org-babel-lob-ingest (concat user-emacs-directory "config/lob.org"))

(require 's)

;; This is used when converting a PDF file to an SVG file during latex
;; source block evaluation. It is not used for latex
;; fragments/snippets.
(setq org-babel-latex-pdf-svg-process
      ;; I deliberately do not replace the background color with
      ;; 'none'. This produces undesirable results in cases where the
      ;; background color must be overlayed onto graphical elements in
      ;; a background layer (e.g., the legend of a tikz plot).
      (concat "inkscape --pdf-poppler %f -T -l -o %O"
              " && sed -i 's/#000000/currentColor/g; s/rgb(0.,0.,0.)/currentColor/g' %O"))

(defun mh//light-backgroundp ()
  "Return t if the current background color is light, nil otherwise."
  ;; TODO The current implementation is too crude; it only returns t
  ;; if the background color is white. We also want other light colors
  ;; to evaluate to t.
  (string-equal (face-background 'default) "#ffffff"))

(defun latex-preamble-by-backend (params)
  "Set the latex source block preamble."
  (concat "\\documentclass{"
          (cdr (assoc :_class params))
          "}"
          ;; All of the following are color settings and only need to
          ;; be performed for :_class tikz.
          (if (string= "tikz" (cdr (assoc :_class params)))
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
               (by-backend '((html . "ffffff")
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
               (by-backend `((html . "100")
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

(setq org-babel-latex-preamble
      (lambda (params)
        (latex-preamble-by-backend params)))

(setq org-babel-latex-begin-env
      (lambda (_)
        "\\begin{document}"))

(setq org-babel-latex-end-env
      (lambda (_)
        "\\end{document}"))

(require 'ox-latex)

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
  "Name of the file produced by the LaTeX source block at point."
  (let* ((elem (org-element-at-point))
         (class-mathp (mh//header-match elem ":_class math")))
    (if (and org-export-current-backend class-mathp)
        nil
      (concat "tmp/"
              (sha1 (mh//org-src-block-contents))
              ;; If this is not a math block (:_class math) and it's
              ;; being evaluated for display within org-mode, we
              ;; append the current background color to the file
              ;; name. This forces org-mode to reevaluate the block
              ;; whenever the background color changes. This is
              ;; necessary, because although we can inherit the
              ;; foreground color from the context (SVG's
              ;; currentColor), we must hardcode the background color.
              (unless (or org-export-current-backend
                          class-mathp)
                (concat "-"
                        (substring (face-background 'default) 1 nil)))
              ".svg"))))

(defun mh//org-src-block-latex-post ()
  ""
  (let* ((elem (org-element-at-point))
         (class-mathp (mh//header-match elem ":_class math"))
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

(setq org-babel-default-header-args:python
      `((:results . (lambda ()
                      (if (mh//header-match (org-element-at-point) ":_class pylatex")
                          "file link replace"
                        "output")))
        (:var . (lambda ()
                  (concat "fname=\"" (mh//org-src-block-result-filename) "\"")))
        (:var . (lambda ()
                  (concat "bg=\"" (substring (face-background 'default) 1 nil) "\"")))
        (:cache . "yes")
        (:file . (lambda ()
                   (if (mh//header-match (org-element-at-point) ":_class pylatex")
                       (mh//org-src-block-result-filename)
                     nil)))))

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
    (eval ret)))

;; TODO is this used? Don't I use org-texnum for all of this?
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

(provide 'c-ob)
;;; c-ob.el ends here
