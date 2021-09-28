;;; c-no-littering.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'no-littering))

(require 'no-littering)

;; Place UI customizations in its own file. Please don't use this!
;; TODO get rid of user customizations entirely.
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
;; (when (file-exists-p custom-file)
;;   (load custom-file))

;; The savefile directory contains `recentf' files, `savehist' and `saveplace'.
(savehist-mode -1)
;; (defconst savefile-dir (no-littering-expand-var-file-name "savefile"))
;; (unless (file-exists-p savefile-dir)
;;   (make-directory savefile-dir))

;; auto saves
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(provide 'c-no-littering)
;;; c-no-littering.el ends here
