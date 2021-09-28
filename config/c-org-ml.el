;;; c-org-ml.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(org-ml
                            :host github
                            :repo "ndwarshuis/org-ml")))

(require 'org-ml)

(provide 'c-org-ml)
;;; c-org-ml.el ends here
