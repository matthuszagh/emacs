;;; c-magit.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'magit))

(require 'magit)

(add-hook 'magit-mode-hook (lambda ()
                             (setq whitespace-mode -1)))
(add-hook 'git-commit-setup-hook (lambda ()
                                   (set-fill-column 70)))
(add-hook 'git-commit-setup-hook (lambda ()
                                   (localleader
                                     :keymaps 'local
                                     "d" (lambda ()
                                           (call-interactively 'mh/insert-current-date)))))

(setq magit-repository-directories '(("~/src" . 10)))
(setq magit-restore-window-configuration t)

(defun mh/magit-fetch-all-repositories ()
  "Run `magit-fetch-all' in all repositories returned by `magit-list-repos`."
  (interactive)
  (dolist (repo (magit-list-repos))
    (message "Fetching in %s..." repo)
    (let ((default-directory repo))
      (magit-fetch-all (magit-fetch-arguments)))
    (message "Fetching in %s...done" repo)))

(provide 'c-magit)
;;; c-magit.el ends here
