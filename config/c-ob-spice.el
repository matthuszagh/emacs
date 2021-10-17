;;; c-ob-spice.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'org)
  (mh:log-init "ERROR" "attempted to load 'ob-spice before 'org"))

(require 'ol-man)
(require 'ob-spice)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((spice . t)
   (asymptote . t)
   (ein . t)
   (io . t)
   (ledger . t)
   (mscgen . t)
   (picolisp . t)
   (shen . t)))

(provide 'c-ob-spice)
;;; c-ob-spice.el ends here
