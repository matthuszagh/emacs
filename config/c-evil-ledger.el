;;; c-evil-ledger.el --- evil-ledger configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'evil-ledger))

(require 'evil-ledger)
(add-hook 'ledger-mode 'evil-ledger-mode)

(provide 'c-evil-ledger)

;;; c-evil-ledger.el ends here
