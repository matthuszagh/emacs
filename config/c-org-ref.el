;;; c-org-ref.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'pdf-tools)
  (mh:log-init "ERROR" "attempted to load 'org-ref before dependency 'pdf-tools"))

(if (featurep 'straight)
    (straight-use-package 'org-ref))

(require 'org-ref)
(setq org-ref-default-bibliography "~/doc/notes/wiki/library.bib")
(setq org-ref-bibliography-files '("~/doc/notes/wiki/library.bib"))

(provide 'c-org-ref)
;;; c-org-ref.el ends here
