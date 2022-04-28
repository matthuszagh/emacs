;;; c-helm-librarian-recoll.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(helm-librarian-recoll
                            :local-repo "helm-librarian-recoll")))

(require 'helm-librarian-recoll)

(provide 'c-helm-librarian-recoll)
;;; c-helm-librarian-recoll.el ends here
