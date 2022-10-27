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

(defun mh/librarian-resource (filepath)
  "Get the librarian resource non-directory filename from FILEPATH,
which may be the resource itself, or a file in the resource's
directory."
  (string-match "\\([0-9a-f]\\{40\\}\\)" filepath)
  (match-string 1 filepath))

(defun mh/current-librarian-resource-filename ()
  "Filename for buffer visiting librarian resource."
  (mh/librarian-resource
   (if (eq major-mode 'eww-mode)
       (eww-current-url)
     (or (buffer-file-name)
         (buffer-name)))))

(defun mh/add-librarian-resource-filename-to-kill-ring ()
  "Add librarian resource filename to kill ring."
  (interactive)
  (kill-new (mh/current-librarian-resource-filename)))

;; TODO this should be located somewhere else, since it doesn't
;; actually relate to helm-librarian.
(defun mh/librarian-catalog-entry ()
  "Navigate to the catalog entry for a given resource."
  (interactive)
  (let ((resource (mh/current-librarian-resource-filename))
        (catalog-file (concat librarian-library-directory "/catalog.json")))
    (find-file-other-window catalog-file)
    (goto-char 0)
    (search-forward resource)
    (search-backward "{")))

(defun mh/librarian-entry-directory ()
  "Navigate to the directory for the entry currently visited.
This can be useful for getting to the actual files of a website
or similar."
  (interactive)
  (find-file (concat librarian-library-directory
                     "/resources/"
                     (mh/current-librarian-resource-filename))))

;; TODO use make-process and associate a sentinel to output a message
;; when updating complete.
(defun mh/librarian-update-catalog ()
  "Update librarian catalog."
  (interactive)
  ;; run in the home directory so we don't get any errors about
  ;; non-existant directories
  (let ((default-directory "~")
        (buffer-name "*librarian-catalog*"))
    ;; clear buffer
    (with-current-buffer (get-buffer-create buffer-name)
      (delete-region (point-min) (point-max)))
    ;; first backup catalog.json
    (call-process-shell-command (concat "mkdir -p "
                                        librarian-library-directory "/.backup && "
                                        "cp " librarian-library-directory "/catalog.json "
                                        librarian-library-directory
                                        "/.backup/$(date --utc --iso-8601=seconds)")
                                nil
                                buffer-name)
    ;; update catalog
    (call-process-shell-command (concat librarian-executable
                                        " -d " librarian-library-directory
                                        " catalog"
                                        " --remove-orphans='false'")
                                nil
                                buffer-name)
    ;; display a diff
    (call-process-shell-command (concat "diff -y --suppress-common-lines "
                                        librarian-library-directory "/.backup/"
                                        "$(ls " librarian-library-directory "/.backup | sort -r | head -1) "
                                        librarian-library-directory "/catalog.json")
                                nil
                                buffer-name))
  (message "'mh/librarian-update-catalog' complete"))

;; TODO see the todo for `mh/librarian-update-catalog'.
(defun mh/librarian-update-bibtex ()
  "Use librarian to regenerate the librarian.bib biblatex file."
  (interactive)
  (start-process-shell-command "librarian-bibtex"
                               "*librarian-bibtex*"
                               (concat "RUST_BACKTRACE=full "
                                       librarian-executable
                                       " -d " librarian-library-directory
                                       " bibtex ~/doc/notes/wiki/librarian.bib")))

(provide 'c-helm-librarian)

;;; c-helm-librarian.el ends here
