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

;; https://github.com/vedang/pdf-tools/issues/88#issuecomment-1179708765
(defun mh-pdf-view-mode-reload ()
  (when (equal major-mode 'pdf-view-mode)
    (pdf-view-mode)))

(defun mh/pdf-view-scroll-down ()
  "Scroll down in pdf-view mode.
This accounts for issues in which a PDF page is fitted to
slightly larger than thewindow size in which case you may want to
scroll to the next page but calling
`pdf-view-next-line-or-next-page' scrolls down a negligible
amount."
  (interactive)
  (if (or (eq pdf-view-display-size 'fit-page)
          (eq pdf-view-display-size 'fit-height))
      (pdf-view-next-page)
    (pdf-view-next-line-or-next-page 1)))

(defun mh/pdf-view-scroll-up ()
  "Scroll up in pdf-view mode.
The same as `mh/pdf-view-scroll-down' but for scrolling up."
  (interactive)
  (if (or (eq pdf-view-display-size 'fit-page)
          (eq pdf-view-display-size 'fit-height))
      (pdf-view-previous-page)
    (pdf-view-previous-line-or-previous-page 1)))

(add-hook 'clone-indirect-buffer-hook 'mh-pdf-view-mode-reload)

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

(defun mh/extract-pdf-pages ()
  "Extract a range of pages from a PDF file using qpdf.
Interactively prompts for input file, output file, and page
range.  Function written by Claude AI."
  (interactive)
  (let* ((default-input (when (buffer-file-name)
                          (expand-file-name (buffer-file-name))))
         ;; Prompt for input file
         (input-file
          (if (fboundp 'helm-find-files)
              (helm-read-file-name "Input PDF file: "
                                   :initial-input default-input
                                   :must-match t)
            (read-file-name "Input PDF file: "
                            nil default-input t
                            default-input)))
         ;; Verify input file exists and is a PDF
         (_ (unless (file-exists-p input-file)
              (error "Input file does not exist: %s" input-file)))
         (_ (unless (string-match-p "\\.pdf\\'" (downcase input-file))
              (when (not (yes-or-no-p "Input file doesn't have .pdf extension. Continue? "))
                (error "Aborted"))))
         ;; Prompt for output file
         (output-file
          (if (fboundp 'helm-find-files)
              (helm-read-file-name "Output PDF file: "
                                   :initial-input (concat (file-name-sans-extension input-file)
                                                          "-extract.pdf")
                                   :must-match nil)
            (read-file-name "Output PDF file: "
                            nil
                            (concat (file-name-sans-extension input-file)
                                    "-extract.pdf")
                            nil)))
         ;; Prompt for page range
         (page-range (read-string "Page range (e.g., 1-5 or 1,3,5-7): "))
         ;; Build the command
         (cmd (format "qpdf --empty --pages %s %s -- %s"
                      (shell-quote-argument input-file)
                      page-range
                      (shell-quote-argument output-file))))
    ;; Execute the command
    (message "Executing: %s" cmd)
    (let ((result (shell-command-to-string cmd)))
      (if (= 0 (call-process-shell-command cmd))
          (progn
            (message "Successfully extracted pages %s from %s to %s"
                     page-range
                     (file-name-nondirectory input-file)
                     (file-name-nondirectory output-file))
            ;; Optionally open the output file
            (when (yes-or-no-p "Open the extracted PDF? ")
              (find-file output-file)))
        (error "Failed to extract pages: %s" result)))))

(defun mh/extract-pdf-pages-to-tmp ()
  "Extract a range of pages from a PDF file using qpdf.
Writes output file to /tmp/tmp.pdf.  Prompts for page range.  Adapted
from function written by Claude AI."
  (interactive)
  (let* ((input-file (when (buffer-file-name)
                       (expand-file-name (buffer-file-name))))
         ;; Prompt for output file
         (output-file "/tmp/tmp.pdf")
         ;; Prompt for page range
         (page-range (read-string "Page range (e.g., 1-5 or 1,3,5-7): "))
         ;; Build the command
         (cmd (format "qpdf --empty --pages %s %s -- %s"
                      (shell-quote-argument input-file)
                      page-range
                      (shell-quote-argument output-file))))
    ;; Execute the command
    (message "Executing: %s" cmd)
    (let ((result (shell-command-to-string cmd)))
      (if (= 0 (call-process-shell-command cmd))
          (progn
            (message "Successfully extracted pages %s from %s to %s"
                     page-range
                     (file-name-nondirectory input-file)
                     (file-name-nondirectory output-file)))
        (error "Failed to extract pages: %s" result)))))

;;-- Functions that collectively split PDF by chapters.

(defun pdf-split--sanitize-filename (name)
  "Turn NAME into a filesystem-safe string."
  (let* ((s (replace-regexp-in-string "[/:*?\"<>|\\\\]" "_" name))
         (s (replace-regexp-in-string "\\`[. ]+" "" s))
         (s (replace-regexp-in-string "[. ]+\\'" "" s))
         (s (string-trim s))
         (s (replace-regexp-in-string "  +" " " s))
         (s (replace-regexp-in-string " " "_" s))
         (s (replace-regexp-in-string "__+" "_" s)))
    (if (string-empty-p s) "untitled" (substring s 0 (min (length s) 120)))))

(defun pdf-split--extract-outlines (json-data max-level)
  "Return outlines from qpdf JSON-DATA up to MAX-LEVEL depth.
MAX-LEVEL 0 means all levels, 1 means top-level only, etc.
Each element is (TITLE . PAGE-NUMBER) with 1-indexed pages,
sorted by page number.

Tries the top-level `outlines' tree first (which preserves
hierarchy).  Falls back to the flat per-page outline lists
when the top-level key is absent (all outlines treated as
level 1)."
  (let ((top-outlines (alist-get 'outlines json-data)))
    (if top-outlines
        ;; ---- hierarchical tree from top-level outlines ----
        (let (result)
          (cl-labels
              ((walk (entries depth)
                     (cl-loop
                      for e across entries
                      for title = (alist-get 'title e)
                      for page  = (or (alist-get 'destpageposfrom1 e)
                                      (let ((dp (alist-get 'destpage e)))
                                        (and (numberp dp) (1+ dp))))
                      do (when (and title page
                                    (or (zerop max-level)
                                        (<= depth max-level)))
                           (push (cons title page) result))
                      do (let ((kids (alist-get 'kids e)))
                           (when (and kids (> (length kids) 0)
                                      (or (zerop max-level)
                                          (< depth max-level)))
                             (walk kids (1+ depth)))))))
            (walk (if (vectorp top-outlines) top-outlines
                    (vconcat top-outlines))
                  1))
          (sort (nreverse result)
                (lambda (a b) (< (cdr a) (cdr b)))))
      ;; ---- fallback: flat per-page outlines (no hierarchy) ----
      (let ((pages (append (alist-get 'pages json-data) nil)))
        (sort
         (cl-loop for pg in pages
                  for pagepos = (alist-get 'pageposfrom1 pg)
                  nconc (cl-loop for o across (alist-get 'outlines pg)
                                 for title = (alist-get 'title o)
                                 when title
                                 collect (cons title pagepos)))
         (lambda (a b) (< (cdr a) (cdr b))))))))

(defun pdf-split--page-count (json-data)
  "Return total number of pages from qpdf JSON-DATA."
  (length (alist-get 'pages json-data)))

;;;###autoload
(defun mh/pdf-split-by-chapters (pdf-file output-dir &optional max-level)
  "Split PDF-FILE into per-chapter files using its bookmark outline.

Uses qpdf to read the document's outline (bookmarks) and writes one
PDF per bookmark entry into OUTPUT-DIR.

MAX-LEVEL controls how deep into the outline hierarchy to split:
  0 = all levels (default)
  1 = top-level bookmarks only
  2 = top-level and one level of sub-bookmarks
  ...and so on.

When called interactively, prompts for PDF-FILE (defaulting to the
current buffer's file), OUTPUT-DIR (creating it if it does not
exist), and MAX-LEVEL (with a prefix argument, otherwise 1)."
  (interactive
   (let* ((default (buffer-file-name))
          (file (read-file-name "PDF file: "
                                (and default (file-name-directory default))
                                default t
                                (and default (file-name-nondirectory default))))
          (dir (read-directory-name "Output directory: "
                                    (file-name-directory file)))
          (level (read-number "Max outline level (0 = all): " 1)))
     (list file dir level)))

  (setq max-level (or max-level 0))

  ;; ---- pre-flight checks ----
  (unless (executable-find "qpdf")
    (error "`qpdf' is not installed or not on PATH"))
  (setq pdf-file  (expand-file-name pdf-file)
        output-dir (file-name-as-directory (expand-file-name output-dir)))
  (unless (file-readable-p pdf-file)
    (error "Cannot read %s" pdf-file))
  (unless (file-directory-p output-dir)
    (make-directory output-dir t)
    (message "Created %s" output-dir))

  ;; ---- read outline via qpdf --json ----
  (message "Reading PDF structure with qpdf...")
  (let* ((json-string
          (with-output-to-string
            (with-current-buffer standard-output
              (let ((exit-code (call-process "qpdf" nil '(t nil) nil
                                             "--json=1"
                                             "--json-key=pages"
                                             "--json-key=outlines"
                                             pdf-file)))
                (unless (memq exit-code '(0 3))
                  (error "qpdf --json failed (exit %d); see output:\n%s"
                         exit-code (buffer-string)))))))
         (json-data
          (condition-case err
              (json-read-from-string json-string)
            (error (error "Cannot parse qpdf JSON: %s"
                          (error-message-string err)))))
         (outlines    (pdf-split--extract-outlines json-data max-level))
         (total-pages (pdf-split--page-count json-data))
         (n           (length outlines)))

    (when (zerop total-pages)
      (error "qpdf reports 0 pages in %s" (file-name-nondirectory pdf-file)))
    (unless outlines
      (error "No bookmarks found in %s" (file-name-nondirectory pdf-file)))
    (message "Found %d bookmark(s) (max-level %s), %d pages"
             n (if (zerop max-level) "all" max-level) total-pages)

    ;; ---- build (INDEX TITLE START END FILENAME) per chapter ----
    (let* ((width (length (number-to-string n)))
           (chapters
            (cl-loop
             for i from 0 below n
             for (title . start) = (nth i outlines)
             for end = (if (< i (1- n))
                           (max start (1- (cdr (nth (1+ i) outlines))))
                         total-pages)
             for idx   = (1+ i)
             for fname = (format (format "%%0%dd_%%s.pdf" width)
                                 idx
                                 (pdf-split--sanitize-filename title))
             collect (list idx title start end fname)))
           (successes 0)
           (failures  0))

      ;; ---- extract each chapter ----
      (dolist (ch chapters)
        (cl-destructuring-bind (idx title start end fname) ch
          (let* ((out-path   (expand-file-name fname output-dir))
                 (page-range (if (= start end)
                                 (number-to-string start)
                               (format "%d-%d" start end)))
                 (exit-code
                  (call-process "qpdf" nil "*qpdf-split-log*" nil
                                "--empty"
                                "--pages" pdf-file page-range "--"
                                out-path)))
            (if (memq exit-code '(0 3))
                (progn (cl-incf successes)
                       (message "[%d/%d] %s" idx n title))
              (cl-incf failures)
              (message "[%d/%d] FAILED: %s" idx n title)))))

      ;; ---- results buffer ----
      (let ((buf (get-buffer-create "*PDF Split Results*")))
        (with-current-buffer buf
          (let ((inhibit-read-only t))
            (erase-buffer)
            (insert (propertize "PDF Split by Chapters\n" 'face 'bold)
                    (make-string 50 ?─) "\n\n"
                    (format "Source:    %s\n" pdf-file)
                    (format "Output:    %s\n" output-dir)
                    (format "Pages:     %d\n" total-pages)
                    (format "Bookmarks: %d\n" n)
                    (format "Max level: %s\n\n"
                            (if (zerop max-level) "all" max-level)))
            (insert (propertize
                     (format "  %3s  %-52s  %10s  %s\n"
                             "#" "Title" "Pages" "File")
                     'face 'bold))
            (insert "  " (make-string 100 ?·) "\n")
            (dolist (ch chapters)
              (cl-destructuring-bind (idx title start end fname) ch
                (let ((range (if (= start end)
                                 (format "%d" start)
                               (format "%d-%d" start end)))
                      (npg   (1+ (- end start))))
                  (insert (format "  %3d  %-52s  %4s (%2dp)  %s\n"
                                  idx
                                  (truncate-string-to-width title 52 nil nil t)
                                  range npg fname)))))
            (insert "\n")
            (if (zerop failures)
                (insert (format "All %d chapters extracted successfully.\n" successes))
              (insert (format "%d/%d succeeded, " successes n))
              (insert (propertize
                       (format "%d failed" failures)
                       'face 'error))
              (insert " — see *qpdf-split-log* for details.\n")))
          (goto-char (point-min))
          (special-mode))
        (display-buffer buf))
      (message "Done — %d chapter(s) extracted to %s" successes output-dir))))

(provide 'c-pdf-tools)

;;; c-pdf-tools.el ends here
