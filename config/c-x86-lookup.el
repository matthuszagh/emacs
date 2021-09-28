;;; c-x86-lookup.el --- x86-lookup configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'x86-lookup))

(require 'x86-lookup)

;; TODO fix
(setq x86-lookup-pdf "~/doc/library/computing/software/assembly/Intel Software Developer’s Manual (2017).pdf")

(provide 'c-x86-lookup)

;;; c-x86-lookup.el ends here
