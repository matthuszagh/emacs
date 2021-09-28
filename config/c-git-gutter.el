;;; c-git-gutter.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'git-gutter))

(require 'git-gutter)

(global-git-gutter-mode t)
(add-hook 'LaTeX-mode 'git-gutter-mode)
(set-face-foreground 'git-gutter:modified "purple")

(provide 'c-git-gutter)
;;; c-git-gutter.el ends here
