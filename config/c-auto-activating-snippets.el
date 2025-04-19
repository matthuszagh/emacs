;;; c-auto-activating-snippets.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package
     '(auto-activating-snippets :type git :host github
                                :repo "ymarco/auto-activating-snippets")))

(require 'aas)

(add-hook 'LaTeX-mode-hook #'aas-activate-for-major-mode)

(defun mh/maybe-org-latex-math-p ()
  "Basically `mh/org-latex-math-p' but can handle cases in which we're not in `org-mode'."
  (if (eq major-mode 'org-mode)
      (mh/org-latex-math-p)
    (texmathp)))

;; Rules for snippets:
;; 1. Use ';' as a prefix for all symbols.
;; 2. Use mnemonics. Strive for 2-letter combinations, but 3 or
;;    more letters is fine when it's an easier mnemonic.

(setq mh--aas-math
      '((";(" . "\\left($1\\right)$0")
        (";{" . "\\left\\\\{$1\\right\\\\}$0")
        (";[" . "\\left[$1\\right]$0")
        (";bb" . "\\mathbb{$1}$0")
        (";beg" . "\\begin{${1:environment}}$0\\end{$1}")
        (";bf" . "\\mathbf{$1}$0")
        (";bigcap" . "\\bigcap$0")
        (";bigcup" . "\\bigcup$0")
        (";cal" . "\\mathcal{$1}$0")
        (";cap" . "\\cap$0")
        (";circ" . "\\circ$0")
        (";coloneq" . "\\coloneq$0")
        (";cong" . "\\cong$0")
        (";cup" . "\\cup$0")
        (";dd" . "\\ddots$0")
        (";delta" . "\\delta$0")
        (";eqcolon" . "\\eqcolon$0")
        (";eqn" . "\\begin{equation}$0\\end{equation}")
        (";equiv" . "\\equiv$0")
        (";exists" . "\\exists$0")
        (";forall" . "\\forall$0")
        (";fr" . "\\frac{$1}{$2}$0")
        (";geq" . "\\geq$0")
        (";hat" . "\\hat{$1}$0")
        (";implies" . "\\implies$0")
        (";in" . "\\in$0")
        (";iff" . "\\iff$0")
        (";land" . "\\land$0")
        (";leq" . "\\leq$0")
        (";ld" . "\\ldots$0")
        (";lor" . "\\lor$0")
        ;; ;; TODO interferes with ;m in org-mode outside math mode
        ;; (";mapsto" . "\\mapsto$0")
        ;; (";mid" . "\\mid$0")
        (";neg" . "\\neg$0")
        (";neq" . "\\neq$0")
        (";ni" . "\\notin$0")
        (";oplus" . "\\oplus$0")
        (";opname" . "\\operatorname{$1}$0")
        (";phi" . "\\phi$0")
        (";pi" . "\\pi$0")
        (";qquad" . "\\qquad$0")
        (";quad" . "\\quad$0")
        (";rm" . "\\mathrm{$1}$0")
        (";scr" . "\\mathscr{$1}$0")
        (";sf" . "\\mathsf{$1}$0")
        (";sim" . "\\sim$0")
        (";sqrt" . "\\sqrt{$1}$0")
        (";square" . "\\square$0")
        (";subset" . "\\subset$0")
        (";sum" . "\\sum$0")
        (";tag" . "\\tag{$1}\\\\$0")
        (";tilde" . "\\tilde{$1}$0")
        (";times" . "\\times$0")
        (";to" . "\\to$0")
        (";tx" . "\\text{$1}$0")
        (";vd" . "\\vdots$0")))

(setq mh--aas-org-latex-block
      '((";eqn" . "\\begin{equation}\\tag{0}\n  $0\n\\end{equation}")
        (";aln" . "\\begin{align}\n  $0\n\\end{align}")
        (";src" . "{[SOURCE:$1] $0}")))

(defun mh//aas-transform-alist-to-snippet-list (al)
  ""
  (let ((ret-lst '()))
    (dolist (elt al)
      (setq ret-lst (append ret-lst `(,(car elt))
                            `((lambda ()
                                (interactive)
                                (yas-expand-snippet ,(cdr elt)))))))
    ret-lst))

(if (featurep 'org)
    (progn
      (setq mh--aas-org
            '((";m" . "\\\\($1\\\\)$0")))

      (defun mh/clear-org-aas-snippets ()
        (interactive)
        ;; Clear snippets from org-mode.
        (remhash 'org-mode aas-keymaps))

      (apply #'aas-set-snippets
             'org-mode
             :cond #'mh/maybe-org-latex-math-p
             (mh//aas-transform-alist-to-snippet-list mh--aas-math))

      (apply #'aas-set-snippets
             'org-mode
             :cond #'mh/org-in-latex-blockp
             (mh//aas-transform-alist-to-snippet-list mh--aas-org-latex-block))

      (apply #'aas-set-snippets
             'org-mode
             :cond #'(lambda () (not (mh/org-latex-math-p)))
             (mh//aas-transform-alist-to-snippet-list mh--aas-org))

      (add-hook 'org-mode-hook #'aas-activate-for-major-mode)
      (add-hook 'org-src-mode-hook
                (lambda ()
                  (if (eq major-mode 'latex-mode)
                      (aas-mode)))))
  (mh:log-init "WARNING" "attempted to perform auto-activating-snippets org configurations without loading 'org"))

(provide 'c-auto-activating-snippets)
;;; c-auto-activating-snippets.el ends here
