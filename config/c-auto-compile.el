;;; c-auto-compile.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'auto-compile))

;; Prefer `.el' files over outdated `.elc' files. Use this with `auto-compile' to automatically
;; byte-compile outdated files.
(setq load-prefer-newer t)

(require 'auto-compile)

(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

(provide 'c-auto-compile)
;;; c-auto-compile.el ends here
