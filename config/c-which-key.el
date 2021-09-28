;;; c-which-key.el --- which-key configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'which-key))

(use-package which-key
  :functions which-key-mode
  :config
  (which-key-mode))

(provide 'c-which-key)

;;; c-which-key.el ends here
