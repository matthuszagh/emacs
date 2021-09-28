;;; c-fish-completion.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'fish-completion))

(require 'fish-completion)

(global-fish-completion-mode)
(setq fish-completion-fallback-on-bash-p t)

(provide 'c-fish-completion)
;;; c-fish-completion.el ends here
