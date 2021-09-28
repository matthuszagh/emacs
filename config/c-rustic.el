;;; c-rustic.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'rustic))

(require 'rustic)

(setq rustic-lsp-server 'rls)
(add-hook 'rustic-mode-hook
          (lambda ()
            (remove-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p t)))
(setq rustic-format-on-save t)

(provide 'c-rustic)
;;; c-rustic.el ends here
