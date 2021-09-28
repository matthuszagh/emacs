;;; c-dumb-jump.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'dumb-jump))

(require 'dumb-jump)

(setq dumb-jump-selector 'helm)

;; TODO this can probably be removed now (https://github.com/jacktasia/dumb-jump/pull/400)
(defun mh//override-dumb-jump-prompt-user-for-choice (proj results)
  "Put a PROJ's list of RESULTS in a 'popup-menu' (or helm/ivy)
for user to select.  Filters PROJ path from files for display."
  (let ((choices (--map (dumb-jump--format-result proj it) results)))
    (cond
     ((and (eq dumb-jump-selector 'ivy) (fboundp 'ivy-read))
      (funcall dumb-jump-ivy-jump-to-selected-function results choices proj))
     ((and (eq dumb-jump-selector 'helm) (fboundp 'helm))
      (helm :sources
        (helm-make-source "Jump to: " 'helm-source-sync
          :action '(("Jump to match" . dumb-jump-result-follow))
          :candidates (-zip choices results)
          :persistent-action 'dumb-jump-helm-persist-action)
        :buffer "*helm dumb jump choices*"))
     (t
      (dumb-jump-to-selected results choices (popup-menu* choices))))))

(advice-add 'dumb-jump-prompt-user-for-choice :override #'mh//override-dumb-jump-prompt-user-for-choice)

(provide 'c-dumb-jump)
;;; c-dumb-jump.el ends here
