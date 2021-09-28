;;; c-spaceline.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'spaceline))

(require 'spaceline)

(spaceline-spacemacs-theme)
(setq spaceline-minor-modes-p nil)
(spaceline-helm-mode)

;; Change evil face depending on active evil mode.
(setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)

(if (featurep 'org)
    (progn
      (defun mh/org-get-truncated-clock-string ()
        "Adapted from `org-clock-get-clock-string'. This just gets
rid of the headline, which takes too much space."
        (let ((clocked-time (org-clock-get-clocked-time)))
          (if org-clock-effort
	      (let* ((effort-in-minutes (org-duration-to-minutes org-clock-effort))
	             (work-done-str
		      (propertize (org-duration-from-minutes clocked-time)
			          'face
			          (if (and org-clock-task-overrun
				           (not org-clock-task-overrun-text))
				      'org-mode-line-clock-overrun
			            'org-mode-line-clock)))
	             (effort-str (org-duration-from-minutes effort-in-minutes)))
	        (format (propertize " [%s/%s]" 'face 'org-mode-line-clock)
		        work-done-str effort-str))
            (format (propertize " [%s]" 'face 'org-mode-line-clock)
	            (org-duration-from-minutes clocked-time)))))
      (setq spaceline-org-clock-format-function #'mh/org-get-truncated-clock-string)))

(provide 'c-spaceline)
;;; c-spaceline.el ends here
