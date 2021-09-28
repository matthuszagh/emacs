;;; c-lsp-mode.el --- lsp-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'lsp-mode))

(require 'lsp-mode)

(add-hook 'prog-mode-hook 'lsp-mode)
(add-hook 'sh-mode-hook 'lsp)
(add-hook 'TeX-mode-hook 'lsp)
(setq lsp-completion-provider :capf)
(add-to-list 'lsp-language-id-configuration '(cython-mode . "cython"))
(setq lsp-log-io t)
;; automatically guess project root with projectile
(setq lsp-auto-guess-root t)
(setq lsp-idle-delay 0.5)

;; nix
(add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                  :major-modes '(nix-mode)
                  :server-id 'nix))

;; c
(add-hook 'c-mode-common-hook 'lsp)
(setq lsp-clients-clangd-args '("--all-scopes-completion"
                                ;; index in background
                                "--background-index"
                                ;; use clang-tidy
                                "--clang-tidy"
                                "--completion-style=detailed"
                                ;; insert missing headers
                                "--header-insertion=iwyu"
                                ;; suggest missing headers
                                "--suggest-missing-includes"
                                ;; use 8 cores
                                "-j=8"
                                ;; store PCH in memory for better performance
                                "--pch-storage=memory"
	                        "--clang-tidy-checks=-*,clang-analyzer-*"
                                ",cert-*,bugprone-*,performance-*,portability-*"
                                ",readability-*,-clang-analyzer-cplusplus*"))

(provide 'c-lsp-mode)

;;; c-lsp-mode.el ends here
