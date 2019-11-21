;;; writing-layer.el --- Summary -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(layer-def writing
  :presetup
  (:layer straight
   (straight-use-package 'writegood-mode))
  :setup
  (use-package writegood-mode
    :functions writegood-mode)

  (use-package langtool
    :config
    (setq langtool-bin "languagetool-commandline"))

  :postsetup
  (:layer org
   (add-hook 'org-mode 'writegood-turn-on))
  (:layer vcs
   (add-hook 'git-commit-setup 'writegood-mode)))

;;; writing-layer.el ends here
