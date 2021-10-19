;;; c-naysayer-theme.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'naysayer-theme))

(require 'naysayer-theme)

(load-theme 'naysayer t)
(setq mh-cursor-color (face-background 'cursor))
(setq mh-foreground-color (face-foreground 'default))
(setq mh-background-color (face-background 'default))
(set-face-attribute 'highlight nil :background "dark slate blue")
(set-face-attribute 'region nil :background "dark slate blue")
;; 'fixed-pitch (used, among other things, for org-block) defaults to
;; the "Monospace" family for the selected font.  While this still
;; uses "Source Code Pro", it isn't as nice as the "Regular" font
;; family (which is monospace anyway). We therefore unspecify this to
;; revert to "Regular".
(set-face-attribute 'fixed-pitch nil :family "unspecified")

;; This by default uses "burlywood", which is very close to but
;; distinct from the default face foreground. This slight difference
;; clashes with the default one. Moreover, it makes inline math
;; snippets use this burlywood color.
(set-face-foreground 'font-latex-math-face (face-foreground 'default))

(if (featurep 'org)
    (progn
      (set-face-foreground 'org-block (face-foreground 'default))

      ;; set inline code appearance
      (set-face-background 'org-code "#113e47")
      (set-face-foreground 'org-code (face-foreground 'default))
      (set-face-foreground 'org-link "#86aed5")

      (set-face-foreground 'mh-org-roam-node-outline-prefix-face "grey40")
      (set-face-foreground 'mh-org-roam-node-outline-suffix-face (face-foreground 'default))
      (set-face-foreground 'mh-org-roam-node-tags-face "grey40")
      (set-face-attribute 'mh-org-roam-node-tags-face nil :slant 'italic)

      ;; org-level-n are inherited from outline-n.
      (set-face-foreground 'outline-1 "white")
      (set-face-foreground 'outline-2 "#44b340")
      (set-face-foreground 'outline-3 "light sky blue")
      (set-face-foreground 'outline-4 "khaki")
      (set-face-foreground 'outline-5 "light grey")
      (set-face-foreground 'outline-6 "#ffaa00")
      ;; light pink
      ;; light purple

      ;; org todo keyword faces
      (set-face-foreground 'org-todo "#d4d4d4")
      (setq org-todo-keyword-faces '(("TODO" . (:foreground "#f1372d"
                                                :weight bold))
                                     ("FILE" . (:foreground "orange"
                                                :weight bold))
                                     ("DONE" . (:foreground "PaleGreen"
                                                :weight bold))))
      (setq org-fontify-done-headline nil))
  (mh:log-init "ERROR" "attempted to load 'naysayer-theme customizations for 'org without loading 'org"))

(if (featurep 'org-ref)
    (set-face-foreground 'org-ref-ref-face "#ffaa00")
  (mh:log-init "ERROR" "attempted to load 'naysayer-theme customizations for 'org-ref without loading 'org-ref"))

(if (featurep 'helm)
    (progn
      (set-face-attribute 'helm-ff-directory nil :foreground "white" :background (face-background 'default))
      (set-face-attribute 'helm-selection nil :background "dark slate blue")
      (let ((fcolor (face-foreground 'default)))
        (set-face-attribute 'helm-ff-file-extension nil :foreground fcolor)
        (set-face-attribute 'helm-ff-file nil :foreground fcolor)))
  (mh:log-init "ERROR" "attempted to load 'naysayer-theme customizations for 'helm without loading 'helm"))

(provide 'c-naysayer-theme)
;;; c-naysayer-theme.el ends here
