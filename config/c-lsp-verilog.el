;;; c-lsp-verilog.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'lsp-verilog)

;; I want to use rules_config_search for linting but customizing
;; `lsp-clients-verible-executable' doesn't work. So, I completely
;; redefine the lsp client.
(lsp-register-client
 (make-lsp-client
  :new-connection
  (lsp-stdio-connection
   '("verible-verilog-ls"
     ;; Search for linter rules in the nearest .rules.verible_lint
     ;; file.
     "--rules_config_search"
     ;; Formatter arguments. The formatter does not support a rules
     ;; file like the linter.
     "--column_limit=80"
     "--indentation_spaces=4"
     "--formal_parameters_indentation=indent"
     "--named_parameter_indentation=indent"
     "--named_port_indentation=indent"
     "--port_declarations_indentation=indent"
     "--port_declarations_right_align_packed_dimensions=true"
     "--port_declarations_right_align_unpacked_dimensions=true"
     "--try_wrap_long_lines=true"
     "--wrap_end_else_clauses=true"))
  :major-modes '(verilog-mode)
  :language-id "verilog"
  :priority -2
  :server-id 'lsp-verilog-verible))

(provide 'c-lsp-verilog)
;;; c-lsp-verilog.el ends here
