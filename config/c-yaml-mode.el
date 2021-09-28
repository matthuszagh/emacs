;;; c-yaml-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'yaml-mode))

(require 'yaml-mode)

(provide 'c-yaml-mode)
;;; c-yaml-mode.el ends here
