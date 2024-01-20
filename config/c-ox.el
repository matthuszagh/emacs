;;; c-ox.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'htmlize))

(require 'ox)
;; HTML supports 6 headline levels. Use all 6. The default only
;; presents to top 3 as full sections.
(setq org-export-headline-levels 6)

(require 'ox-html)
;; only wrap code elements in spans and use a CSS file to fontify elements.
(setq org-html-htmlize-output-type 'css)

(require 'ox-publish)
(setq blog-dir "~/src/blog/")
(setq org-publish-project-alist
      `(("blog" :components ("posts" "static"))
        ("posts"
         :base-directory ,(concat blog-dir "org")
         :publishing-directory ,blog-dir
         :publishing-function org-html-publish-to-html
         :htmlize-source t
         :recursive t
         :body-only t
         :with-toc nil
         :exclude "\\(old\\|purgatory\\)")
        ("static"
         :base-directory ,(concat blog-dir "org")
         :base-extension "svg\\|css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|mathml"
         :publishing-directory ,blog-dir
         :publishing-function org-publish-attachment
         :exclude "\\(old\\|purgatory\\)"
         :recursive t)))

;; export macros
(setq org-export-global-macros
      '((comment . "")))
;; export asynchronously
(setq org-export-in-background t)

;; don't trigger error for broken links during export
(setq org-export-with-broken-links t)

;; TODO function to export as backend
;; (let ((org-export-current-backend 'latex))
;;   (funcall-interactively 'org-ctrl-c-ctrl-c))

(provide 'c-ox)
;;; c-ox.el ends here
