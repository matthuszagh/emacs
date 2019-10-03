;;; python-layer.el -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Code:

(layer-def python
  :setup
  (use-package python
    :mode (("\\.py\\'" . python-mode))
    :hook ((python-mode . (lambda ()
                            (setq tab-width 4)
                            (highlight-indentation-mode 0))))
    :config
    (setq-default python-indent 4)
    (setq-default python-indent-offset 4)
    (setq-default pdb-command-name "python -m ipdb")
    ;; Use ipython as the python shell interpreter.
    ;; (setq python-shell-interpreter "ipython3")
    ;; (setq python-shell-interpreter-args "console --simple-prompt")
    (setq python-shell-interpreter "python")
    (setq python-shell-interpreter-args "")
    (setq python-shell-prompt-detect-failure-warning nil)
    (add-to-list 'same-window-buffer-names "*Python*")
    ;; (setq python-shell-interpreter "jupyter"
    ;;       python-shell-interpreter-args "console --simple-prompt"
    ;;       python-shell-prompt-detect-failure-warning nil)
    ;; ;; TODO why is this disabled?
    ;; (add-to-list 'python-shell-completion-native-disabled-interpreters
    ;;              "jupyter")
    )

  ;; (use-package elpy
  ;;   :hook (python-mode . elpy-mode)
  ;;   :config
  ;;   (elpy-enable)
  ;;   (setq elpy-rpc-backend "jedi")
  ;;   (setq elpy-shell-display-buffer-after-send t)
  ;;   (setq elpy-modules (delq 'elpy-module-highlight-indentation elpy-modules))
  ;;   (when (require 'flycheck nil t)
  ;;     (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  ;;     (setq flycheck-python-pylint-executable "pylint")
  ;;     (add-hook 'elpy-mode-hook 'flycheck-mode)))

  ;; (use-package py-autopep8
  ;;   :hook (elpy-mode . py-autopep8-enable-on-save))

  ;; (use-package yapfify
  ;;   :hook (python-mode . yapf-mode))

  (use-package blacken
    :hook (python-mode . blacken-mode)
    :config
    (setq blacken-line-length 79))

  :postsetup
  (:layer debugging
   (localleader :keymaps 'python-mode-map
     "d" 'realgud:pdb)))

;;; python-layer.el ends here