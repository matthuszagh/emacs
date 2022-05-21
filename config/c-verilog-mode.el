;;; c-verilog-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'verilog-mode)

(custom-set-variables
 '(verilog-indent-level 4)
 '(verilog-indent-level-module 4)
 '(verilog-indent-level-declaration 4)
 '(verilog-indent-level-behavioral 4)
 '(verilog-auto-lineup nil)
 '(c-basic-offset 4)
 '(verilog-auto-endcomments nil)
 ;; don't automatically insert newlines after colons
 '(verilog-auto-newline nil)
 '(verilog-linter "verilator –lint-only"))

(provide 'c-verilog-mode)
;;; c-verilog-mode.el ends here
