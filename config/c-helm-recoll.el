;;; c-helm-recoll.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'helm-recoll))

(require 'helm-recoll)
(helm-recoll-create-source "library" "~/.recoll/library")

(provide 'c-helm-recoll)
;;; c-helm-recoll.el ends here
