;;; sage-layer.el -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Code:

(layer-def sage
  :setup
  (use-package sage-shell-mode
    :hook (sage-shell-mode . (lambda ()
                               (set-fill-column 1000))))

  :postsetup
  (:layer modal
   (general-def mh/prefix-map
     "N" 'sage-shell:run-sage)))

;;; sage-layer.el ends here