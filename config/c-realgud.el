;;; c-realgud.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'realgud))

(require 'realgud)

(setq realgud:pdb-command-name "python3 -m pdb")

(provide 'c-realgud)
;;; c-realgud.el ends here
