;;; c-modus-themes.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'modus-themes))

(require 'modus-themes)

;; ;; light theme
;; (load-theme 'modus-operandi)
;; ;; dark theme
;; (load-theme 'modus-vivendi)

(defun mh/use-light-theme ()
  "Use light theme."
  (interactive)
  (load-theme 'modus-operandi))

;; TODO not the right place for this. Also, doesn't quite work.
(defun mh/use-dark-theme ()
  "Use dark theme."
  (interactive)
  (disable-theme)
  (load (concat user-emacs-directory "config/c-naysayer-theme.el")))

(provide 'c-modus-themes)
;;; c-modus-themes.el ends here
