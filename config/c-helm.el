;;; c-helm.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'helm))

(require 'helm)

(add-hook 'helm-minibuffer-setup-hook (lambda ()
                                        (setq-local fill-column nil)))
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
(setq helm-org-format-outline-path t)
(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))
(setq helm-M-x-fuzzy-match t
      helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t
      helm-locate-fuzzy-match t
      helm-apropos-fuzzy-match t
      helm-lisp-fuzzy-completion t)
;;(use-package helm-config)
;; move to end or beginning of source when reaching top or bottom of source.
(setq helm-split-window-inside-p t
      helm-move-to-line-cycle-in-source t
      ;; search for library in `require' and `declare-function' sexp.
      helm-ff-search-library-in-sexp t
      ;; scroll 8 lines other window using M-<next>/M-<prior>
      helm-scroll-amount 8
      helm-ff-file-name-history-use-recentf t)
(helm-mode 1)
(setq-default helm-follow-mode-persistent t)

(custom-set-variables
 ;; The input should appear at the bottom of the window (i.e., normal
 ;; minibuffer location). I feel that placing the input at the top of
 ;; the helm buffer is counterintuitive because it makes it appear as
 ;; though the input is one of the selections from the list, which it
 ;; isn't.
 '(helm-echo-input-in-header-line t)
 ;; Limit helm buffer height to 20 lines.
 '(helm-autoresize-mode -1)
 '(helm-display-buffer-default-height 20)
 '(helm-autoresize-min-height 15)
 '(helm-autoresize-max-height 15)
 ;; maximum buffer string length before truncation
 '(helm-buffer-max-length 40))

(if (featurep 'c-org-roam)
    ;; Customizes helm to use
    ;; `helm-completing-read-sync-default-handler' for
    ;; `org-roam-node-find'. This propertizes the text display.
    (progn
      (add-to-list 'helm-completing-read-handlers-alist
                   '(org-roam-node-find . helm-completing-read-sync-default-handler))
      (add-to-list 'helm-completing-read-handlers-alist
                   '(org-roam-node-insert . helm-completing-read-sync-default-handler)))
  (mh:log-init "WARNING"
               "attempted to load org-roam customizations for helm before loading 'c-org-roam."))

(provide 'c-helm)
;;; c-helm.el ends here
