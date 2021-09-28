;;; c-cmake-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'cmake-mode))

(use-package cmake-mode
  :mode ("CMakeLists.txt" "\\.cmake\\'")
  :hook (cmake-mode . (lambda ()
                        (set (make-local-variable 'company-backends)
                             (list
                              (cons 'company-cmake company-backends))))))

(provide 'c-cmake-mode)
;;; c-cmake-mode.el ends here
