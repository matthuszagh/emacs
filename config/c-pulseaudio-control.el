;;; c-pulseaudio-control.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'pulseaudio-control))

(require 'pulseaudio-control)

(provide 'c-pulseaudio-control)
;;; c-pulseaudio-control.el ends here
