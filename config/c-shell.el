;;; c-shell.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'shell)

(add-hook 'shell-mode-hook (lambda ()
                             (setq-local scroll-margin 0)
                             (setq-local scroll-conservatively 101)))
(add-to-list 'same-window-buffer-names "*shell*")
(setq explicit-shell-file-name nil)

(provide 'c-shell)
;;; c-shell.el ends here
