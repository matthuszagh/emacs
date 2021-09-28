;;; c-lsp-pyright.el --- lsp-pyright configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(lsp-pyright :host github :repo "emacs-lsp/lsp-pyright")))

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))

(provide 'c-lsp-pyright)

;;; c-lsp-pyright.el ends here
