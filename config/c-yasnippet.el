;;; c-yasnippet.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(yasnippet :type git :host github :repo "Zetagon/yasnippet")))

(require 'yasnippet)

;; Allow nested expansion.
(setq yas-triggers-in-field t)
(add-to-list 'yas-snippet-dirs (concat user-emacs-directory "snippets/"))
(yas-reload-all)
;; auto expand snippets with # condition: 'auto
(defun mh/yas-try-expanding-auto-snippets ()
  (when (and (boundp 'yas-minor-mode) yas-minor-mode)
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
      (yas-expand))))
(add-hook 'post-command-hook #'mh/yas-try-expanding-auto-snippets)

(add-hook 'TeX-mode-hook #'yas-minor-mode)
(add-hook 'verilog-mode-hook #'yas-minor-mode)
(add-hook 'emacs-lisp-mode-hook #'yas-minor-mode)
(add-hook 'c-mode-common-hook #'yas-minor-mode)

(if (featurep 'org)
    (add-hook 'org-mode-hook #'yas-minor-mode)
  (mh:log-init "WARNING" "attempted to perform yasnippet org configurations without loading 'org"))

(provide 'c-yasnippet)
;;; c-yasnippet.el ends here
