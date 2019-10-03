;;; help-layer.el -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Code:

(layer-def help
  :presetup
  (:layer straight
   (straight-use-package 'helpful))

  :setup
  (use-package helpful
    :bind (("C-h f" . helpful-function)
           ("C-h v" . helpful-variable)
           ("C-h k" . helpful-key))
    :config
    (global-set-key (kbd "C-c C-d") #'helpful-at-point))

  :postsetup
  (:layer keybinding-management
   (general-def mh/prefix-help-map
     "h" 'helpful-at-point
     "f" 'helpful-function
     "v" 'helpful-variable
     "k" 'helpful-key
     "M" 'helpful-macro
     "i" 'helm-info
     ;; TODO this should also depend on helm layer
     "m" 'helm-man-woman)))

;;; help-layer.el ends here