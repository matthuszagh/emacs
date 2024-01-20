;;; c-image-dired.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'image-dired)

(custom-set-variables
 `(image-dired-thumb-size 512)
 `(image-dired-thumb-width ,image-dired-thumb-size)
 `(image-dired-thumb-height ,image-dired-thumb-size)
 `(image-dired-thumbs-per-row 2))

(provide 'c-image-dired)
;;; c-image-dired.el ends here
