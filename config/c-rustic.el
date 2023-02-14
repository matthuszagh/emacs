;;; c-rustic.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'rustic))

(require 'rustic)

(add-hook 'rustic-mode-hook
          (lambda ()
            (remove-hook 'after-save-hook
                         'executable-make-buffer-file-executable-if-script-p t)))

(custom-set-variables
 '(rustic-format-on-save t)
 '(rustic-lsp-server 'rls)
 '(rustic-rustfmt-config-alist '((max_width . 80))))

(provide 'c-rustic)
;;; c-rustic.el ends here
