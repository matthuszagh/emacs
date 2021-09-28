;;; c-rainbow-delimiters.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'rainbow-delimiters))

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(provide 'c-rainbow-delimiters)
;;; c-rainbow-delimiters.el ends here
