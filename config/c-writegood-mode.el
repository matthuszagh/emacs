;;; c-writegood-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'writegood-mode))

(require 'writegood-mode)

(if (featurep 'org)
    (add-hook 'org-mode 'writegood-turn-on)
  (mh:log-init "WARNING" "writegood-mode attempted to set org configurations before loading 'org"))

(if (featurep 'magit)
    (add-hook 'git-commit-setup 'writegood-turn-on)
  (mh:log-init "WARNING" "writegood-mode attempted to set magit configurations before loading 'magit"))

(provide 'c-writegood-mode)
;;; c-writegood-mode.el ends here
