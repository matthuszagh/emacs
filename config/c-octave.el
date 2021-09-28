;;; c-octave.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package octave
  :mode ("\\.m\\'" . octave-mode)
  :hook (inferior-octave-mode . (lambda ()
                                  (setq-local fill-column nil)))
  :config
  (add-to-list 'same-window-buffer-names "*Inferior Octave*"))

(provide 'c-octave)
;;; c-octave.el ends here
