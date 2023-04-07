;;; c-autoinsert.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'autoinsert)

(auto-insert-mode t)
(setq auto-insert-query nil)
(setq auto-insert-alist
      '((emacs-lisp-mode . (lambda ()
                             (if (equal (file-name-directory (buffer-file-name))
                                        (expand-file-name "~/.config/emacs/config/"))
                                 (let* ((fname (file-name-nondirectory (buffer-file-name)))
                                        (fname-no-extension (file-name-sans-extension fname)))
                                   (insert (concat
                                            ";;; " fname " ---  -*- lexical-binding: t; -*-\n"
                                            "\n"
                                            ";;; Commentary:\n"
                                            "\n"
                                            ";;; Code:\n"
                                            "\n"
                                            "(if (featurep 'straight)\n"
                                            "    (straight-use-package '" (substring fname-no-extension 2) "))\n"
                                            "\n"
                                            "(require '" (substring fname-no-extension 2) ")\n"
                                            "\n"
                                            "(provide '" fname-no-extension ")\n"
                                            ";;; " fname " ends here"))))))))

(provide 'c-autoinsert)
;;; c-autoinsert.el ends here
