;;; c-helm-bibtex.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'org)
  (mh:log-init "ERROR" "attempted to load 'helm-bibtex before 'org"))

(if (featurep 'straight)
    (straight-use-package 'helm-bibtex))

(require 'helm-bibtex)

(setq bibtex-completion-bibliography "~/doc/notes/wiki/library.bib")
(setq bibtex-completion-library-path "~/doc/library")
(setq bibtex-completion-pdf-field "file")
(setq bibtex-completion-notes-path "~/doc/notes/wiki/refs")

(provide 'c-helm-bibtex)
;;; c-helm-bibtex.el ends here
