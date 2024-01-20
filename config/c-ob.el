;;; c-ob.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This file provides customizations for org source code blocks.  In
;; particular, it sets the environment those source blocks see and
;; handles how they are executed.
;;
;;; Code:

(unless (and (featurep 'org-api)
             (featurep 'org-texnum))
  (mh:log-init "ERROR" "attempted to load 'c-ob before 'org-api and 'org-texnum"))

(org-babel-lob-ingest (concat user-emacs-directory "config/lob.org"))

(require 's)

(defun mh//light-backgroundp ()
  "Return t if the current background color is light, nil otherwise."
  ;; TODO The current implementation is too crude; it only returns t
  ;; if the background color is white. We also want other light colors
  ;; to evaluate to t.
  (string-equal (face-background 'default) "#ffffff"))

(defun mh//concat-list (list)
  (let ((res ""))
    (dolist (elem list)
      (setq res (concat res elem)))
    res))

(defun mh//header-match (elem match)
  "Returns `t' if MATCH is explicitly a header of ELEM.
Explicit in this context means that it's literally written in the
file rather than being provided as a default header argument."
  (let* ((elem (org-element-at-point))
         (elem-params (org-element-property :parameters elem))
         (elem-header (append (if elem-params
                                  (list elem-params)
                                nil)
                              (org-element-property :header elem)))
         (matchp nil))
    (dolist (elt elem-header)
      (if (string-match match elt)
          (setq matchp t)))
    matchp))

(defun mh//org-src-block-contents ()
  (let ((elem (org-element-at-point)))
    (concat (org-element-property :value elem)
            (mh//concat-list (org-element-property :header elem)))))

(defun mh//by-backend (blist)
  "TODO"
  (let ((ret nil))
    (if org-export-current-backend
        (let* ((backend-name org-export-current-backend)
               ;; Get the value for the backend, or t, if blist
               ;; doesn't specify the backend.
               (elem (or (assoc backend-name blist)
                         (assoc t blist))))
          (if elem
              (setq ret (cdr elem))))
      (let ((elem (assoc t blist)))
        (setq ret (cdr elem))))
    (eval ret)))

(defun mh/backend-name ()
  "Current export backend name, or 'org' if the src block is being
evaluated within an org buffer."
  (if org-export-current-backend
      (symbol-name org-export-current-backend)
    "org"))

(defun mh/org-in-latex-blockp ()
  "Indicate if we're inside a latex source block."
  (let ((elem (org-ml-parse-element-at (point))))
    (if (and (org-ml-is-type 'src-block elem)
             (string-equal (org-ml-get-property :language elem) "latex"))
        t
      nil)))

;; Load buffer-local variables when editing org src blocks.
(add-hook 'org-src-mode-hook 'hack-local-variables)

(defun mh/post-attr-value (key)
  "Extract an 'attr_wrap' setting for KEY from a :post header.
KEY is the key corresponding to the value to extract. For
example, setting the key to 'caption' would get the caption
value."
  (let* ((result nil)
         (elem (org-element-at-point))
         (headers (org-element-property :header elem)))
    (dolist (header headers)
      (if (equal (substring header 0 5)
                 ":post")
          ;; ignore ":post attr_wrap(" and ", data=*this*"
          (let* ((contents (substring header 16 -14))
                 (start (string-search key contents)))
            (if start
                ;; 2 for equals sign plus quote
                (let* ((start (+ start (length key) 2))
                       (stop (string-search "\"" contents start)))
                  (if stop
                      (setq result (substring contents start stop))))))))
    result))

(require 'org-api)
(require 'org-texnum)

(provide 'c-ob)
;;; c-ob.el ends here
