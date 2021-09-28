;;; c-ol.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'ol)

(setq org-link-frame-setup '((vm . vm-visit-folder-other-frame)
                             (vm-imap . vm-visit-imap-folder-other-frame)
                             (gnus . org-gnus-no-new-news)
                             (file . find-file-other-window)
                             (wl . wl-other-frame)))

(provide 'c-ol)
;;; c-ol.el ends here
