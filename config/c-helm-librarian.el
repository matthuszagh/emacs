;;; c-helm-librarian.el --- helm-librarian configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package '(helm-librarian
                            :host github
                            :repo "matthuszagh/helm-librarian")))

(require 'helm-librarian)

(setq librarian-executable "~/src/librarian/target/release/librarian")
(setq librarian-library-directory "~/doc/library")

(provide 'c-helm-librarian)

;;; c-helm-librarian.el ends here
