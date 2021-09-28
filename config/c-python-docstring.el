;;; c-python-docstring.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'python-docstring))

(require 'python-docstring)

(add-hook 'python-mode-hook #'python-docstring-mode)

(provide 'c-python-docstring)
;;; c-python-docstring.el ends here
