;;; gnus --- Summary

;;; Commentary:

;;; Code:
;; -*-no-byte-compile: t; -*-

;; Save email locally.
(require 'gnus)

(custom-set-variables
 '(user-mail-address "huszaghmatt@gmail.com")
 '(user-full-name "Matt Huszagh")
 '(message-send-mail-function 'smtpmail-send-it)
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 587)
 ;; '(gnus-select-method '(nnimap "inbox"
 ;;                               (nnimap-address "localhost")
 ;;                               (nnimap-stream network)
 ;;                               (nnimap-authenticator nil)
 ;;                               (nniri-search-engine imap)))
 '(gnus-select-method
   '(nnimap "gmail"
            (nnimap-address "imap.gmail.com")
            (nnimap-server-port 993)
            (nnimap-stream ssl)
            (nnir-search-engine imap)
            ;; @see
            ;; http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
            ;; press 'E' to expire email
            (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
            (nnmail-expiry-wait 90)))

 ;; ;; '(nnmail-split-fancy
 ;; ;;   '(| (any "linux-kernel@vger\\.kernel\\.org" "LKML")
 ;; ;;       (any "emacs-devel@gnu\\.org" "emacs-devel")
 ;; ;;       (any "kicad-developers@lists\\.launchpad\\.net" "kicad-developers")
 ;; ;;       (any "emacs-orgmode@gnu\\.org" "emacs-orgmode")
 ;; ;;       "mail.misc"))
 ;; ;; '(nnmail-split-methods 'nnmail-split-fancy)
 '(gnus-secondary-select-methods nil)
 ;; '(gnus-secondary-select-methods
 ;;   '((nnimap "gmail"
 ;;             (nnimap-address "imap.gmail.com")
 ;;             (nnimap-server-port 993)
 ;;             (nnimap-stream ssl)
 ;;             (nnir-search-engine imap)
 ;;             ;; @see
 ;;             ;; http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
 ;;             ;; press 'E' to expire email
 ;;             (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
 ;;             (nnmail-expiry-wait 90))))
 ;; ;; make Gnus NOT ignore [Gmail] mailboxes
 '(gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
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
