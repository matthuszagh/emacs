;;; c-switch-window.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'switch-window))

(require 'switch-window)

(custom-set-variables
 '(switch-window-multiple-frames t)
 '(switch-window-shortcut-style 'qwerty)
 '(switch-window-background t))

(provide 'c-switch-window)
;;; c-switch-window.el ends here
