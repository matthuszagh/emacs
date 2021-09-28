;;; c-ledger-mode.el --- ledger-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'org)
  (mh:log-init "ERROR" "attempted to load 'ledger-mode before 'org"))

(if (featurep 'straight)
    (straight-use-package 'ledger-mode))

(require 'ledger-mode)

(provide 'c-ledger-mode)

;;; c-ledger-mode.el ends here
