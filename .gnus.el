;;; gnus --- Summary

;;; Commentary:

;;; Code:
;; -*-no-byte-compile: t; -*-

;; Save email locally.
(require 'gnus)

(custom-set-variables
 '(user-mail-address "huszaghmatt@gmail.com")
 '(user-full-name "Matt Huszagh")
 '(gnus-select-method '(nnimap "inbox"
                               (nnimap-address "localhost")
                               (nnimap-stream network)
                               (nnimap-authenticator nil)
                               (nniri-search-engine imap)))

 ;; ;; '(nnmail-split-fancy
 ;; ;;   '(| (any "linux-kernel@vger\\.kernel\\.org" "LKML")
 ;; ;;       (any "emacs-devel@gnu\\.org" "emacs-devel")
 ;; ;;       (any "kicad-developers@lists\\.launchpad\\.net" "kicad-developers")
 ;; ;;       (any "emacs-orgmode@gnu\\.org" "emacs-orgmode")
 ;; ;;       "mail.misc"))
 ;; ;; '(nnmail-split-methods 'nnmail-split-fancy)
 ;; '(gnus-secondary-select-methods '((nnml "")))
 ;; '(message-send-mail-function 'smtpmail-send-it)
 ;; '(smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)))
 ;; '(smtpmail-auth-credentials '("smtp.gmail.com" 587 user-email-address nil))
 ;; '(smtpmail-default-smtp-server "smtp.gmail.com")
 ;; '(smtpmail-smtp-server "smtp.gmail.com")
 ;; '(smtpmail-smtp-service 587)
 ;; '(starttls-use-gnutls t)
 ;; ;; make Gnus NOT ignore [Gmail] mailboxes
 ;; '(gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
 ;; ;; replace [ and ] with _ in ADAPT file names
 ;; '(nnheader-file-name-translation-alist '((?[ . ?_) (?] . ?_)))
 )

;; (setq gnus-select-method
;;       '(nnimap "imap.gmail.com"
;;                (nnimap-inbox "INBOX")
;;                (nnimap-split-methods "default")
;;                (nnimap-stream ssl)
;;                (nnimap-server-port 993)))

(provide '.gnus)
;;; .gnus.el ends here
