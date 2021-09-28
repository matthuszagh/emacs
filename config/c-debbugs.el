;;; c-debbugs.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'debbugs))

(require 'debbugs)

(provide 'c-debbugs)
;;; c-debbugs.el ends here
