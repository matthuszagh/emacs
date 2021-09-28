;;; c-info-colors.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'info-colors))

(require 'info-colors)
(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(provide 'c-info-colors)
;;; c-info-colors.el ends here
