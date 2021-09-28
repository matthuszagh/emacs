;;; c-clang-format.el --- clang-format configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'clang-format))

(use-package clang-format
  :after (s)
  :init
  (defun get-clang-format-option (config-str field is-num)
    "Retrieve a config option from a clang-format config.
CONFIG-STR is a string containing the entire clang-format config.
FIELD is specific option, e.g. `IndentWidth'.  IS-NUM is a
boolean that should be set to 1 if the option is numeric,
otherwise assumed alphabetic."
    (if is-num
        (let ((primary-match (s-match (concat "^[ \t]*" field ":[ \t]*[0-9]+") config-str)))
          (if primary-match
              (string-to-number (car (s-match "[0-9]+" (car primary-match))))
            0))
      (let ((primary-match (s-match (concat "^[ \t]*" field ":[ \t]*[A-Za-z]+") config-str)))
        (if primary-match
            (car (s-match "[A-Za-z]+$" (car primary-match)))
          ""))))
  ;; TODO this leaves many settings unset. Look at
  ;; `c-offsets-alist', particularly in C++ for finer-tuned options.
  :hook (c-mode-common . (lambda ()
                           (let* ((clang-format-config
                                   (shell-command-to-string "clang-format -dump-config"))
                                  (c-offset (get-clang-format-option clang-format-config "IndentWidth" t))
                                  (tabs-str (get-clang-format-option clang-format-config "UseTab" nil))
                                  (indent-braces (get-clang-format-option
                                                  clang-format-config "IndentBraces" nil))
                                  (base-style
                                   (get-clang-format-option clang-format-config "BasedOnStyle" nil)))
                             (progn
                               (if (> c-offset 0)
                                   (setq-local c-basic-offset c-offset)
                                 (if (not (equal "" base-style))
                                     (cond ((or (equal "LLVM" base-style)
                                                (equal "Google" base-style)
                                                (equal "Chromium" base-style)
                                                (equal "Mozilla" base-style)
                                                (equal "GNU" base-style))
                                            (setq-local c-basic-offset 2))
                                           ((equal "WebKit" base-style)
                                            (setq-local c-basic-offset 4)))))
                               (if (not (equal "" tabs-str))
                                   (if (not (string-equal "Never" tabs-str))
                                       (setq-local indent-tabs-mode t)
                                     (setq-local indent-tabs-mode nil))
                                 (if (not (equal "" base-style))
                                     (cond ((or (equal "LLVM" base-style)
                                                (equal "Google" base-style)
                                                (equal "Chromium" base-style)
                                                (equal "Mozilla" base-style)
                                                (equal "WebKit" base-style)
                                                (equal "GNU" base-style))
                                            (setq-local indent-tabs-mode nil)))))
                               (if (not (equal "" indent-braces))
                                   (if (equal "true" indent-braces)
                                       (c-set-style "gnu")
                                     (c-set-style "linux"))
                                 (if (not (equal "" base-style))
                                     (cond ((or (equal "LLVM" base-style)
                                                (equal "Google" base-style)
                                                (equal "Chromium" base-style)
                                                (equal "Mozilla" base-style)
                                                (equal "WebKit" base-style))
                                            (progn
                                              (c-set-style "linux")
                                              (add-to-list 'c-offsets-alist '(substatement . 0))))
                                           ((equal "GNU" base-style)
                                            (c-set-style "gnu"))))))))))


;; asy-mode inherits from c-mode-common so we must disable clang
;; formatting.
(with-eval-after-load 'asy-mode
  (add-hook 'asy-mode-hook
            (lambda ()
              (remove-hook 'before-save-hook 'clang-format-buffer t))))

(provide 'c-clang-format)

;;; c-clang-format.el ends here
