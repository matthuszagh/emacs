;;; c-flycheck-cython.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'flycheck-cython))

(require 'flycheck-cython)

(provide 'c-flycheck-cython)
;;; c-flycheck-cython.el ends here
