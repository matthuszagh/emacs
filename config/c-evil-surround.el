;;; c-evil-surround.el --- evil-surround configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'evil-surround))

(require 'evil-surround)

(global-evil-surround-mode 1)

(provide 'c-evil-surround)

;;; c-evil-surround.el ends here
