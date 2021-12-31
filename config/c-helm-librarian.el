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

;; TODO this should be located somewhere else, since it doesn't
;; actually relate to helm-librarian.
(defun mh/librarian-catalog-entry ()
  "Navigate to the catalog entry for a given resource."
  (interactive)
  (let ((filename (buffer-name))
        (catalog-file (concat librarian-library-directory "/catalog.json")))
    (find-file-other-window catalog-file)
    (goto-char 0)
    (search-forward filename)))

(defun mh/librarian-update-catalog ()
  "Update librarian catalog."
  (interactive)
  (start-process-shell-command "librarian-catalog"
                               "*librarian-catalog*"
                               (concat librarian-executable
                                       " -d " librarian-library-directory
                                       " catalog")))

(provide 'c-helm-librarian)

;;; c-helm-librarian.el ends here
