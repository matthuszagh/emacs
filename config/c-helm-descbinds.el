;;; c-helm-descbinds.el --- helm-descbinds configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'helm-descbinds))

(if (featurep 'helm)
    (progn
      (require 'helm-descbinds)
      (helm-descbinds-mode))
  (mh:log-init "ERROR: helm-descbinds attempted to load before helm."))

(provide 'c-helm-descbinds)

;;; c-helm-descbinds.el ends here
