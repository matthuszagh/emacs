;;; c-json-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'json-mode))

(require 'json-mode)

(provide 'c-json-mode)
;;; c-json-mode.el ends here
