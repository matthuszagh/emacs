;;; c-wgrep.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'wgrep))

(require 'wgrep)

(provide 'c-wgrep)
;;; c-wgrep.el ends here
