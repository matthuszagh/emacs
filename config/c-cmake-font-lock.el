;;; c-cmake-font-lock.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'cmake-font-lock))

(use-package cmake-font-lock
  :defer t
  :commands (cmake-font-lock-activate)
  :hook (cmake-mode . (lambda ()
                        (cmake-font-lock-activate)
                        (font-lock-add-keywords
                         nil '(("\\<\\(FIXME\\|TODO\\|BUG\\|DONE\\)"
                                1 font-lock-warning-face t))))))

(provide 'c-cmake-font-lock)
;;; c-cmake-font-lock.el ends here
