;;; c-multiple-cursors.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'multiple-cursors))

(require 'multiple-cursors)

(setq mc/always-repeat-command t)

(provide 'c-multiple-cursors)
;;; c-multiple-cursors.el ends here
