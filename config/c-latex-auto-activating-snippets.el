;;; c-latex-auto-activating-snippets.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'aas)
  (mh:log-init "ERROR" "attempted to load 'latex-auto-activating-snippets without first loading 'auto-activating-snippets"))

(if (featurep 'straight)
    (straight-use-package '(latex-auto-activating-snippets :type git :host github :repo "tecosaur/latex-auto-activating-snippets")))

(require 'laas)

(if (featurep 'org)
    (progn
      ;; expand "//" into frac
      ;; TODO doesn't work in latex-mode since '/' already defined there.
      (let ((frac-snippet
             (list
              :cond #'(lambda ()
                        (and (texmathp)
                             (aas-object-on-left-condition)))
              :expansion-desc "Wrap object on the left with \\frac{}{}, leave `point' in the denuminator."
              "//" #'laas-smart-fraction)))
        (dolist (mode '(org-mode))
          (apply #'aas-set-snippets mode frac-snippet)))

      ;; custom math snippets
      (let ((math-snippets
             (list
              :cond #'texmathp
              "case" (lambda ()
              	       (interactive)
                       (yas-expand-snippet (concat "\\begin{cases}\n"
                                                   "    $1\n"
                                                   "  \\end{cases}$0")))
              "mt" (lambda ()
                     (interactive)
                     (yas-expand-snippet (concat "\\begin{bmatrix}\n"
                                                 "    $1\n"
                                                 "  \\end{bmatrix}$0")))
              "dt" (lambda ()
                     (interactive)
                     (yas-expand-snippet (concat "\\begin{vmatrix}\n"
                                                 "    $1\n"
                                                 "  \\end{vmatrix}$0")))
              "bf" (lambda ()
                     (interactive)
                     (yas-expand-snippet (concat "\\mathbf{$1}$0")))
              "bb" (lambda ()
                     (interactive)
                     (yas-expand-snippet (concat "\\mathbb{$1}$0")))
              "tx" (lambda ()
                     (interactive)
                     (yas-expand-snippet (concat "\\text{$1}$0")))
              "rm" (lambda ()
                     (interactive)
                     (yas-expand-snippet (concat "\\mathrm{$1}$0"))))))
        (dolist (mode '(latex-mode org-mode))
          (apply #'aas-set-snippets mode math-snippets)))

      (let ((latex-block-snippets
             (list
              :cond (lambda ()
                      (and (mh/org-in-latex-blockp)
                           (mh/point-at-line-begp)))
              "eqn" (lambda ()
                      (interactive)
                      (yas-expand-snippet (concat "\\begin{equation}\\tag{0}\n"
                                                  "  $0\n"
                                                  "\\end{equation}")))
              "aln" (lambda ()
                      (interactive)
                      (yas-expand-snippet (concat "\\begin{align}\n"
                                                  "  $0\n"
                                                  "\\end{align}")))
              "prf" (lambda ()
                      (interactive)
                      (yas-expand-snippet (concat "\\begin{proof}\n"
                                                  "  \\begin{align}\n"
                                                  "    $1\n"
                                                  "  \\end{align}\n"
                                                  "\\end{proof}$0")))
              "tkz" (lambda ()
                      (interactive)
                      (yas-expand-snippet (concat "\\begin{tikzpicture}\n"
                                                  "  $1\n"
                                                  "\\end{tikzpicture}$0"))))))
        (apply #'aas-set-snippets 'org-mode latex-block-snippets))

      ;; apply default latex snippets to org and TeX-derived modes
      (add-hook 'org-mode-hook #'laas-mode)
      (add-hook 'TeX-mode-hook #'laas-mode))
  (mh:log-init "WARNING" "attempted to perform latex-auto-activating-snippets org configurations without loading 'org"))

(provide 'c-latex-auto-activating-snippets)
;;; c-latex-auto-activating-snippets.el ends here
