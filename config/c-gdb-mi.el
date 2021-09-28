;;; c-gdb-mi.el --- gdb-mi configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package gdb-mi
  :hook (gud-mode . (lambda ()
                      (set (make-local-variable 'company-backends) '(company-capf))))
  :config
  (add-to-list 'same-window-buffer-names "*gud.*")
  ;; Don't pop io buffer to top
  (setq gdb-display-io-nopopup t)
  ;; Show source buffer at startup
  (setq gdb-show-main t)
  ;; Force gdb-mi to not dedicate any windows. Dedicated windows prevent switching it for another window.
  (advice-add 'gdb-display-buffer
	      :around (lambda (orig-fun &rest r)
			(let ((window (apply orig-fun r)))
			  (set-window-dedicated-p window nil)
			  window)))

  (advice-add 'gdb-set-window-buffer
	      :around (lambda (orig-fun name &optional ignore-dedicated window)
			(funcall orig-fun name ignore-dedicated window)
			(set-window-dedicated-p window nil))))

(provide 'c-gdb-mi)

;;; c-gdb-mi.el ends here
