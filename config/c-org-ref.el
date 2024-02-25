;;; c-org-ref.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(unless (featurep 'pdf-tools)
  (mh:log-init "ERROR" "attempted to load 'org-ref before dependency 'pdf-tools"))

(if (featurep 'straight)
    (straight-use-package 'org-ref))

(require 'org-ref)

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

(defun mh/org-ref-label-equation-at-point ()
  "Add a reference/label to the equation at point."
  (interactive)
  (let ((id (mh//rand-hex-string 7))
        ;; don't go beyond the current latex src block
        (lim (save-excursion
               (search-forward "#+end_src")
               (point))))
    (save-excursion
      (let ((search-pt (re-search-forward "\\tag{[0-9a-z.]+}" lim t)))
        ;; if search succeeded, insert label and add reference to kill ring
        (if search-pt
            (progn
              (insert (concat "\\label{eq:" id "}"))
              (kill-new (concat "cref:eq:" id))))))))

(provide 'c-org-ref)
;;; c-org-ref.el ends here
