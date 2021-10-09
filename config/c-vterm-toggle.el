;;; c-vterm-toggle.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'vterm-toggle))

(require 'vterm-toggle)

;; The default setting of `delete-window' causes errors.
(setq vterm-toggle-hide-method 'quit-window)

(provide 'c-vterm-toggle)
;;; c-vterm-toggle.el ends here
