;;; c-bison-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'bison-mode))

(require 'bison-mode)

(provide 'c-bison-mode)
;;; c-bison-mode.el ends here
