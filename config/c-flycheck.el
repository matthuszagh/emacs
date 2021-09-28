;;; c-flycheck.el --- flycheck configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'flycheck))

(require 'flycheck)

;; Turn flycheck on everywhere
(global-flycheck-mode t)
(add-hook 'c-common-hook 'flycheck-mode)
(add-hook 'sh-mode-hook 'flycheck-mode)
(setq-default flycheck-verilog-verilator-executable "verilator_bin")

(provide 'c-flycheck)

;;; c-flycheck.el ends here
