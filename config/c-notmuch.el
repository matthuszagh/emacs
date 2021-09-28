;;; c-notmuch.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'notmuch))

(require 'notmuch)

(add-hook 'notmuch-show-mode-hook
          (lambda ()
            (setq-local visual-line-mode nil)))

;; setup the mail address and use name
(setq mail-user-agent 'message-user-agent)
(setq user-mail-address "huszaghmatt@gmail.com"
      user-full-name "Matt Huszagh")
;; smtp config
(setq smtpmail-smtp-server "smtp.gmail.com"
      message-send-mail-function 'message-smtpmail-send-it)
(setq smtpmail-smtp-service 587)

;; report problems with the smtp server
(setq smtpmail-debug-info t)
;; add Cc and Bcc headers to the message buffer
(setq message-default-mail-headers "Cc: \nBcc: \n")
;; postponed message is put in the following draft directory
(setq message-auto-save-directory "~/mail/draft")
(setq message-kill-buffer-on-exit t)
;; change the directory to store the sent mail
(setq message-directory "~/mail/")
;; display newest messages first
(setq notmuch-search-oldest-first nil)

(provide 'c-notmuch)
;;; c-notmuch.el ends here
