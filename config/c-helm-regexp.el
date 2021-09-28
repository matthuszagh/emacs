;;; c-helm-regexp.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'helm)
  (mh:log-init "ERROR" "'helm-regexp is part of the 'helm package, but 'helm wasn't loaded"))

(require 'helm-regexp)

(provide 'c-helm-regexp)
;;; c-helm-regexp.el ends here
