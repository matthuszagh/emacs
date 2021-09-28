;;; c-helm-projectile.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'helm)
  (mh:log-init "ERROR" "'helm-projectile attempted to load before 'helm"))

(if (featurep 'straight)
    (straight-use-package '(helm-projectile :type git :host github :repo "matthuszagh/helm-projectile")))

(require 'helm-projectile)

(provide 'c-helm-projectile)
;;; c-helm-projectile.el ends here
