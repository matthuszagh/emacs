;;; c-window.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'window)

(add-to-list 'display-buffer-alist
             '("\\*nixos-rebuild\\*"
               (display-buffer-reuse-window display-buffer-same-window)))
(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-reuse-window display-buffer-same-window)))

(add-to-list 'same-window-buffer-names "*Proced*")

(provide 'c-window)
;;; c-window.el ends here
