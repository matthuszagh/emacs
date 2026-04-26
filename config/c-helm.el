;;; c-helm.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'helm))

(require 'helm)

;; Upstream `helm-locate-lib-get-summary' (helm-lib.el) errors with
;; "Args out of range" when a file's header looks like
;; `;;; foo.el ---  -*- lexical-binding: t; -*-' (no description). It
;; calls (split-string desc "-\\*-" nil "[ \t\n\r-]+"), and the TRIM
;; regex's `-' character lets it greedily match into the separator's
;; dashes, pushing this-start past this-end so substring fails.
;; Override with a version that trims first, then splits without a
;; dash-containing TRIM regex.
(with-eval-after-load 'helm-lib
  (defun helm-locate-lib-get-summary (file)
    "Extract library description from FILE."
    (with-temp-buffer
      (let (desc)
        (cl-letf (((symbol-function 'message) #'ignore))
          (insert-file-contents file nil 0 128))
        (goto-char (point-min))
        (when (re-search-forward "^;;;?\\(.*\\) ---? \\(.*\\)" (pos-eol) t)
          (setq desc (string-trim (match-string-no-properties 2))))
        (if (or (null desc) (string= "" desc)
                (string-match "\\`-\\*-" desc))
            "Not documented"
          (string-trim (car (split-string desc "-\\*-"))))))))

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

;; Suspend Helm while a recursive minibuffer is active (e.g. GPG
;; passphrase prompt for authinfo.gpg during TRAMP connections).
;; Without this, Helm's idle timer and post-command-hook functions
;; steal focus from the password prompt.
(defvar mh/helm--suspended-for-recursive-mb nil
  "Non-nil when Helm was suspended due to a recursive minibuffer.")

(defun mh/helm-suspend-for-recursive-minibuffer ()
  "Suspend Helm when entering a recursive minibuffer."
  (when (and (> (minibuffer-depth) 1)
             (helm-alive-p))
    (setq mh/helm--suspended-for-recursive-mb t)
    (setq helm-suspend-update-flag t)
    (remove-hook 'post-command-hook #'helm--maybe-update-keymap)
    (remove-hook 'post-command-hook #'helm--update-header-line)))

(defun mh/helm-resume-after-recursive-minibuffer ()
  "Resume Helm when exiting a recursive minibuffer."
  (when mh/helm--suspended-for-recursive-mb
    (setq mh/helm--suspended-for-recursive-mb nil)
    (setq helm-suspend-update-flag nil)
    (add-hook 'post-command-hook #'helm--maybe-update-keymap)
    (add-hook 'post-command-hook #'helm--update-header-line)))

(add-hook 'minibuffer-setup-hook #'mh/helm-suspend-for-recursive-minibuffer)
(add-hook 'minibuffer-exit-hook #'mh/helm-resume-after-recursive-minibuffer)
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
