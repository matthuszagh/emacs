;;; c-straight.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; We use a straight-maintained mirror, which fixes an issue that makes tex-sites.el unavailable to
;; AUCTeX.
(setq straight-recipes-gnu-elpa-use-mirror t)

;; Retreive straight if we don't have it.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(provide 'c-straight)
;;; c-straight.el ends here
