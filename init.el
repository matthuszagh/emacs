;;; init.el --- Emacs Initialization File -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; all configuration files are placed in config
(setq config-dir (concat user-emacs-directory "config"))
(setq load-path (append load-path `(,config-dir)))

(defun mh:log-init (level message)
  "Log LEVEL and MESSAGE to *init*.
LEVEL is the severity of the message, such as WARNING or ERROR."
  (unless (or (string-equal level "ERROR")
              (string-equal level "WARNING"))
    (error "Invalid LEVEL argument specified in 'mh:log-init"))
  (if (string-equal level "ERROR")
      (error message)
    (with-current-buffer (get-buffer-create "*init*")
      (insert (concat level ": " message "\n")))))


(require 'c-straight)

;; TODO emacs overlay adds org to the load path for some reason. Remove it manually.
(straight-use-package 'dash)
(require 'dash)
(setq load-path
      (-remove (lambda (path)
                 (string-equal (substring path -3 nil) "org"))
               load-path))

(require 'c-use-package) ; TODO remove
(require 'c-auto-compile)
(require 'c-base)
(require 'c-no-littering)

(require 'c-autoinsert)
(require 'c-aggressive-indent)
(require 'c-all-the-icons)
(require 'c-asy-mode)
(require 'c-auctex)
(require 'c-auctex-latexmk)
(require 'c-banner-comment)
(require 'c-bash-completion)
(require 'c-battery)
(require 'c-bison-mode)
(require 'c-blacken)
(require 'c-bnf-mode)
(require 'c-calc)
(require 'c-calendar)
(require 'c-cc-mode)
(require 'c-clang-format)
(require 'c-cmake-font-lock)
(require 'c-cmake-mode)
(require 'c-comint)
(require 'c-compile)
(require 'c-cython-mode)
(require 'c-dap-mode)
(require 'c-debbugs)
(require 'c-define-word)
(require 'c-diff-mode)
(require 'c-direnv)
(require 'c-djvu)
(require 'c-dumb-jump)
(require 'c-edbi)
(require 'c-edebug)
(require 'c-ein)
(require 'c-elec-pair)
(require 'c-elfeed)
(require 'c-elisp-mode)
;; TODO broken
;; (require 'c-elsa)
(require 'c-emr)
(require 'c-erc)
(require 'c-eshell)
(require 'c-eww)
(require 'c-fish-completion)
(require 'c-framemove)
(require 'c-gdb-mi)
(require 'c-git-gutter)
(require 'c-git-timemachine)
(require 'c-gnus)
(require 'c-haskell-mode)
(require 'c-helpful)
(require 'c-hexl)
(require 'c-hydra)
(require 'c-image-mode)
(require 'c-info-colors)
(require 'c-info)
(require 'c-js)
(require 'c-json-mode)
(require 'c-langtool)

;; lsp
(require 'c-lsp-mode)
(require 'c-lsp-ui)
(require 'c-lsp-pyright)

;; magit
(require 'c-transient)
(require 'c-magit)
(require 'c-forge)

(require 'c-make-mode)
(require 'c-man)
(require 'c-markdown-mode)
(require 'c-mml)
(require 'c-multiple-cursors)
(require 'c-nix-mode)
(require 'c-nixpkgs-fmt)
(require 'c-nix-update)
(require 'c-notmuch)
(require 'c-nov)
(require 'c-octave)
(require 'c-pdf-tools)

;; org
(require 'c-org)
(require 'c-ol)
(require 'c-ox)
(require 'c-ox-latex)
(require 'c-org-ml)
(require 'c-org-edna)
(require 'c-org-fragtog)
(require 'c-org-noter)
(require 'c-org-ref)
(require 'c-org-roam)
(require 'c-org-roam-bibtex)
(require 'c-org-api)
(require 'c-org-texnum)
(require 'c-ob)
(require 'c-ob-sagemath)
(require 'c-ob-spice)
(require 'c-org-eldoc)
(require 'c-ob-async)

;; helm
(require 'c-helm)
(require 'c-helm-bibtex)
(require 'c-helm-descbinds)
(require 'c-helm-eww)
(require 'c-helm-grep)
(require 'c-helm-librarian)
(require 'c-helm-ls-git)
(require 'c-helm-notmuch)
(require 'c-helm-org)
;; TODO broken
;; (require 'c-helm-projectile)
(require 'c-helm-recoll)
(require 'c-helm-regexp)
(require 'c-helm-systemd)
(require 'c-helm-xref)

(require 'c-ledger-mode)
(require 'c-paren)
;; (require 'c-perspective)
(require 'c-pinentry)
(require 'c-proced)
(require 'c-prog-mode)
(require 'c-projectile)
(require 'c-pulseaudio-control)
(require 'c-python-docstring)
(require 'c-python)
(require 'c-rainbow-delimiters)
(require 'c-realgud)
(require 'c-rmsbolt)
(require 'c-rustic)
(require 'c-sage-shell-mode)
(require 'c-scad-mode)
(require 'c-shell)
(require 'c-shr)
(require 'c-simple)
(require 'c-skewer-mode)
(require 'c-slime)
(require 'c-spice-mode)
(require 'c-sql)
(require 'c-sx)
(require 'c-term)
(require 'c-time)
(require 'c-undo-tree)
(require 'c-verilog-mode)
(require 'c-vterm)
(require 'c-vterm-toggle)
(require 'c-wgrep)
(require 'c-which-key)
(require 'c-window)
(require 'c-writegood-mode)
(require 'c-x86-lookup)
(require 'c-yaml-mode)
(require 'c-async)

;; completions
(require 'c-company)
(require 'c-slime-company)

;; syntax checking
(require 'c-flycheck)
(require 'c-flycheck-cython)
(require 'c-flycheck-elsa)
(require 'c-flycheck-ledger)

;; snippets
(require 'c-yasnippet)
(require 'c-auto-activating-snippets)
(require 'c-latex-auto-activating-snippets)

(require 'c-elpy)

;; themes
(require 'c-naysayer-theme)
(require 'c-spaceline)
;; keybindings
(require 'c-evil)
(require 'c-evil-collection)
(require 'c-evil-ledger)
(require 'c-evil-numbers)
(require 'c-evil-surround)
(require 'c-lispyville)
(require 'c-general)
;; exwm
(require 'c-exwm)

;; TODO find another location for these
(defun mh/nix-rebuild ()
  ""
  (interactive)
  (command-execute
   (async-shell-command "cd ~/src/nixos/ && make" "*nixos-rebuild*")))

(defun mh/nix-rebuild-show-trace ()
  ""
  (interactive)
  (command-execute
   (async-shell-command "cd ~/src/nixos/ && make trace" "*nixos-rebuild*")))

(defun mh/start-vpn ()
  (interactive)
  (start-process-shell-command
   "pia" nil "sudo systemctl start openvpn-us-east"))

(defun mh/low-power-mode ()
  (interactive)
  (start-process-shell-command
   "low-power" nil "cd ~/src/tools && ./low-power.sh"))

(defun mh/high-power-mode ()
  (interactive)
  (start-process-shell-command
   "high-power" nil "cd ~/src/tools && ./high-power.sh"))

;; Increase undo limits
(setq undo-limit 16000000)
(setq undo-strong-limit 24000000)

(defun mh/switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))
;; end TODO

;; log a message in *init* for all configuration files not loaded
(let ((config-files (directory-files config-dir)))
  (dolist (file config-files)
    (let ((feature-string (file-name-base file)))
      (unless (featurep (intern feature-string))
        (mh:log-init "WARNING" (concat feature-string " not loaded"))))))

;;; init.el ends here
