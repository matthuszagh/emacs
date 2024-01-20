;;; pre-init.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun mh:log-init (level message)
  "Log LEVEL and MESSAGE to *init*.
LEVEL is the severity of the message, such as WARNING or ERROR."
  (unless (or (string-equal level "ERROR")
              (string-equal level "WARNING"))
    (error "Invalid LEVEL argument specified in 'mh:log-init"))
  (if (string-equal level "ERROR")
      (error message)
    (with-current-buffer (get-buffer-create "*init*")
      (insert (concat level ": " message "\n")))))

(provide 'pre-init)
;;; pre-init.el ends here
