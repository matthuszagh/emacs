;;; c-eww.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'eww))

(require 'eww)

;; use eww as default browser
(setq browse-url-browser-function 'eww-browse-url)
;; use firefox as backup
(setq browse-url-secondary-browser-function 'browse-url-firefox)

(provide 'c-eww)
;;; c-eww.el ends here
