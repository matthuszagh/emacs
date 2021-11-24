;;; c-aggressive-indent.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'aggressive-indent))

(require 'aggressive-indent)

(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-to-list 'aggressive-indent-excluded-modes 'c-mode)
(add-to-list 'aggressive-indent-excluded-modes 'c++-mode)
(add-to-list 'aggressive-indent-excluded-modes 'octave-mode)
(add-to-list 'aggressive-indent-excluded-modes 'verilog-mode)

;; nix-mode
(add-hook 'after-init-hook
          (lambda ()
            (unless (featurep 'nix-mode)
              (mh:log-init "WARNING" "'aggressive-indent included 'nix-mode configurations, but 'nix-mode was never loaded"))))
(add-to-list 'aggressive-indent-excluded-modes 'nix-mode)

(provide 'c-aggressive-indent)
;;; c-aggressive-indent.el ends here
