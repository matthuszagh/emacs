;;; c-org-texnum.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(org-texnum
                            :host github
                            :repo "matthuszagh/org-texnum")))

(require 'org-texnum)

(provide 'c-org-texnum)
;;; c-org-texnum.el ends here
