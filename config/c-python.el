;;; c-python.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; (use-package python
;;   :mode (("\\.py\\'" . python-mode))
;;   :hook ((python-mode . (lambda ()
;;                           (setq-local tab-width 4)
;;                           (highlight-indentation-mode 0))))
;;   :config
;;   (setq-default python-indent 4)
;;   (setq-default python-indent-offset 4)
;;   (setq-default pdb-command-name "python -m ipdb")
;;   (setq python-shell-interpreter "python")
;;   (setq python-shell-interpreter-args "")
;;   (setq python-shell-prompt-detect-failure-warning nil)
;;   (add-to-list 'same-window-buffer-names "*Python*"))

(provide 'c-python)
;;; c-python.el ends here
