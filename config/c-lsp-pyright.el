;;; c-lsp-pyright.el --- lsp-pyright configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(lsp-pyright :host github :repo "emacs-lsp/lsp-pyright")))

(require 'lsp-pyright)

(add-hook 'python-mode (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))

(custom-set-variables
 '(lsp-pyright-python-executable-cmd "python3"))

(provide 'c-lsp-pyright)

;;; c-lsp-pyright.el ends here
