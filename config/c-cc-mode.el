;;; c-cc-mode.el --- cc-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'cc-mode))

(require 'cc-mode)

(cl-pushnew '("\\.c\\'" . c-mode) auto-mode-alist)
(cl-pushnew '("\\.cc\\'" . c++-mode) auto-mode-alist)
(cl-pushnew '("\\.cpp\\'" . c++-mode) auto-mode-alist)
(cl-pushnew '("\\.tpp\\'" . c++-mode) auto-mode-alist)

(custom-set-variables
 '(tab-width 8)
 '(c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "linux"))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (add-hook 'before-save-hook 'clang-format-buffer nil t)))

(provide 'c-cc-mode)

;;; c-cc-mode.el ends here
