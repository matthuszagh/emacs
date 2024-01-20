;;; c-diminish.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'diminish))

(require 'diminish)
;; TODO run (diminish minor-mode) for all minor modes
(diminish 'filladapt-mode)

(provide 'c-diminish)
;;; c-diminish.el ends here
