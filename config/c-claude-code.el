;;; c-claude-code.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package
     '(claude-code :type git :host github :repo "stevemolitor/claude-code.el"
                   :branch "main" :depth 1
                   :files ("*.el" (:exclude "images/*")))))

(require 'claude-code)

(custom-set-variables
 '(claude-code-terminal-backend 'vterm))

(claude-code-mode 1)

(provide 'c-claude-code)
;;; c-claude-code.el ends here
