;;; c-org-api.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'org-ml)
  (mh:log-init "ERROR" "attempted to load 'org-api before 'org-ml"))

(if (featurep 'straight)
    (straight-use-package '(org-api
                            :host github
                            :repo "matthuszagh/org-api")))

(require 'org-api)

(provide 'c-org-api)
;;; c-org-api.el ends here
