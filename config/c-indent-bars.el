;;; c-indent-bars.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(indent-bars :type git :host github :repo "jdtsmith/indent-bars")))

(require 'indent-bars)

(add-hook 'python-mode-hook 'indent-bars-mode)
(custom-set-variables
 '(indent-bars-width-frac 0.2)
 '(indent-bars-treesit-support t)
 '(indent-bars-no-descend-string t)
 '(indent-bars-treesit-ignore-blank-lines-types '("module"))
 '(indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
				      list list_comprehension
				      dictionary dictionary_comprehension
				      parenthesized_expression subscript))))

(provide 'c-indent-bars)
;;; c-indent-bars.el ends here
