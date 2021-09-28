;;; c-org-eldoc.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'ob-spice)
  (mh:log-init "ERROR" "attempted to load 'org-eldoc before 'ob-spice"))

(require 'org-eldoc)

(provide 'c-org-eldoc)
;;; c-org-eldoc.el ends here
