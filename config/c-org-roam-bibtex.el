;;; c-org-roam-bibtex.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'org-roam-bibtex))

(require 'org-roam-bibtex)

(setq orb-file-field-extensions nil)
(org-roam-bibtex-mode)

(provide 'c-org-roam-bibtex)
;;; c-org-roam-bibtex.el ends here
