;;; c-auto-activating-snippets.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(auto-activating-snippets :type git :host github :repo "ymarco/auto-activating-snippets")))

(require 'aas)

(add-hook 'LaTeX-mode-hook #'aas-activate-for-major-mode)

(if (featurep 'org)
    (progn
      (add-hook 'org-mode-hook #'aas-activate-for-major-mode)
      (add-hook 'org-src-mode-hook
                (lambda ()
                  (if (eq major-mode 'latex-mode)
                      (aas-mode)))))
  (mh:log-init "WARNING" "attempted to perform auto-activating-snippets org configurations without loading 'org"))

(provide 'c-auto-activating-snippets)
;;; c-auto-activating-snippets.el ends here
