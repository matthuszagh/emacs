;;; c-tzc.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(tzc
                            :host github
                            :repo "md-arif-shaikh/tzc")))

(custom-set-variables
 `(tzc-main-dir (if (file-exists-p "/etc/zoneinfo/")
                    "/etc/zoneinfo/"
                  ;; Ubuntu location
                  "/usr/share/zoneinfo/")))

(require 'tzc)

(provide 'c-tzc)
;;; c-tzc.el ends here
