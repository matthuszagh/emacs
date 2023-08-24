;;; c-tzc.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(tzc
                            :host github
                            :repo "md-arif-shaikh/tzc")))

(custom-set-variables
 '(tzc-main-dir "/etc/zoneinfo/"))

(require 'tzc)

(provide 'c-tzc)
;;; c-tzc.el ends here
