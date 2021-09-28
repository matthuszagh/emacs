;;; c-flycheck-elsa.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'flycheck-elsa))

(require 'flycheck-elsa)

(add-hook 'emacs-lisp-mode-hook 'flycheck-elsa-setup)

(provide 'c-flycheck-elsa)
;;; c-flycheck-elsa.el ends here
