;;; c-slime.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'slime))

(add-to-list 'same-window-buffer-names "*slime-repl.*")
(require 'slime)

(provide 'c-slime)
;;; c-slime.el ends here
