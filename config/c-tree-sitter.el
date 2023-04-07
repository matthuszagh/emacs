;;; c-tree-sitter.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (progn
      (straight-use-package 'tree-sitter)
      (straight-use-package 'tree-sitter-langs)))

(require 'tree-sitter)
(require 'tree-sitter-langs)
(require 'tree-sitter-debug)
(require 'tree-sitter-query)

;; enable tree-sitter in all supported modes
(global-tree-sitter-mode)
;; use tree-sitter for highlighting whenever tree-sitter-mode is enabled
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

(provide 'c-tree-sitter)
;;; c-tree-sitter.el ends here
