;;; c-spice-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'spice-mode))

(require 'spice-mode)

(cl-pushnew '("\\.mod\\'" . spice-mode) auto-mode-alist)

(provide 'c-spice-mode)
;;; c-spice-mode.el ends here
