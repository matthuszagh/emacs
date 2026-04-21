;;; c-ripgrep.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'ripgrep))

(require 'ripgrep)

(provide 'c-ripgrep)
;;; c-ripgrep.el ends here
