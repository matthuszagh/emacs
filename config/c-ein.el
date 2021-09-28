;;; c-ein.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'ein))

(require 'ein)

(setq ein:output-area-inlined-images t)
(setq my-jupyter-start-dir "~/.jupyter")
(setq ein:jupyter-server-notebook-directory "~/.jupyter/")

(provide 'c-ein)
;;; c-ein.el ends here
