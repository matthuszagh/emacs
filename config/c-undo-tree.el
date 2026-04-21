;;; c-undo-tree.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'undo-tree))

(require 'undo-tree)

(add-hook 'undo-tree-visualizer-mode (lambda ()
                                       (auto-save-mode 1)))
;; For some reason, this is cleared when undo tree visualizer exits,
;; so enable it every time we enter the tree visualizer.
(add-hook 'undo-tree-visualizer-mode (lambda ()
                                       (setq undo-tree-visualizer-diff t)))

(global-undo-tree-mode)
(global-undo-tree-mode -1)
;; Save undo information persistently (i.e. across sessions)
(setq undo-tree-auto-save-history t)
(setq undo-tree-visualizer-timestamps t)

(provide 'c-undo-tree)
;;; c-undo-tree.el ends here
