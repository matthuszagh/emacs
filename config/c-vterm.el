;;; c-vterm.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'vterm)

(setq vterm-shell "/run/current-system/sw/bin/bash")
(setq vterm-toggle-fullscreen-p nil)
;; increase max number of scrollback lines. TODO this apparently
;; only works up to 1e5 and must be modified in source. That is a
;; bad approach and should be modified upstream.
(setq vterm-max-scrollback (round 1e9))
;; kill vterm buffers when process terminated
(setq vterm-kill-buffer-on-exit t)
(add-to-list 'display-buffer-alist
             '("vterm"
               (display-buffer-reuse-window display-buffer-same-window)))

(provide 'c-vterm)
;;; c-vterm.el ends here
