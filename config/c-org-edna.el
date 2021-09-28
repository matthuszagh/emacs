;;; c-org-edna.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'org-edna))

(require 'org-edna)

(org-edna-load)

(provide 'c-org-edna)
;;; c-org-edna.el ends here
