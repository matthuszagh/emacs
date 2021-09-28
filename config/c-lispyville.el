;;; c-lispyville.el --- lispyville configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'evil)
  (mh:log-init "ERROR" "attempted to load 'lispyville before 'evil"))

(if (featurep 'straight)
    (straight-use-package 'lispyville))

(use-package lispyville
  :config
  (add-hook 'lispy-mode-hook #'lispyville-mode)
  (lispyville-set-key-theme '(operators c-w additional)))

(add-hook 'emacs-lisp-mode-hook (lambda ()
		                  (lispy-mode 1)))

(provide 'c-lispyville)

;;; c-lispyville.el ends here
