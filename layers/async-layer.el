;;; async-layer.el --- Summary -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(layer-def async
  :setup
  (use-package async
    :config
    (dired-async-mode 1))

  :postsetup
  (:layer org
   (use-package ob-async)))

;;; async-layer.el ends here
