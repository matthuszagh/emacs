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
(setq message-directory "~/mail")
;; display newest messages first
(setq notmuch-search-oldest-first nil)

(defun mh//outgoing-blacklist-check ()
  "Prevent sending mail to certain email addresses."
  (let ((email-list '())
        (to (or (message-field-value "To") ""))
        (cc (or (message-field-value "Cc") ""))
        (bcc (or (message-field-value "Bcc") "")))
    (dolist (email email-list)
      (if (or (string-match email to)
              (string-match email cc)
              (string-match email bcc))
          (progn
            (message (concat email " is blacklisted for outbound messages."
                             " Not sending."))
            (keyboard-quit))))))

(add-hook 'message-send-mail-hook #'mh//outgoing-blacklist-check)
;;(remove-hook 'message-send-mail-hook #'mh//outgoing-blacklist-check)

(defun mh//jonathan-levine-blacklist-check ()
  "Prevent sending emails to Jonathan Levine and Data I/O group simultaneously."
  (let ((jonathan-email "jonathan.canuck.levine@gmail.com")
        (dataio-group-email "DataioEPROM@groups.io")
        (to (or (message-field-value "To") ""))
        (cc (or (message-field-value "Cc") ""))
        (bcc (or (message-field-value "Bcc") "")))
    (if (and (or (string-match jonathan-email to)
                 (string-match jonathan-email cc)
                 (string-match jonathan-email bcc))
             (or (string-match dataio-group-email to)
                 (string-match dataio-group-email cc)
                 (string-match dataio-group-email bcc)))
        (progn
          (message "Don't email Jonathan and Data I/O group simultaneously.")
          (keyboard-quit)))))

(add-hook 'message-send-mail-hook #'mh//jonathan-levine-blacklist-check)
;;(remove-hook 'message-send-mail-hook #'mh//jonathan-levine-blacklist-check)

(defun mh//verify-email-send ()
  "Prompt for verification before sending an email."
  (or (yes-or-no-p "Are you sure reply-all is suitable? ")
      (keyboard-quit)))

(add-hook 'message-send-hook #'mh//verify-email-send)

(provide 'c-notmuch)
;;; c-notmuch.el ends here
