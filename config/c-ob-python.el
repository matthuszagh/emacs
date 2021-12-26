;;; c-ob-python.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'ob-python)

(custom-set-variables
 ;; don't display warnings
 `(org-babel-python-command "python3 -Wignore"))

(defun mh//ob-python-results ()
  ""
  (mh//by-backend `((latex . "output raw")
                    (t . ,(if (mh//header-match (org-element-at-point) ":_class pylatex")
                              "file link replace"
                            "output")))))

;; (defun mh//ob-python-wrap ()
;;   ""
;;   (mh//by-backend `((latex . [])
;;                     (t . "results"))))

;; TODO I should probably change the naming scheme to not conflict
;; with variables I might otherwise use. Maybe lead with underscore?
(setq org-babel-default-header-args:python
      `((:exports . "both")
        (:results . (lambda () (mh//ob-python-results)))
        (:wrap . "results")
        (:var . (lambda ()
                  (concat "fname=\"" (mh//org-src-block-result-filename) "\"")))
        (:var . (lambda ()
                  (concat "bg=\"" (substring (face-background 'default) 1 nil) "\"")))
        (:var . (lambda ()
                  (concat "backend=\"" (mh/backend-name) "\"")))
        (:var . (lambda ()
                  (concat "caption=\"" (mh/post-attr-value "caption") "\"")))
        (:var . (lambda ()
                  (concat "name=\"" (mh/post-attr-value "name") "\"")))
        (:cache . "yes")
        (:file . (lambda ()
                   (if (mh//header-match (org-element-at-point) ":_class pylatex")
                       (mh//org-src-block-result-filename)
                     "")))))

(provide 'c-ob-python)
;;; c-ob-python.el ends here
