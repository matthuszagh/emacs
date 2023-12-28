;;; c-pdf-tools.el --- pdf-tools configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package pdf-tools
  :demand t
  :mode "\\.pdf\\'"
  :init
  ;; Only warn when opening files larger than 1GB. This is particularly useful for PDFs which are
  ;; often larger than the default threshold.
  (setq large-file-warning-threshold nil)
  :config
  (pdf-tools-install t)
  ;; fixes an issue in emacs 27 where pdf is blurry and too large otherwise.
  (setq image-scaling-factor 1)
  ;; do not limit max page/image size
  (setq pdf-view-max-image-width 100000)

  (setq-default pdf-view-display-size 'fit-page))

(custom-set-variables
 ;; disable line wrapping in PDF outlines
 '(pdf-outline-fill-column nil))

;; truncate long lines in pdf-outline
(add-hook 'pdf-outline-buffer-mode-hook
          (lambda ()
            (toggle-truncate-lines 1)))

(defun mh/pdf-rotate (dir)
  "Rotate PDF page in current buffer according to DIR.
This overwrites the current file."
  (interactive "MRotation direction (l|r|d): ")
  (if (null (executable-find "pdftk"))
      (error "Rotation requires pdftk")
    (if (not (eq major-mode 'pdf-view-mode))
        (error "Must be in pdf-view-mode")
      ;; translate direction into degrees and ensure valid argument given
      (let ((rotate (if (string-equal dir "l") 270
                      (if (string-equal dir "r") 90
                        (if (string-equal dir "d") 180
                          (error "Invalid rotation direction")))))
            (file (pdf-view-buffer-file-name))
            (page (pdf-view-current-page))
            (metadata-file (make-temp-file (temporary-file-directory)))
            (new-pdf (make-temp-file (temporary-file-directory))))
        ;; dump current metadata
        (shell-command-to-string (concat "pdftk "
                                         file " "
                                         "dump_data output "
                                         metadata-file))
        ;; find the current rotation and add the desired rotation
        (with-current-buffer (find-file metadata-file)
          (let ((base-match (concat "PageMediaNumber: " (number-to-string page) "\n"
                                    "PageMediaRotation: ")))
            (re-search-forward (concat base-match "\\([0-9]+\\)"))
            (let ((rotation (string-to-number (match-string-no-properties 1))))
              (replace-match (concat base-match (number-to-string (mod (+ rotation rotate)
                                                                       360))))))
          (save-buffer))
        ;; create new pdf with rotation applied, and then overwrite the original file
        (shell-command-to-string (concat "pdftk "
                                         file " "
                                         "update_info "
                                         metadata-file " "
                                         "output "
                                         new-pdf))
        (rename-file new-pdf file t)
        ;; reopen file
        (find-file file)
        ;; cleanup temporary files
        (kill-buffer (get-file-buffer metadata-file))
        (delete-file metadata-file)))))

(defun mh/pdf-remove-carriage-returns-from-bookmarks ()
  "Return all instances of carriage returns in the current PDF
bookmarks and then overwrite the PDF."
  (interactive)
  (if (null (executable-find "pdftk"))
      (error "Rotation requires pdftk")
    (if (not (eq major-mode 'pdf-view-mode))
        (error "Must be in pdf-view-mode")
      (let ((file (pdf-view-buffer-file-name))
            (metadata-file (make-temp-file (temporary-file-directory)))
            (new-pdf (make-temp-file (temporary-file-directory))))
        ;; dump current metadata
        (shell-command-to-string (concat "pdftk "
                                         file " "
                                         "dump_data output "
                                         metadata-file))
        ;; remove carriage return
        (with-current-buffer (find-file metadata-file)
          (while (search-forward "\r" nil t)
            (replace-match "" nil t))
          (save-buffer))
        ;; create new pdf with carriage returns removed, and then
        ;; overwrite the original file
        (shell-command-to-string (concat "pdftk "
                                         file " "
                                         "update_info "
                                         metadata-file " "
                                         "output "
                                         new-pdf))
        (rename-file new-pdf file t)
        ;; reopen file
        (find-file file)
        ;; cleanup temporary files
        (kill-buffer (get-file-buffer metadata-file))
        (delete-file metadata-file)))))

(defun mh/pdf-outline-to-k2pdfopt-input ()
  "Take an existing PDF outline and generate an equivalent input in the format expected by k2pdfopt.
The outline display uses a line for each outline entry. The page
number is displayed at the end of the line in parentheses. The
line has two spaces at the beginning for each sublevel. For example:

RF Digital Troubleshooting (63)
Removal & Replacement (67)
  RF Section Fuses (67)
  Coax Switch & BPF (68)

The k2pdfopt input places the page number at the beginning of the
line after all + symbols and uses a + for each sublevel (no + for
top level). For example:

63 RF Digital Troubleshooting
67 Removal & Replacement
+67 RF Section Fuses
+68 Coax Switch & BPF

Therefore, we should replace every consecutive 2 spaces by a '+'
and then move the page number to after the pluses.
"
  (interactive)
  (let* ((outline-buffer (buffer-name))
         (buffer-sha (buffer-hash))
         (k2pdfopt-buffer (get-buffer-create "*outline k2pdfopt*")))
    (with-current-buffer k2pdfopt-buffer
      (delete-region (point-min) (point-max)))
    (with-current-buffer outline-buffer
      (copy-to-buffer k2pdfopt-buffer (point-min) (point-max)))
    (with-current-buffer k2pdfopt-buffer
      (goto-char (point-min))
      ;; Replace all double spaces not at the beginning of the current
      ;; line with single spaces.
      (while (re-search-forward "\\(.\\)  " nil t)
        (replace-match (concat (match-string-no-properties 1) " ")))
      (goto-char (point-min))
      ;; Replace all remaining 2 spaces with '+' symbol.
      (while (search-forward "  " nil t)
        (replace-match "+" nil t))
      ;; Move page number to after + symbols.
      (goto-char (point-min))
      (while (re-search-forward " (\\([0-9]+\\))" nil t)
        (let ((page-number (match-string-no-properties 1)))
          (replace-match "")
          (beginning-of-line)
          (re-search-forward "\\(\\+*\\)" (line-end-position) t)
          (replace-match (concat (match-string-no-properties 1)
                                 page-number
                                 " ")))))))

;; Taken from https://github.com/noctuid/evil-guide#example-integration-with-pdf-tools.
(defun mh:pdf-view-page-as-text ()
  "Inserts current pdf page into a buffer for keyboard selection."
  (interactive)
  (pdf-view-mark-whole-page)
  (pdf-view-kill-ring-save)
  (switch-to-buffer (make-temp-name "pdf-page"))
  (save-excursion
    (yank)))

(defun mh/pdf-view-actual-size ()
  "Display a PDF such that the dimensions match the physical size of an A4 paper.
TODO this should be extended to other paper sizes."
  (interactive)
  (let* ((current-width (car (pdf-view-image-size)))
         (a4-width-in (/ 210 25.4))
         (target-width (* a4-width-in (car (mh/dpi)))))
    (pdf-view-enlarge (/ target-width current-width))))


(defun mh/ocr-current-buffer-pdf ()
  "OCR PDF in current buffer."
  (interactive)
  (let ((path (buffer-file-name)))
    (start-process-shell-command
     "ocr-pdf"
     "*ocrmypdf*"
     (concat "ocrmypdf -s --max-image-mpixels=1000000000 "
             path " " path))))

(defun mh/ocr-current-buffer-pdf (redo-ocr)
  "OCR PDF in current buffer."
  (interactive
   (list (read-string "Redo OCR? (y/n, default n): " nil nil "n")))
  (let* ((path (buffer-file-name))
         (redo-ocr-flag (if (string-equal redo-ocr "y")
                            "--redo-ocr"
                          (if (string-equal redo-ocr "n")
                              "-s"
                            (error "Must answer 'y' or 'n' to redo OCR"))))
         (buffer "*ocrmypdf*")
         (cmd (concat "ocrmypdf " redo-ocr-flag " --max-image-mpixels=1000000000 "
                      "--output-type=pdf "
                      "'" path "' '" path "'")))
    (get-buffer-create buffer)
    (with-current-buffer buffer
      (erase-buffer)
      (insert (concat cmd "\n")))
    (start-process-shell-command "ocr-pdf" buffer cmd)))

(provide 'c-pdf-tools)

;;; c-pdf-tools.el ends here
