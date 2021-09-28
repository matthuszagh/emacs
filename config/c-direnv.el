;;; c-direnv.el --- direnv package configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'direnv))

(require 'direnv)

(direnv-mode)
;; Inhibits the summary unless an update-environment call is made. The
;; summary is annoying because it shifts the buffer contents. This
;; does not stop direnv updating the environment.
(setq direnv-always-show-summary nil)

(provide 'c-direnv)

;;; c-direnv.el ends here
