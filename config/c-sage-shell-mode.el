;;; c-sage-shell-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'sage-shell-mode))

(require 'sage-shell-mode)

;; TODO this should probably just toggle auto fill
(add-hook 'sage-shell-mode-hook (lambda ()
                                  (set-fill-column 1000)))

(provide 'c-sage-shell-mode)
;;; c-sage-shell-mode.el ends here
