;;; c-nix-mode.el --- nix-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'nix-mode))

(use-package nix-mode
  :mode "\\.nix\\'"
  :hook
  ((nix-repl-mode . (lambda ()
                      (setq-local fill-column nil))))
  :custom
  ;; set this to indent-relative if issues occur.
  (nix-indent-function #'nix-indent-line))

(provide 'c-nix-mode)

;;; c-nix-mode.el ends here
