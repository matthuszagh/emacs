;;; c-git-timemachine.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'git-timemachine))

(require 'git-timemachine)

(provide 'c-git-timemachine)
;;; c-git-timemachine.el ends here
