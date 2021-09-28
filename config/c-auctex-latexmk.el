;;; c-auctex-latexmk.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'auctex-latexmk))

(require 'auctex-latexmk)

(auctex-latexmk-setup)
(setq auctex-latexmk-inherit-TeX-PDF-mode t)

(provide 'c-auctex-latexmk)
;;; c-auctex-latexmk.el ends here
