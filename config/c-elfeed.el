;;; c-elfeed.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'elfeed))

(require 'elfeed)

(setq elfeed-feeds
      '(("http://nullprogram.com/feed/" emacs)
        ("http://endlessparentheses.com/atom.xml" emacs)
        ("https://www.preposterousuniverse.com/blog/feed/" physics)
        ("http://www.math.columbia.edu/~woit/wordpress/?feed=rss2" physics)
        ("https://lab.whitequark.org/atom.xml")
        ("http://newartisans.com/rss.xml" programming)))
(setq elfeed-search-filter "@6-months-ago +unread")

(provide 'c-elfeed)
;;; c-elfeed.el ends here
