;;; c-erc.el --- ERC Configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'erc))

(use-package erc
  :hook (erc-mode . (lambda ()
                      (setq-local fill-column nil)))
  :config
  (setq erc-prompt-for-password nil)
  (setq erc-nick "matthuszagh")
  ;; allow notifications
  (add-to-list 'erc-modules 'notifications)
  (defun mh/erc-freenode-connect ()
    (interactive)
    (erc :server "irc.freenode.net" :port 6667 :nick "matthuszagh"))

  (defun mh/erc-bitlebee-connect ()
    (interactive)
    (erc :server "localhost" :port 6667 :nick "matthuszagh")))

(provide 'c-erc)

;;; c-erc.el ends here
