;;; c-org-ref.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'pdf-tools)
  (mh:log-init "ERROR" "attempted to load 'org-ref before dependency 'pdf-tools"))

(if (featurep 'straight)
    (straight-use-package 'org-ref))

(require 'org-ref)
(setq org-ref-default-bibliography "~/doc/notes/wiki/library.bib")
(setq org-ref-bibliography-files '("~/doc/notes/wiki/library.bib"))

(defun mh/org-ref-update-ref-at-point ()
  "Update the 7 character identifier at point as well as all
references and definitions of it in the current file."
  (interactive)
  (let* ((len 7)
         (old-id (word-at-point))
         (new-id (mh//rand-hex-string len)))
    ;; Ensure identifier is valid. This means it should only consist
    ;; of characters a-f or digits 0-9 and be of length 7.
    (if (not (and (eq (length old-id) len)
                  (not (string-match-p "[^a-f0-9]" old-id))))
        (error "Invalid reference at point")
      (save-excursion
        (replace-string old-id new-id nil (point-min) (point-max))))))

(provide 'c-org-ref)
;;; c-org-ref.el ends here
