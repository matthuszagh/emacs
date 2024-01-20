;;; c-nixpkgs-fmt.el --- nixpkgs-fmt package configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'nixpkgs-fmt))

(require 'nixpkgs-fmt)

(add-hook 'nix-mode-hook 'nixpkgs-fmt-on-save-mode)
(remove-hook 'nix-mode-hook 'nixpkgs-fmt-on-save-mode)

(provide 'c-nixpkgs-fmt)

;;; c-nixpkgs-fmt.el ends here
