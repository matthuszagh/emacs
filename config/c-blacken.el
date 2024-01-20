;;; c-blacken.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'blacken))

(require 'blacken)

(add-hook 'python-mode-hook #'blacken-mode)
(if (featurep 'c-sage-shell-mode)
    (add-hook 'sage-shell:sage-mode-hook
              (lambda ()
                (blacken-mode -1)))
  (mh:log-init "WARNING" "Failed to define blacken customizations for sage-shell:sage-mode, since sage was never loaded."))

(setq blacken-line-length 79)
(setq blacken-only-if-project-is-blackened nil)

(provide 'c-blacken)
;;; c-blacken.el ends here
