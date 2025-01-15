;;; c-image-mode.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'image-mode)

(defun mh/svg-replace-black-with-current-color ()
  "Replace black strokes and fills with currentColor in current SVG document."
  (interactive)
  (replace-string "#000000" "currentColor")
  (replace-string "rgb(0%,0%,0%)" "currentColor")
  (replace-string "rgb(0%, 0%, 0%)" "currentColor"))

(provide 'c-image-mode)
;;; c-image-mode.el ends here
