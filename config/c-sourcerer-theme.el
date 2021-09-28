;;; c-sourcerer-theme.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'sourcerer-theme))

(require 'sourcerer-theme)

(load-theme 'sourcerer)
(add-to-list 'default-frame-alist '(cursor-color . "#c2c2b0"))
(add-to-list 'default-frame-alist '(hl-line-face . "gray16"))

(if (featurep 'org)
    (progn
      (set-face-foreground 'org-block (face-foreground 'default))

      ;; set inline code appearance
      (set-face-background 'org-code "unspecified")
      (set-face-foreground 'org-code "#8686ae")
      (set-face-foreground 'org-link "#86aed5"))
  (mh:log-init "WARNING" "attempted to load sourcerer-theme configurations for org without first loading 'org"))

(if (featurep 'smart-mode-line)
    (progn
      (set-face-foreground 'sml/global "#c2c2b0")
      (set-face-foreground 'sml/filename "gold"))
  (mh:log-init "WARNING" "attempted to load sourcerer-theme configurations for smart-mode-line without first loading 'smart-mode-line"))

(provide 'c-sourcerer-theme)
;;; c-sourcerer-theme.el ends here
