;;; c-csv-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'csv-mode))

(require 'csv-mode)

(add-hook 'csv-mode-hook 'csv-align-mode)
(add-hook 'csv-mode-hook '(lambda () (interactive) (toggle-truncate-lines nil)))

(provide 'c-csv-mode)
;;; c-csv-mode.el ends here
