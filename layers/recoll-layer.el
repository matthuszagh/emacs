;;; recoll-layer.el --- Recoll Layer -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(layer-def recoll
  :setup
  ;; TODO I can't think of a setup stage for this. Does this mean
  ;; setup should not be necessary?
  (message "recoll layer")

  :postsetup
  (:layer helm
   (use-package helm-recoll
     :config
     (helm-recoll-create-source "library" "~/.recoll/library")))

  (:layer org
   (use-package org-recoll)))

;;; recoll-layer.el ends here
