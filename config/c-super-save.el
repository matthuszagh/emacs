;;; c-super-save.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; super-save is a package for saving buffers when they lose focus.
;;
;;; Code:

(if (featurep 'straight)
    (straight-use-package 'super-save))

(require 'super-save)

(super-save-mode 1)
(setq super-save-auto-save-when-idle t)

(provide 'c-super-save)
;;; c-super-save.el ends here
