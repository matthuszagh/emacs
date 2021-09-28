;;; c-helm-org.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'helm)
  (mh:log-init "ERROR" "'helm-org attempted to load before 'helm"))

(if (featurep 'straight)
    (straight-use-package 'helm-org))

(require 'helm-org)

(setq helm-org-headings-max-depth 100)

(add-hook 'after-init-hook
          (lambda ()
            (unless (featurep 'org)
              (mh:log-init "ERROR" "'helm-org was configured but 'org was never loaded"))))

(provide 'c-helm-org)
;;; c-helm-org.el ends here
