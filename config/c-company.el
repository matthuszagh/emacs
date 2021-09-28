;;; c-company.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'company))

(require 'company)

;; show completions immediately
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 2)
(setq company-show-numbers t)
(global-company-mode)
;; Maintain case information for completions.
(setq company-dabbrev-downcase nil)
(setq company-dabbrev-ignore-case nil)
;; Default backends.
(setq company-backends '(company-files
                         company-keywords
                         company-capf
                         ;; company-dabbrev
                         company-dabbrev-code))

(if (featurep 'org)
    (add-hook 'org-mode-hook
              (lambda ()
                (company-mode 0)))
  (mh:log-init "ERROR" "company attempted to perform org configurations before loading 'org"))

(provide 'c-company)
;;; c-company.el ends here
