;;; c-org-noter.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'org-noter))

(require 'org-noter)

(setq org-noter-notes-search-path "~/doc/notes/wiki/refs")

(provide 'c-org-noter)
;;; c-org-noter.el ends here
