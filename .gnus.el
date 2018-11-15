;;; gnus --- Summary

;;; Commentary:


;;; Code:

;; Save email locally.
(require 'gnus)
(setq nnml-directory "~/gmail")
(setq message-directory "~/gmail")

;;; Personal settings
(setq user-mail-address "huszaghmatt@gmail.com"
      mail-host-address "gmail.com"
      user-full-name "Matt Huszagh"
      my-news-server "news.gmane.org"
      my-imap-server "imap.gmail.com"
      my-smtp-server "smtp.gmail.com"
      )

;;; Primary news server
(setq gnus-select-method `(nntp ,my-news-server))

;;; Secondary (email)
(setq gnus-secondary-select-methods
      `(
        (nnimap "gmail"
                (nnimap-address ,my-imap-server)
                (nnimap-server-port 993)
                (nnimap-stream ssl)
                (nnimap-inbox "INBOX")
                (nnimap-split-methods default))
        ))

;; Make Gnus NOT ignore [Gmail] mailboxes
(setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

;; Replace [ and ] with _ in ADAPT file names
(setq nnheader-file-name-translation-alist '((?[ . ?_) (?] . ?_)) )

;;; Outbound email
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587 "huszaghmatt@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      starttls-use-gnutls t)

;;; Save sent mail
(setq gnus-message-archive-group "nnimap+gmail:Sent")

;;; Look up email addresses in LDAP
(eval-after-load "message"
  '(define-key message-mode-map (kbd "TAB") 'eudc-expand-inline))
(setq eudc-ldap-attributes-translation-alist '((lastname . sn)
					       (firstname . givenname)
					       (email . mail)
					       (phone . telephonenumber)
					       (nickname . rhatknownas)))
(setq eudc-inline-query-format '((nickname) (firstname) (lastname) (firstname lastname)))
(setq eudc-inline-expansion-format '("%s <%s>" cn email))

;;; Check mail backends automatically
(gnus-demon-add-scanmail)

;;; Use adaptive scoring
(setq gnus-use-adaptive-scoring t)

(provide '.gnus)
;;; .gnus.el ends here
