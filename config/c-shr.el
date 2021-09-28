;;; c-shr.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'shr))

(require 'shr)

;; use monospaced rather than proportional fonts
(setq shr-use-fonts nil)
(setq shr-use-colors nil)
;; don't limit window and character width
(setq shr-width nil)
(setq shr-max-width nil)

(provide 'c-shr)
;;; c-shr.el ends here
