;;; c-ob-sagemath.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'org)
  (mh:log-init "ERROR" "attempted to load 'ob-sagemath before 'org"))

(if (featurep 'straight)
    (straight-use-package 'ob-sagemath))

(require 'ob-sagemath)

;; load sagemath
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sagemath . t)))

(setq org-babel-default-header-args:sage
      '((:session . t)
        (:results . "output")
        (:cache . "yes")))

(provide 'c-ob-sagemath)
;;; c-ob-sagemath.el ends here
