;;; c-nov.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (progn
      ;; prerequisite for nov
      (straight-use-package 'esxml)
      (straight-use-package 'nov)))

(require 'nov)

(custom-set-variables
 '(nov-variable-pitch nil))

(provide 'c-nov)
;;; c-nov.el ends here
