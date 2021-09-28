;;; c-async.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'async))

(require 'async)

(dired-async-mode 1)

(provide 'c-async)
;;; c-async.el ends here
