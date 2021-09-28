;;; c-term.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'term)

;; Don't truncate terminal output
(setq term-buffer-maximum-size 0)

(provide 'c-term)
;;; c-term.el ends here
