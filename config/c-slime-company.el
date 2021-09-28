;;; c-slime-company.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'slime-company))

(unless (and (featurep 'slime)
             (featurep 'company))
  (error "Attempted to load 'slime-company' before 'slime' and 'company': reorganize init file"))

(require 'slime-company)

(slime-setup '(slime-fancy slime-company))

(provide 'c-slime-company)
;;; c-slime-company.el ends here
