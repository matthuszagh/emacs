;;; c-helm-bibtex.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'org)
  (mh:log-init "ERROR" "attempted to load 'helm-bibtex before 'org"))

(if (featurep 'straight)
    (straight-use-package 'helm-bibtex))

(require 'helm-bibtex)

(provide 'c-helm-bibtex)
;;; c-helm-bibtex.el ends here
