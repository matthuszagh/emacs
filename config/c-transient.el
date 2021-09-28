;;; c-transient.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(transient :type git :host github :repo "magit/transient")))

(require 'transient)

;; Only display magit popup at the bottom of the current window rather than the entire frame.
(setq transient-display-buffer-action '(display-buffer-below-selected))

(provide 'c-transient)
;;; c-transient.el ends here
