;;; c-helm-recoll.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'helm-recoll))

(require 'helm-recoll)
(helm-recoll-create-source "library" "~/.recoll/library")

(defun helm-librarian//resource-display (checksum)
  "TODO basically copied from helm-librarian//candidates."
  (let ((json-parse-result
         (ignore-errors
           (json-parse-string
            (shell-command-to-string
             ;; TODO the quotes will prevent doing something like
             ;; r"search string".
             (concat librarian-executable
                     " -d "
                     librarian-library-directory
                     " search \""
                     (file-name-nondirectory checksum)
                     "\""))))))
    (if json-parse-result
        (nth 0 (mapcar (lambda (result)
                         `(,(funcall librarian-display-function result) . ,result))
                       json-parse-result)))))

(defun helm-recoll-filter-one-by-one (file)
  "Strip out all garbage provided by recoll."
  (when (string-match "\\`\\(.*\\)\\(\\s-+\\)\\(\\[file://\\)\\([^]]+\\)\\(\\]\\)" file)
    ;; FIXME: Should I filter out directories from 1th group (inode/directory)?
    ;;(helm-librarian//resource-display (match-string 4 file))
    (match-string 4 file)
    ))

;; (advice-add 'override 'helm-recoll-filter-one-by-one)

(provide 'c-helm-recoll)
;;; c-helm-recoll.el ends here
