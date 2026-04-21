;;; c-doom-modeline.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'doom-modeline))

(require 'doom-modeline)
(doom-modeline-mode 1)

(defun mh/truncate-buffer-name-dynamic (str)
  "Truncate STR based on available mode-line space."
  (let* ((window-width (window-width))
         ;; Temporarily replace buffer name with empty string to
         ;; measure other elements
         (orig-func doom-modeline-buffer-file-name-function)
         (doom-modeline-buffer-file-name-function (lambda () ""))
         ;; Measure the mode-line without buffer name - use
         ;; string-width for display width
         (other-elements-width (string-width (format-mode-line mode-line-format)))
         ;; Restore original function
         (doom-modeline-buffer-file-name-function orig-func)
         ;; Calculate available space with 1 character of padding
         (available-width (- window-width other-elements-width 1)))
    ;; Only truncate if actually necessary
    (if (> (string-width str) available-width)
        (let* ((ellipsis "…")
               (str-width (string-width str))
               ;; Binary search to find the right truncation point
               ;; since string-width might not equal character count
               ;; (e.g., with wide characters)
               (keep-start (min 10 (/ available-width 3)))
               (keep-end (- available-width keep-start 1)))
          (if (> keep-end 0)
              (concat (substring str 0 keep-start)
                      ellipsis
                      (substring str (max keep-start (- (length str) keep-end))))
            ;; Fallback for very narrow windows
            (let ((max-chars (- available-width 1)))
              (concat (substring str 0 (min max-chars (length str))) ellipsis))))
      str)))

;; (advice-add 'doom-modeline-buffer-file-name :filter-return
;;             #'mh/truncate-buffer-name-dynamic)
;; (advice-remove 'doom-modeline-buffer-file-name
;;                #'mh/truncate-buffer-name-dynamic)

(provide 'c-doom-modeline)
;;; c-doom-modeline.el ends here
