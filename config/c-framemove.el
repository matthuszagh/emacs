;;; c-framemove.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'framemove))

(require 'framemove)

(windmove-default-keybindings)
(setq framemove-hook-into-windmove t)

(provide 'c-framemove)
;;; c-framemove.el ends here
