;;; c-prog-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'prog-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook (lambda ()
                            ;; Highlighting in cmake-mode this way interferes with
                            ;; cmake-font-lock, which is something I don't yet understand.
                            (when (not (derived-mode-p 'cmake-mode))
                              (font-lock-add-keywords
                               nil
                               '(("\\<\\(FIXME\\|TODO\\|BUG\\|DONE\\)"
                                  1 font-lock-warning-face t))))))
(add-hook 'prog-mode-hook (lambda () (auto-fill-mode -1)))

(provide 'c-prog-mode)
;;; c-prog-mode.el ends here
