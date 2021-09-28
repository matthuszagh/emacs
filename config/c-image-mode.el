;;; c-image-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'image-mode)

(defun mh/svg-replace-black-with-current-color ()
  "Replace black strokes and fills with currentColor in current SVG document."
  (interactive)
  (replace-string "stroke:#000000" "stroke:currentColor")
  (replace-string "fill:#000000" "fill:currentColor"))

(provide 'c-image-mode)
;;; c-image-mode.el ends here
