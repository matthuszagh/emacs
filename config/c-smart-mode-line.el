;;; c-smart-mode-line.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'smart-mode-line))

(unless (featurep 'naysayer-theme)
  (mh:log-init "ERROR" "smart-mode-line must be loaded after naysayer-theme"))

(require 'c-smart-mode-line)

(setq size-indication-mode t)
(setq column-number-mode t)
(setq line-number-mode t)
(setq sml/name-width 40)
(sml/setup)

(provide 'c-smart-mode-line)
;;; c-smart-mode-line.el ends here
