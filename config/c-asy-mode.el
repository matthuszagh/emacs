;;; c-asy-mode.el --- asy-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Configurations for asy-mode, which is a major mode for editing
;; Asymptote source files.
;;
;;; Code:

(use-package asy-mode
  :mode (("\\.asy\\'" . asy-mode)))

(defun mh/color-name-to-asy-rgb (name)
  ""
  (let ((res "rgb(")
        (color-list (color-name-to-rgb name)))
    (setq res (concat res (number-to-string (nth 0 color-list)) ", "))
    (setq res (concat res (number-to-string (nth 1 color-list)) ", "))
    (setq res (concat res (number-to-string (nth 2 color-list)) ")"))))

(provide 'c-asy-mode)

;;; c-asy-mode.el ends here
