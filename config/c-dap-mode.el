;;; c-dap-mode.el --- dap-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'dap-mode))

(require 'dap-mode)
(dap-mode 1)
(dap-ui-mode 1)

(dap-register-debug-template "Rust::GDB Run Configuration"
                             (list :type "gdb"
                                   :request "launch"
                                   :name "GDB::Run"
                                   :gdbpath "rust-gdb"
                                   :target nil
                                   :cwd nil))

(require 'dap-gdb-lldb)
(dap-gdb-lldb-setup)

(provide 'c-dap-mode)

;;; c-dap-mode.el ends here
