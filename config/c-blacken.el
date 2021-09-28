;;; c-blacken.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'blacken))

(require 'blacken)

(add-hook 'python-mode-hook #'blacken-mode)
(setq blacken-line-length 79)
(setq blacken-only-if-project-is-blackened nil)

(provide 'c-blacken)
;;; c-blacken.el ends here
