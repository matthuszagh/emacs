;;; c-lsp-ui.el --- lsp-ui configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'lsp-ui))

(use-package lsp-ui
  :config
  (lsp-ui-doc-enable 1))

(provide 'c-lsp-ui)

;;; c-lsp-ui.el ends here
