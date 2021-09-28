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
(use-package helm-config)
;; move to end or beginning of source when reaching top or bottom of source.
(setq helm-split-window-inside-p t
      helm-move-to-line-cycle-in-source t
      ;; search for library in `require' and `declare-function' sexp.
      helm-ff-search-library-in-sexp t
      ;; scroll 8 lines other window using M-<next>/M-<prior>
      helm-scroll-amount 8
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)
(setq helm-autoresize-max-height 0
      helm-autoresize-min-height 30)
(helm-autoresize-mode 1)
(helm-mode 1)
;; maximum buffer string length before truncation
(setq helm-buffer-max-length 60)
(setq-default helm-follow-mode-persistent t)
;; configure files cache
(setq helm-ff-refresh-cache-delay 0.3)
(setq helm-ff-cache-mode-post-delay 0.3)

(provide 'c-helm)
;;; c-helm.el ends here
