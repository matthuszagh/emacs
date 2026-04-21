;;; c-org-drill.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'org-drill))

(require 'org-drill)

(custom-set-variables
 '(org-drill-scope 'directory)
 ;; sometimes the heading can provide too much of a hint
 '(org-drill-hide-item-headings-p t)
 ;; Add a bit of random noise. This has at least a few benefits. For
 ;; one, I tend to add related cards in batches and it's better not to
 ;; review these at the same time (see interleaving in
 ;; learning). Additionally, if I add cards in infrequent batches,
 ;; this evens out review.
 '(org-drill-add-random-noise-to-intervals-p t)
 ;; Maximum duration of a drill session in minutes. nil means no
 ;; limit.
 '(org-drill-maximum-duration nil)
 ;; maximum items reviewed in a session
 '(org-drill-maximum-items-per-session 20))

;; TODO temporary workaround until org-mode is updated (see
;; https://claude.ai/chat/d3fdcfad-dcdc-4b6e-b68a-a3f48e874132)
(unless (fboundp 'org-fold-core-get-regions)
  (defun org-fold-core-get-regions (&rest _)
    "Shim for old Org compatibility with Emacs 30 built-in primitives."
    nil))

(provide 'c-org-drill)
;;; c-org-drill.el ends here
