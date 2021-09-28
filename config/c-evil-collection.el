;;; c-evil-collection.el --- Evil Collection Configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'evil)
  (mh:log-init "ERROR" "attempted to load 'evil-collection before 'evil"))

(if (featurep 'straight)
    (straight-use-package 'evil-collection))

(require 'evil-collection)

(evil-collection-init)
;; TODO relocate these to appropriate postinits.
;; TODO use general-def instead of evil-define-key
;; Jump to the bottom of the window when entering insert mode in terminal.
;; comint-mode configuration
;;
;; Same behavior for comint modes. Prevent this when in the middle of the line at the command
;; line. This allows evil navigation to edit the current command. I'd like this for term-mode too,
;; but it's much trickier (see emacs tex file).
(evil-collection-define-key 'normal 'comint-mode-map (kbd "i")
  (lambda ()
    (interactive)
    (if (eq (line-number-at-pos)
            (+ (evil-count-lines (point-min) (point-max)) 1))
        (evil-insert-state)
      (progn (comint-show-maximum-output)
             (evil-insert-state)))))
;; Use C-p and C-n to cycle through inputs for consistency with term-mode.
(evil-collection-define-key 'insert 'comint-mode-map
  (kbd "C-p") #'comint-previous-input
  (kbd "C-n") #'comint-next-input)

;; doc-view-mode configuration
;;
;; Use the same page navigation in doc-view as in pdf-mode.
(evil-collection-define-key 'normal 'doc-view-mode-map (kbd "j") 'doc-view-next-page)
(evil-collection-define-key 'normal 'doc-view-mode-map (kbd "k") 'doc-view-previous-page)

;; org-mode configuration
;; (evil-collection-define-key 'normal 'org-mode-map (kbd "<tab>") 'org-cycle)

;; proced-mode configuration
(evil-collection-define-key 'normal 'proced-mode-map (kbd "q") (lambda () (interactive)
                                                                 (quit-window)
                                                                 (command-execute 'symon-mode)))

(provide 'c-evil-collection)

;;; c-evil-collection.el ends here
