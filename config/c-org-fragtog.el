;;; c-org-fragtog.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'org-fragtog))

(require 'org-fragtog)

(add-hook 'org-mode-hook 'org-fragtog-mode)

(provide 'c-org-fragtog)
;;; c-org-fragtog.el ends here
