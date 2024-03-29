;;; completions-layer.el --- Summary -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(layer-def completions
  :depends (snippet)

  :presetup
  (:layer straight
   (straight-use-package 'company))

  :setup
  (use-package company
    :config
    ;; show completions immediately
    (setq company-idle-delay 0.1)
    (setq company-minimum-prefix-length 2)
    (setq company-show-numbers t)
    (global-company-mode)
    ;; Maintain case information for completions.
    (setq company-dabbrev-downcase nil)
    (setq company-dabbrev-ignore-case nil)
    ;; Default backends.
    (setq company-backends '(company-files
                             company-keywords
                             company-capf
                             ;; company-dabbrev
                             company-dabbrev-code)))

  :postsetup
  (:layer keybinding-management
   ;; (general-def company-active-map
   ;;   "<tab>" 'company-complete-selection)
   (general-def company-active-map
     "<tab>" 'company-complete-common))

  ;; TODO this is temporary since completions do not currently work
  ;; with org-roam and they make editing slower. However, this should
  ;; be fixed at some point in the future at which point they should
  ;; be reenabled. See the commented code below.
  (:layer org-roam
   ;; disable company mode in org mode buffers
   (add-hook 'org-mode-hook
             (lambda ()
               (company-mode 0))))
  ;; (:layer org-roam
  ;;  (setq org-roam-completion-everywhere t)
  ;;  ;; (add-hook 'org-mode-hook 'company-mode)
  ;;  (add-hook 'org-mode-hook
  ;;            (lambda ()
  ;;              (setq-local company-backends '(company-capf)))))
  )

;;; completions-layer.el ends here
