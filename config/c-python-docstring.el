;;; c-python-docstring.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'python-docstring))

(require 'python-docstring)

(add-hook 'python-mode-hook #'python-docstring-mode)

;; don't end sentences with double spaces
(custom-set-variables '(python-docstring-sentence-end-double-space nil))

(provide 'c-python-docstring)
;;; c-python-docstring.el ends here
