;;; c-proced.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'proced)

(defun mh/strace-pid-proced (expr)
  ""
  (interactive
   (list
    (read-string "trace expression: " "write")))
  (let ((pid (number-to-string (proced-pid-at-point))))
    (start-process-shell-command
     (concat "strace " pid)
     (concat "strace " pid)
     (if (string-empty-p expr)
         (concat "strace -p" pid " -s9999")
       (concat "strace -p" pid " -s9999 -e " expr)))))

(provide 'c-proced)
;;; c-proced.el ends here
