;;; c-helm-ls-git.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'helm-ls-git))

(require 'helm-ls-git)

(setq helm-locate-project-list '("~/src"))
(setq helm-ls-git-status-command 'magit-status-setup-buffer)
;; search the full project, rather than just under the current directory
(setq helm-grep-git-grep-command "git --no-pager grep -n%cH --color=always --full-name -e %p")

(provide 'c-helm-ls-git)
;;; c-helm-ls-git.el ends here
