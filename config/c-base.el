;;; c-base.el ---   -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Increases the garbage collection threshold. Specifically, this
;; delays garbage collection until Emacs has allocated 100MB from
;; memory. Setting this value too low triggers garbage collection
;; frequently and adversely affects performance. Setting it too high
;; can deplete your available memory and slow down the entire
;; system.
(setq gc-cons-threshold 100000000)

;; LSP (and maybe other packages) need to read large amounts of data
;; at a time from subprocesses. The default setting is overly
;; restrictive.
(setq read-process-output-max (* 10 1024 1024)) ;; 10MB

;; Always start Emacs maximized.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Only show cursor in active window.
(setq-default cursor-in-non-selected-windows nil)
;; (add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; Disable toolbar.
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Disable menu-bar.
(menu-bar-mode -1)

;; Disable cursor blinking.
(blink-cursor-mode -1)

;; Draw the block cursor as wide as the glyph under it. This mostly
;; helps dileneate spaces from tabs.
(setq x-stretch-cursor t)

;; Automatically revert a file-backed buffer when the corresponding
;; file changes on disk.
(global-auto-revert-mode t)

;; Increase splitting threshold so that new buffers don't split
;; existing ones.  TODO improve documentation of this setting.
(setq split-height-threshold 100)

;; Disable startup screen.
(setq inhibit-startup-screen t)

;; Start scrolling when the cursor is within 5 lines of the buffer limit.
(setq scroll-margin 5)
;; When scrolling begins due to `scroll-margin', only scroll 1 line.
(setq scroll-conservatively 1)
;; Don't keep cursor position unchanged in buffer.
(setq scroll-preserve-screen-position nil)

;; Hide the scroll bar.
(scroll-bar-mode -1)
;; Ensure that scrollbar is also disabled for new frames.
(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

  ;;; Delete trailing whitespace when saving.
;; Configure this as a customizable variable. This allows disabling
;; trailing whitespace deletion when the variable is set to
;; nil. This is useful when working on someone else's project which
;; has trailing whitespace.
(defvar mh-delete-trailing-whitespace t)
(add-hook 'before-save-hook (lambda ()
                              (if mh-delete-trailing-whitespace
                                  (delete-trailing-whitespace))))

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; ignore undo discard info warnings
(setq warning-suppress-types '((undo discard-info)))

;; enable visual-line-mode in non-programming modes
(add-hook 'text-mode-hook #'visual-line-mode)

;; TODO this makes many rust files executable which shouldn't be.
;; ;; automatically make relevant files executable
;; (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil) ; don't use tabs to indent
(setq-default tab-width 8)          ; but maintain correct appearance

;; Set default font.
(defconst mh-font "Source Code Pro")
;; Setting the font size to 9pt sets the font to 9/72 in. Therefore,
;; this is a consistent size and does not depend on the screen
;; resolution.
(defconst mh-font-size 9)
;;(defun mh/font-size-pt ()
;;  "Calculate an appropriate font size for the current screen."
;;  (let ((screen-diagonal-in (/ (sqrt (+ (expt (display-mm-width) 2)
;;                                        (expt (display-mm-height) 2)))
;;                               25.4))
;;        ;; assume laptop viewing distance is 13 in.
;;        (viewing-distance 13)
;;        ;; angle corresponding to half the height of a line
;;        (angle (/ 1 416)))
;;    ;; laptop screens assumed to be < 25 in.
;;    (if (> screen-diagonal-in 25)
;;        (setq viewing-distance 26))))

;;(set-frame-font (font-spec
;;                 :family "Source Code Pro"
;;                 :foundry "ADBO"
;;                 :spacing 100 ; mono-spacing
;;                 :size ))
(add-to-list 'default-frame-alist
             `(font . ,(concat mh-font "-" (number-to-string mh-font-size))))

;; This permits folding throughout Emacs. For instance, Evil's fold capabilities rely on this being
;; set.
(setq outline-minor-mode t)

;; don't truncate message log buffer
(setq message-log-max t)

;; Newline at end of file.
(setq require-final-newline t)

;; Don't insert pairs in the minibuffer.
(add-hook 'minibuffer-setup-hook (lambda ()
                                   (electric-pair-local-mode 'toggle)))

;; Never ring the bell.
(setq ring-bell-function 'ignore)

;; ;; Automatically save buffers visiting files, so that I don't have
;; ;; to do it manually.
;; (auto-save-visited-mode)

;; Disable performance-affecting features when lines become very long
(global-so-long-mode 1)

;; Allow recursive minibuffers and provide an indication of recursion
;; depth.
(custom-set-variables '(enable-recursive-minibuffers t))
(minibuffer-depth-indicate-mode nil)

(custom-set-variables
 ;; TODO probably remove this at some point, but have popups for
 ;; direnv is annoying.
 '(log-warning-minimum-level :error)
 ;; disable mouse scrolling and zooming
 '(mouse-wheel-mode nil))

;; TODO these should probably be in func and customize.
(defun mh/sudo-find-file (file-name)
  "Like find-file, but opens FILE-NAME as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))

(defun mh/copy-untabify (start end)
  "Copy the region from START to END.
  Tabs at the beginning of each line are replaced by the equivalent
  amount of spaces. This is often useful when pasting outside
  Emacs."
  (interactive "r")
  (kill-new
   (replace-regexp-in-string
    "^\t+"
    (lambda (substring)
      (make-string (* tab-width (length substring)) ?\s))
    (buffer-substring start end))))

(defun mh/copy-file-path ()
  "Copy the absolute file path of the current file to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(defun mh/copy-file-name ()
  "Copy the file name of the current file to the clipboard."
  (interactive)
  (let ((buffername (buffer-name)))
    (when buffername
      (with-temp-buffer
        (insert buffername)
        (clipboard-kill-region (point-min) (point-max)))
      (message buffername))))

(defun mh/indent-buffer ()
  "Indent the entire buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(setq mh-face-attribute-height 80)
(defun mh/zoom-in ()
  (interactive)
  (setq mh-face-attribute-height (+ mh-face-attribute-height 10))
  (set-face-attribute 'default nil :height mh-face-attribute-height))

(defun mh/zoom-in-selected-frame ()
  (interactive)
  (set-face-attribute 'default (selected-frame) :height
                      (+ (face-attribute 'default :height) 10)))

(defun mh/zoom-out ()
  (interactive)
  (setq mh-face-attribute-height (- mh-face-attribute-height 10))
  (set-face-attribute 'default nil :height
                      mh-face-attribute-height))

(defun mh/zoom-out-selected-frame ()
  (interactive)
  (set-face-attribute 'default (selected-frame) :height
                      (- (face-attribute 'default :height) 10)))

(defun mh/insert-rand-password-at-point (len include-sp-chars)
  (interactive "nlength: \nMInclude special characters? (y/n): ")
  ;; head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''
  ;; </dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c 13  ; echo
  (let ((output ""))
    (if (string-equal include-sp-chars "y")
        (setq output (shell-command-to-string
                      (concat "</dev/urandom tr -dc "
                              "'A-Za-z0-9!\"#$%&'\\''()*+,-./:;<=>?@[\\]^_`{|}~'"
                              " | head -c "
                              (number-to-string len)
                              " ; echo")))
      (setq output (shell-command-to-string
                    (concat "head /dev/urandom | tr -dc A-Za-z0-9 "
                            "| head -c "
                            (number-to-string len)
                            " ; echo ''"))))
    (insert output)))

(defun mh//rand-hex-string (len)
  "Generate a random hex string and return the value.  LEN is the length."
  (shell-command-to-string
   (concat "head /dev/urandom | tr -dc a-f0-9 "
           "| head -c "
           (number-to-string len)
           " ; echo -n ''")))

(defun mh/insert-rand-hex-string-at-point (len)
  "Insert random hex string at point.  LEN is the length."
  (interactive "nlength: \n")
  ;; head /dev/urandom | tr -dc a-f0-9 | head -c len ; echo -n ''
  (let ((output ""))
    (setq output (mh//rand-hex-string len))
    (insert output)))

(defun mh/insert-rand-number-at-point (len)
  "Insert random number at point.  LEN is the length."
  (interactive "nlength: \n")
  ;; head /dev/urandom | tr -dc 0-9 | head -c len ; echo -n ''
  (let ((output ""))
    (setq output (shell-command-to-string
                  (concat "head /dev/urandom | tr -dc 0-9 "
                          "| head -c "
                          (number-to-string len)
                          " ; echo -n ''")))
    (insert output)))

(defun mh/clear-image-cache ()
  "Sometimes Emacs shows the wrong image when it thinks an image
hasn't changed. This clears the image cache to prevent this."
  (interactive)
  (clear-image-cache t))

(defun mh/insert-current-date ()
  (interactive)
  (insert (shell-command-to-string "echo -n $(date --iso-8601)")))

(defun mh/time-stamp ()
  (format-time-string "[%Y-%m-%d %a %H:%M]"))

(defun mh/screenshot-svg ()
  "Save a screenshot of the current frame as an SVG image.
Saves to a temp file and puts the filename in the kill ring."
  (interactive)
  (let* ((filename (make-temp-file "Emacs" nil ".svg"))
         (data (x-export-frames nil 'svg)))
    (with-temp-file filename
      (insert data))
    (kill-new filename)
    (message filename)))

(defun mh//inc-char (char)
  "Increment CHAR.
For instance this will perform 'a' -> 'b'"
  (string (1+ (string-to-char char))))

(defun mh/point-at-line-begp ()
  "Indicate whether point is at the beginning of a line."
  (let ((beg-pos (line-beginning-position)))
    (eq (point) beg-pos)))

(defun mh/replace-all-alist-items-in-current-buffer (alist)
  "Take an association list ALIST and replace the first item in each alist pair with the second item."
  (dolist (elt alist)
    (goto-char 0)
    (while (re-search-forward (car elt) nil t)
      (replace-match (cdr elt) t))))

(defun mh/create-scratch-buffer ()
  "Create a scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun mh/save-without-hooks ()
  "Save current buffer without calling before-save-hooks."
  (interactive)
  (let ((before-save-hook nil))
    (save-buffer)))

(defun mh/window-width (&optional window)
  "WINDOW width, in number of characters.
If WINDOW is omitted, use the current window, otherwise use the specified window."
  ;; For some reason, `window-max-chars-per-line' overreports the
  ;; number of available characters by one in EXWM buffers.
  (if exwm-window-type
      (- (window-max-chars-per-line window) 1)
    (window-max-chars-per-line window)))

(defun mh/directory-files-replace-string (directory search replace)
  "Replace literal string in all files within a directory.

DIRECTORY is the directory to search.  SEARCH is the string to
replace, and REPLACE is its replacement.

This function only searches the top level of files in the
directory."
  (let ((files (directory-files directory t)))
    (dolist (file files)
      (unless (equal (substring file -1 nil) ".")
        (progn (find-file-literally file)
               (replace-string search replace)
               (save-buffer)
               (kill-buffer (get-file-buffer file)))))))

(defun mh/display-mm-dimensions ()
  "Display dimensions (in mm) as reported by xrandr.
`display-mm-width', `x-display-mm-width', etc. return values
based on the number of pixels and DPI. So if the DPI is
incorrect, these dimensions will be too."
  (let* ((xrandr-output (shell-command-to-string "xrandr --query --verbose | grep 'connected primary'"))
         (rotation (substring
                    (shell-command-to-string (concat "echo -n '" xrandr-output "' | " "cut -d ' ' -f 6"))
                    0 -1))
         (match-1-start (string-match "[0-9]+mm" xrandr-output))
         (match-1-end (match-end 0))
         (match-2-start (string-match "[0-9]+mm" xrandr-output match-1-end))
         (match-2-end (match-end 0))
         (width (string-to-number
                 (substring xrandr-output match-1-start (- match-1-end 2))))
         (height (string-to-number
                  (substring xrandr-output match-2-start (- match-2-end 2)))))
    (if (or (string-equal "left" rotation)
            (string-equal "right" rotation))
        `(,height . ,width)
      `(,width . ,height))))

(defun mh/display-pixel-dimensions ()
  "Display dimensions (in pixels) as reported by xrandr.
`display-pixel-width' and `display-pixel-width' appear to display
the pixel dimensions of the screen rather than the display (see
xrandr -q)."
  (let* ((xrandr-output (shell-command-to-string "xrandr | grep 'connected primary'"))
         (match-1-start (string-match "[0-9]+x" xrandr-output))
         (match-1-end (match-end 0))
         (match-2-start (string-match "[0-9]+\\+" xrandr-output match-1-end))
         (match-2-end (match-end 0))
         (width (string-to-number
                 (substring xrandr-output match-1-start (- match-1-end 1))))
         (height (string-to-number
                  (substring xrandr-output match-2-start (- match-2-end 1)))))
    `(,width . ,height)))

(defun mh/dpi ()
  "Screen resolution in DPI.
Returns a list in which the first number is the DPI in the
horizontal direction, and the second number is the DPI in the
vertical direction.  Another way to do this would be to parse the
output of 'xdpyinfo | grep resolution'."
  (let ((in/mm (/ 1 25.4))
        (pixel-dimensions (mh/display-pixel-dimensions))
        (mm-dimensions (mh/display-mm-dimensions)))
    (list (/ (car pixel-dimensions)
             (* in/mm (car mm-dimensions)))
          (/ (cdr pixel-dimensions)
             (* in/mm (cdr mm-dimensions))))))

(defun mh/image-exif ()
  "Print Exif data associated with the image file corresponding to
the current buffer."
  (interactive)
  (let ((file (buffer-file-name)))
    (start-process-shell-command "exiftool" "*exif*"
                                 (concat "exiftool "
                                         file))
    (display-buffer "*exif*")))

(defun mh/unzip (file)
  "Uncompress a zip archive in a directory matching the archive name."
  (interactive "fzip file: ")
  (let ((file-base-name (file-name-sans-extension file))
        (file-directory-name (file-name-directory file)))
    (start-process-shell-command "unzip" "*unzip*"
                                 (concat "unzip "
                                         "-d '" file-base-name
                                         "' '" file "'"))))

(defun mh/zip (file)
  "Create a zip archive matching the file name."
  (interactive "ffile: ")
  (start-process-shell-command "zip" "*zip*"
                               (concat "zip "
                                       "-r '" file ".zip'"
                                       " '" file "'")))

(defun mh//dump-vars-to-buffer (varlist buffer)
  "Dump variable value to a buffer. Taken from https://stackoverflow.com/a/2322164."
  (loop for var in varlist do
        (print (list 'setq var (list 'quote (symbol-value var))) buffer)))

(defun mh//dump-vars-to-file (vars filename)
  "Dump variable to file such that it can be resurrected later with
'load or 'read.  Taken from https://stackoverflow.com/a/2322164.
TODO it would probably be preferable if saving the buffer were
asynchronous, since it incurs a slight delay for large variables."
  (save-excursion
    (let ((buf (find-file-noselect filename)))
      (set-buffer buf)
      (erase-buffer)
      (mh//dump-vars-to-buffer vars buf)
      (mh/save-without-hooks)
      (kill-buffer))))

(defun mh/surround-math-delimiters (&optional beg end)
  "Surround selected text or word at point in buffer with \\(...\\)."
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (let ((bounds (bounds-of-thing-at-point 'word)))
       (list (car bounds) (cdr bounds)))))
  (save-excursion
    (goto-char beg)
    (insert "\\(")
    (goto-char (+ end 2))
    (insert "\\)")))


(defun mh/get-max-brightness ()
  "Return the maximum settable backlight brightness. TODO the actual limit is lower. How is this determined?"
  (interactive)
  (string-to-number (shell-command-to-string "cat /sys/class/backlight/apple-panel-bl/max_brightness")))

(defun mh/get-current-brightness ()
  "Return current backlight brightness setting."
  (interactive)
  (string-to-number (shell-command-to-string "light -G")))

(defun mh/increase-brightness ()
  "Increase current brightness by 10%."
  (interactive)
  (let* ((cur (mh/get-current-brightness))
         (new (round (* 1.1 cur))))
    (if (equal new cur)
        (setq ((new (+ cur 1)))))
    (shell-command-to-string (concat "light -S " (number-to-string new)))
    (message (concat "New brightness setting: " (number-to-string new) "/"
                     (number-to-string (mh/get-max-brightness))))))

(defun mh/decrease-brightness ()
  "Decrease current brightness by 10%."
  (interactive)
  (let* ((cur (mh/get-current-brightness))
         (new (round (* 0.9 cur))))
    (if (equal new cur)
        (setq ((new (- cur 1)))))
    (shell-command-to-string (concat "light -S " (number-to-string new)))
    (message (concat "New brightness setting: " (number-to-string new) "/"
                     (number-to-string (mh/get-max-brightness))))))

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

(provide 'c-base)
;;; c-base.el ends here
