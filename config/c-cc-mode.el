;;; c-cc-mode.el --- cc-mode configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'cc-mode))

(use-package cc-mode
  ;; :after (company company-c-headers helm)
  :mode (("\\.c\\'" . c-mode)
         ("\\.cc\\'" . c++-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.tpp\\'" . c++-mode))
  :hook ((c-mode-common . (lambda ()
                            (add-hook 'before-save-hook 'clang-format-buffer nil t)))
         ;; (c-mode-common . (lambda ()
         ;;                    (set (make-local-variable 'company-backends)
         ;;                         (list '(company-c-headers company-rtags company-files)))))
         )
  :config
  (setq tab-width 8)
  (setq c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "linux"))))

(provide 'c-cc-mode)

;;; c-cc-mode.el ends here
