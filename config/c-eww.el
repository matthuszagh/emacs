;;; c-eww.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'eww))

(require 'eww)

(custom-set-variables
 ;; use eww as default browser
 '(browse-url-browser-function 'eww-browse-url)
 ;; use firefox as backup
 '(browse-url-secondary-browser-function 'browse-url-firefox)
 ;; use google as the search engine
 '(eww-search-prefix "https://duckduckgo.com/html/?q="))

(provide 'c-eww)
;;; c-eww.el ends here
