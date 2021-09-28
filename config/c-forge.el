;;; c-forge.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'forge))

(require 'forge)
(add-hook 'forge-post-mode (lambda ()
                             (setq-local fill-column nil)))

(provide 'c-forge)
;;; c-forge.el ends here
