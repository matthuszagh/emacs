;;; c-helm-grep.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'helm)
  (mh:log-init "ERROR" "'helm-grep is a feature provided by 'helm, but 'helm wasn't loaded"))

(require 'helm-grep)

;; use ripgrep instead of ag
(setq helm-grep-ag-command (concat "rg"
                                   " --color=never"
                                   " --smart-case"
                                   " --no-heading"
                                   " --line-number %s %s %s"))

(provide 'c-helm-grep)
;;; c-helm-grep.el ends here
