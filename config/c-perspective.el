;;; c-perspective.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'perspective))

(require 'perspective)

(persp-mode)
(setq persp-state-default-file (concat user-emacs-directory "var/perspective/save"))
(add-hook 'kill-emacs-hook #'persp-state-save)

(provide 'c-perspective)
;;; c-perspective.el ends here
