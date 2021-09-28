;;; c-ob-spice.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'org)
  (mh:log-init "ERROR" "attempted to load 'ob-spice before 'org"))

(if (featurep 'straight)
    (straight-use-package '(ob-spice
                            :repo "https://git.sr.ht/~bzg/org-contrib")))

(require 'ol-man)
(require 'ob-spice)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((spice . t)))

(provide 'c-ob-spice)
;;; c-ob-spice.el ends here
