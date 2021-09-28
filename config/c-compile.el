;;; c-compile.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'compile)

(setq compilation-scroll-output 'next-error)
(setq compilation-skip-threshold 2)
(defun mh/toggle-comint-compilation ()
  "Restart compilation with (or without) `comint-mode'."
  (interactive)
  (cl-callf (lambda (mode) (if (eq mode t) nil t))
      (elt compilation-arguments 1))
  (recompile))

(provide 'c-compile)
;;; c-compile.el ends here
