;;; c-bash-completion.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'bash-completion))

(require 'bash-completion)
(bash-completion-setup)

(provide 'c-bash-completion)
;;; c-bash-completion.el ends here
