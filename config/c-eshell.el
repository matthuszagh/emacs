;;; c-eshell.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'eshell)

(add-hook 'eshell-mode-hook (lambda ()
                              (setq-local scroll-margin 0)
                              (setq-local scroll-conservatively 101)))

(setq eshell-buffer-maximum-lines 0)

(provide 'c-eshell)
;;; c-eshell.el ends here
