;;; c-elpy.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'yasnippet)
  (mh:log-init "ERROR" "attempted to load 'elpy before 'yasnippet"))

(if (featurep 'straight)
    (straight-use-package 'elpy))

(require 'elpy)

(add-hook 'python-mode-hook #'elpy-mode)
;;(remove-hook 'python-mode-hook #'elpy-mode)
(elpy-enable)

(provide 'c-elpy)
;;; c-elpy.el ends here
