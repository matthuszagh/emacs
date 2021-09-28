;;; c-diff-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'diff-mode)

(add-hook 'diff-mode-hook
          (lambda ()
            (setq-local require-final-newline nil)))

(provide 'c-diff-mode)
;;; c-diff-mode.el ends here
