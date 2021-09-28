;;; c-djvu.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'djvu))

(require 'djvu)

(provide 'c-djvu)
;;; c-djvu.el ends here
