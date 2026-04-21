;;; c-persp-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'persp-mode))

(require 'persp-mode)
(persp-mode)

(provide 'c-persp-mode)
;;; c-persp-mode.el ends here
