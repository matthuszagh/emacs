;;; c-evil.el --- evil-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'evil))

(setq evil-want-keybinding nil)
;; this prevents annoying abbrev expands in verilog mode.
(setq evil-want-abbrev-expand-on-insert-exit nil)
;; This is optional since it's already set to t by default.
(setq evil-want-integration t)
;; motion commands should respect the visual line setting
(setq evil-respect-visual-line-mode t)

(require 'evil)

(evil-mode 1)

(if (featurep 'vterm)
    (progn
      (defun evil-collection-vterm-escape-stay ()
        "Go back to normal state but don't move cursor backwards.
Moving cursor backwards is the default vim behavior but
it is not appropriate in some cases like terminals."
        (setq-local evil-move-cursor-back nil))
      (add-hook 'vterm-mode-hook #'evil-collection-vterm-escape-stay))
  (mh:log-init "WARNING" "attempted to set vterm configuration without loading 'vterm"))

(if (featurep 'git-timemachine)
    ;; Make git-timemachine work with evil.
    (evil-make-overriding-map git-timemachine-mode-map 'normal)
  (mh:log-init "WARNING" "attempted to set git-timemachine configuration without loading 'git-timemachine"))

(provide 'c-evil)

;;; c-evil.el ends here
