;;; c-nix-update.el --- nix-update package configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'nix-update))

(require 'nix-update)

(provide 'c-nix-update)

;;; c-nix-update.el ends here
