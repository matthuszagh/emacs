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
;; 1. Use ';' as a prefix for all symbols in math mode.
;; 2. Use ';;' as a prefix for snippets in org mode outside math mode.

(setq mh--aas-math
      '(;; rem: bchijknpqtuvwxyz

        ;; TODO:
        ;; - otimes

        ;; accents/decorators (;a) (rem: acdefgijklmnpqrswxyz)
        (";a1" . "\\dot{$1}$0")
        (";a2" . "\\ddot{$1}$0")
        (";a3" . "\\dddot{$1}$0")
        (";a4" . "\\ddddot{$1}$0")
        (";ab" . "\\overline{$1}$0")
        (";ah" . "\\hat{$1}$0")
        (";ao" . "\\overbrace{$1}_{$2}$0")
        (";ap" . "^{$1}$0")
        (";as" . "_{$1}$0")
        (";at" . "\\tilde{$1}$0")
        (";au" . "\\underbrace{$1}_{$2}$0")
        (";av" . "\\overset{$1}{$2}$0")

        ;; delimiters (;d) (rem: cdefghijklmoqtuwxyz)
        ;;
        ;; note: I had another thought here to make \left\right it's
        ;; own key sequence (";ds") and have that be composable with
        ;; various delimiters. This has the benefit of requiring fewer
        ;; definitions, but isn't easier to remember than the current
        ;; scheme and requires more key presses.
        (";da" . "\\langle$1\\rangle$0")
        (";dsa" . "\\left\\langle$1\\right\\rangle$0")
        (";db" . "[$1]$0")
        (";dsb" . "\\left[$1\\right]$0")
        ;; 'n' for norm
        (";dn" . "\\lVert$1\\rVert$0")
        (";dsn" . "\\left\\lVert$1\\right\\rVert$0")
        (";dp" . "($1)$0")
        (";dsp" . "\\left($1\\right)$0")
        (";dr" . "\\{$1\\}$0")
        ;; TODO the following works, but I still need a way to typeset
        ;; {}. (";dr" . "\\\\{$1\\\\}$0")
        (";dsr" . "\\left\\\\{$1\\right\\\\}$0")
        ;; TODO need a way to typeset \{\} in addition to {}. Also,
        ;; get this working with M-x:
        ;; (yas-expand-snippet "\\\\{$1\\\\}$0")
        ;; (yas-expand-snippet "\\left\\\\{$1\\right\\\\}$0") etc.
        ;; 'v' for vert
        (";dv" . "\\lvert$1\\rvert$0")
        (";dsv" . "\\left\\lvert$1\\right\\rvert$0")

        ;; environment (;e) (rem: cdfghijklmnopqrsuvwxyz)
        (";eb" . "\\begin{${1:environment}}$0\\end{$1}")
        (";ee" . "\\begin{equation}$0\\end{equation}")
        (";ea" . "\\begin{align}$0\\end{align}")
        (";et" . "\\tag{$1}$0")

        ;; fonts (;f) (rem: deghijklmnopquvwxyz)
        (";fa" . "\\mathbb{$1}$0")
        (";fb" . "\\mathbf{$1}$0")
        (";fc" . "\\mathcal{$1}$0")
        (";ff" . "\\mathsf{$1}$0")
        (";fr" . "\\mathrm{$1}$0")
        (";fs" . "\\mathscr{$1}$0")
        (";ft" . "\\text{$1}$0")

        ;; Greek alphabet (;g) (rem: j/J)
        (";ga" . "\\alpha$0")
        (";gA" . "\\Alpha$0")
        (";gb" . "\\beta$0")
        (";gB" . "\\Beta$0")
        (";gc" . "\\chi$0")
        (";gC" . "\\Chi$0")
        (";gd" . "\\delta$0")
        (";gD" . "\\Delta$0")
        (";ge" . "\\epsilon$0")
        (";gE" . "\\Epsilon$0")
        (";gf" . "\\phi$0")
        (";gF" . "\\Phi$0")
        (";gg" . "\\gamma$0")
        (";gG" . "\\Gamma$0")
        (";gh" . "\\eta$0")
        (";gH" . "\\Eta$0")
        (";gi" . "\\iota$0")
        (";gI" . "\\Iota$0")
        (";gk" . "\\kappa$0")
        (";gK" . "\\Kappa$0")
        (";gl" . "\\lambda$0")
        (";gL" . "\\Lambda$0")
        (";gm" . "\\mu$0")
        (";gM" . "\\Mu$0")
        (";gn" . "\\nu$0")
        (";gN" . "\\Nu$0")
        (";go" . "\\omicron$0")
        (";gO" . "\\Omicron$0")
        (";gp" . "\\pi$0")
        (";gP" . "\\Pi$0")
        (";gq" . "\\theta$0")
        (";gQ" . "\\Theta$0")
        (";gr" . "\\rho$0")
        (";gR" . "\\Rho$0")
        (";gs" . "\\sigma$0")
        (";gS" . "\\Sigma$0")
        (";gt" . "\\tau$0")
        (";gT" . "\\Tau$0")
        (";gu" . "\\upsilon$0")
        (";gU" . "\\Upsilon$0")
        (";gv" . "\\varepsilon$0")
        (";gw" . "\\omega$0")
        (";gW" . "\\Omega$0")
        (";gx" . "\\xi$0")
        (";gX" . "\\Xi$0")
        (";gy" . "\\psi$0")
        (";gY" . "\\Psi$0")
        (";gz" . "\\zeta$0")
        (";gZ" . "\\Zeta$0")

        ;; special symbols/constants (;k) (rem: cefgjostuvwxyz)
	(";ka" . "\\aleph$0")       ; aleph null
	(";kb" . "\\bra{$1}$0")     ; bra
	(";kd" . "\\dagger$0")      ; dagger
	(";kh" . "\\hbar$0")        ; reduced Planck's constant
        (";ki" . "\\infty$0")       ; infinity
	(";kk" . "\\ket{$1}$0")     ; ket
        (";kl" . "\\ell$0")         ; script l (length)
        (";km" . "\\Im$0")          ; imaginary part
        (";kn" . "\\nabla$0")       ; nabla/del operator
        (";kp" . "\\partial$0")     ; partial derivative
	(";kq" . "\\braket{$1}{$2}$0")     ; braket
	(";kr" . "\\Re$0")          ; real part
        (";kv" . "\\vec{$1}$0")

        ;; logic (;l) (rem: bghjklmopqrstuvwxyz)
        (";la" . "\\forall$0")
        (";le" . "\\exists$0")
        (";lf" . "\\iff$0")
        (";li" . "\\implies$0")
        (";ln" . "\\neg$0")
        (";lc" . "\\land$0")  ; conjunction
        (";ld" . "\\lor$0")   ; disjunction

        ;; misc/arrows (;m) (rem: bcdfghijklnoruvwxyz)
        (";m1" . "\\quad$0")
        (";m2" . "\\qquad$0")
        (";ma" . "\\to$0")
        (";me" . "\\perp$0")
        (";mm" . "\\mp$0")
        (";mp" . "\\pm$0")
        (";mq" . "\\square$0")
        (";ms" . "\\\\$0")
        (";mt" . "\\mapsto$0")

        ;; operations (;o) (rem: abghjmvwyz)
        (";oc" . "\\cos$0")
        (";od" . "\\det$0")
        (";oe" . "\\exp$0")
        (";of" . "\\frac{$1}{$2}$0")
        (";oi" . "\\int$0")
        (";ol" . "\\log$0")
        (";on" . "\\operatorname{$1}$0")
        (";oo" . "\\circ$0")
        (";op" . "\\oplus$0")
        (";oq" . "\\sqrt{$1}$0")
        (";or" . "\\prod$0")
        (";os" . "\\sin$0")
        (";ot" . "\\tan$0")
        (";ou" . "\\sum$0")
        (";ox" . "\\times$0")

        ;; package (;p) (rem: abcdefghijklmnopqrtuvwxyz)
        (";ps" . "\\SI{$1}{$2}$0")

        ;; relations (;r) (rem: bdhijkmrtuvwxyz)
        (";ra" . "\\approx$0")
        (";rc" . "\\coloneq$0")
        (";rC" . "\\eqcolon$0")
        (";re" . "=$0")
        (";rf" . "&=$0")
        (";rg" . "\\geq$0")
        (";rG" . "\\gg$0")
        (";rl" . "\\leq$0")
        (";rL" . "\\ll$0")
        (";rn" . "\\neq$0")
        (";ro" . "\\cong$0")
        (";rp" . "\\propto$0")
        (";rq" . "\\equiv$0")
        (";rs" . "\\sim$0")

        ;; set operations (;s) (rem: abdfghjklqrtvwxyz)
        (";sC" . "\\bigcap$0")
        (";sU" . "\\bigcup$0")
        (";sc" . "\\cap$0")
        (";su" . "\\cup$0")
        (";se" . "\\emptyset$0")
        (";ss" . "\\subset$0")
        (";sp" . "\\supset$0")
        (";sS" . "\\subseteq$0")
        (";sP" . "\\supseteq$0")
        (";sm" . "\\mid$0")
        (";si" . "\\in$0")
        (";sn" . "\\notin$0")
        (";so" . "\\setminus$0")

        ;; dots (;.) (rem: abefghijkmnopqrstuwxyz)
	(";.c" . "\\cdot$0") ; covers cdots too - just add an 's'
        (";.l" . "\\ldots$0")
        (";.v" . "\\vdots$0")
        (";.d" . "\\ddots$0")
        ))

;; (setq mh--aas-math
;;       '((";(" . "\\left($1\\right)$0")
;;         (";{" . "\\left\\\\{$1\\right\\\\}$0")
;;         (";[" . "\\left[$1\\right]$0")
;;         (";alpha" . "\\alpha$0")
;;         (";bar" . "\\overline{$1}$0")
;;         (";bb" . "\\mathbb{$1}$0")
;;         (";beg" . "\\begin{${1:environment}}$0\\end{$1}")
;;         (";beta" . "\\beta$0")
;;         (";bf" . "\\mathbf{$1}$0")
;;         (";bigcap" . "\\bigcap$0")
;;         (";bigcup" . "\\bigcup$0")
;;         (";cal" . "\\mathcal{$1}$0")
;;         (";cap" . "\\cap$0")
;;         (";cd" . "\\cdots$0")
;;         (";circ" . "\\circ$0")
;;         (";coloneq" . "\\coloneq$0")
;;         (";cong" . "\\cong$0")
;;         (";cos" . "\\cos$0")
;;         (";cup" . "\\cup$0")
;;         (";ddot" . "\\ddot$0")
;;         (";dddot" . "\\dddot$0")
;;         (";ddddot" . "\\ddddot$0")
;;         (";Delta" . "\\Delta$0")
;;         (";delta" . "\\delta$0")
;;         (";det" . "\\det$0")
;;         (";dot" . "\\dot$0")
;;         (";emptyset" . "\\emptyset$0")
;;         (";eps" . "\\epsilon$0")
;;         (";eqcolon" . "\\eqcolon$0")
;;         (";eqn" . "\\begin{equation}$0\\end{equation}")
;;         (";equiv" . "\\equiv$0")
;;         (";exists" . "\\exists$0")
;;         (";forall" . "\\forall$0")
;;         (";fr" . "\\frac{$1}{$2}$0")
;;         (";Gamma" . "\\Gamma$0")
;;         (";gamma" . "\\gamma$0")
;;         (";geq" . "\\geq$0")
;;         (";hat" . "\\hat{$1}$0")
;;         (";implies" . "\\implies$0")
;;         (";in" . "\\in$0")
;;         (";iff" . "\\iff$0")
;;         (";Lambda" . "\\Lambda$0")
;;         (";lambda" . "\\lambda$0")
;;         (";land" . "\\land$0")
;;         (";langle" . "\\langle$0")
;;         (";leq" . "\\leq$0")
;;         (";ld" . "\\ldots$0")
;;         (";lor" . "\\lor$0")
;;         (";mapsto" . "\\mapsto$0")
;;         (";mid" . "\\mid$0")
;;         (";Mu" . "\\Mu$0")
;;         (";mu" . "\\mu$0")
;;         (";mp" . "\\mp$0")
;;         (";neg" . "\\neg$0")
;;         (";neq" . "\\neq$0")
;;         (";ni" . "\\notin$0")
;;         (";Nu" . "\\Nu$0")
;;         (";nu" . "\\nu$0")
;;         (";Omega" . "\\Omega$0")
;;         (";omega" . "\\omega$0")
;;         (";oplus" . "\\oplus$0")
;;         (";opn" . "\\operatorname{$1}$0")
;;         (";oset" . "\\overset{$1}$0")
;;         (";overbrace" . "\\overbrace{$1}_{$0}")
;;         (";perp" . "\\perp$0")
;;         (";Phi" . "\\Phi$0")
;;         (";phi" . "\\phi$0")
;;         (";pi" . "\\pi$0")
;;         (";pm" . "\\pm$0")
;;         (";prod" . "\\prod$0")
;;         (";Psi" . "\\Psi$0")
;;         (";psi" . "\\psi$0")
;;         (";qquad" . "\\qquad$0")
;;         (";quad" . "\\quad$0")
;;         (";rangle" . "\\rangle$0")
;;         (";rho" . "\\rho$0")
;;         (";rm" . "\\mathrm{$1}$0")
;;         (";scr" . "\\mathscr{$1}$0")
;;         (";sf" . "\\mathsf{$1}$0")
;;         (";si" . "\\SI{$1}{$2}$0")
;;         ;; TODO sigma
;;         (";sm" . "\\sim$0")
;;         (";sn" . "\\sin$0")
;;         (";sqrt" . "\\sqrt{$1}$0")
;;         (";square" . "\\square$0")
;;         (";subset" . "\\subset$0")
;;         (";supset" . "\\supset$0")
;;         (";sum" . "\\sum$0")
;;         (";tag" . "\\tag{$1}\\\\$0")
;;         (";tan" . "\\tan$0")
;;         (";theta" . "\\theta$0")
;;         (";tilde" . "\\tilde{$1}$0")
;;         (";times" . "\\times$0")
;;         (";to" . "\\to$0")
;;         (";tr" . "\\tr$0")
;;         (";tx" . "\\text{$1}$0")
;;         (";underbrace" . "\\underbrace{$1}_{$0}")
;;         (";vd" . "\\vdots$0")
;;         (";veps" . "\\varepsilon$0")))

(setq mh--aas-org-latex-block
      '((";eqn" . "\\begin{equation}\\tag{0}\n  $0\n\\end{equation}")
        (";aln" . "\\begin{align}\n  $0\n\\end{align}")))

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
            '((";;m" . "\\\\($1\\\\)$0")
              (";;s" . "{[SOURCE:$1] $0}")
              (";;t" . "{[TODO $1] $0}")
              (";;b" . "{$0}")))

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
