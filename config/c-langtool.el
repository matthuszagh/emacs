;;; c-langtool.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'langtool))

(require 'langtool)
(setq langtool-bin "languagetool-commandline")

(provide 'c-langtool)
;;; c-langtool.el ends here
