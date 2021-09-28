;;; c-man.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'man)

(setq Man-notify-method 'pushy)
(add-to-list 'same-window-buffer-names "*Man.*")


(provide 'c-man)
;;; c-man.el ends here
