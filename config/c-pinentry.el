;;; c-pinentry.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'pinentry))

(require 'pinentry)
;; prompt gpg passphrase in minibuffer instead of in new window.
(setq epg-pinentry-mode 'loopback)

(provide 'c-pinentry)
;;; c-pinentry.el ends here
