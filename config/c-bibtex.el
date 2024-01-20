;;; c-bibtex.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'bibtex)

(custom-set-variables
 '(bibtex-dialect 'biblatex)
 '(bibtex-completion-bibliography '("~/doc/notes/wiki/librarian.bib"
                                    "~/doc/notes/wiki/migrate.bib"))
 '(bibtex-completion-library-path "~/doc/library")
 '(bibtex-completion-pdf-field "file")
 '(bibtex-completion-notes-path "~/doc/notes/wiki"))

(provide 'c-bibtex)
;;; c-bibtex.el ends here
