;;; c-general.el --- General Configuration -*- lexical-binding: t; -*-

;;; Commentary:

;; TODO keybindings should be grouped on prefix etc instead of
;; package.  Currently, they're too scattered.  This will make it much
;; easier to see what's in a map.

;;; Code:

(unless (featurep 'evil)
  (mh:log-init "ERROR" "attempted to load 'general before 'evil"))

(if (featurep 'straight)
    (straight-use-package 'general))

(require 'general)

;; TODO I think this should probably go in c-window.el
(add-to-list 'same-window-buffer-names "*General Keybindings*")

;; Update all existing buffers to use the keybindings set by
;; general. For some reason, the keybindings aren't really in the
;; proper state if this isn't done. See
;; https://github.com/noctuid/general.el/issues/493.
(add-hook 'after-init-hook (lambda ()
                             (dolist (buffer (buffer-list))
                               (with-current-buffer buffer
                                 (evil-normalize-keymaps)))))

;; Commands begin with `SPC' in normal mode and `C-SPC' in insert mode.
(general-define-key
 :states '(emacs normal insert visual motion)
 :keymaps 'override
 :prefix "SPC"
 :non-normal-prefix "C-SPC"
 :prefix-command 'mh/command-prefix
 :prefix-map 'mh/prefix-map)

;; major mode bindings
(general-create-definer localleader
  :states '(emacs normal insert visual)
  :prefix ","
  :non-normal-prefix "C-,")

(general-define-key
 :states '(emacs normal insert visual motion)
 ;; `describe-char' can be useful to determine a face used, among
 ;; other things. However, calling it through the typical means can
 ;; disrupt this context.
 "<f9>" 'describe-char
 "<XF86MonBrightnessDown>" 'mh/decrease-brightness
 "<XF86MonBrightnessUp>" 'mh/increase-brightness)

;; bindings for programming modes, but agnostic to the
;; specific language. e.g. jump to definition
(general-define-key
 :states 'normal
 "g d" 'xref-find-definitions
 "g p" 'xref-pop-marker-stack
 "g l" 'goto-line
 "g c" 'move-to-column)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "p"
 :prefix-command 'mh/command-prog-prefix
 :prefix-map 'mh/prefix-prog-map)

(if (featurep 'c-switch-window)
    (general-define-key
     :keymaps 'mh/prefix-map
     "w" 'switch-window))

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "W"
 :prefix-command 'mh/command-window-prefix
 :prefix-map 'mh/prefix-window-map
 "h" 'evil-window-left
 "j" 'evil-window-down
 "k" 'evil-window-up
 "l" 'evil-window-right
 "d" 'delete-window
 "s" 'split-window-below
 "S" 'split-window-right
 "m" 'mh/switch-to-minibuffer)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "b"
 :prefix-command 'mh/command-buffer-prefix
 :prefix-map 'mh/prefix-buffer-map
 "r" 'revert-buffer
 "k" 'kill-buffer
 "c" 'clone-indirect-buffer-other-window)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "f"
 :prefix-command 'mh/command-file-prefix
 :prefix-map 'mh/prefix-file-map
 "s" 'basic-save-buffer
 "o" 'find-file-other-window
 ;; "f" 'find-file
 "F" 'mh/sudo-find-file
 "c" 'mh/copy-file-name
 "C" 'mh/copy-file-path)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "a"
 :prefix-command 'mh/command-appearance-prefix
 :prefix-map 'mh/prefix-appearance-map
 "=" 'mh/zoom-in-selected-frame
 "-" 'mh/zoom-out-selected-frame
 "+" 'mh/zoom-in
 "_" 'mh/zoom-out)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "z"
 :prefix-command 'mh/command-format-prefix
 :prefix-map 'mh/prefix-format-map
 "i" 'mh/indent-buffer
 "u" 'ucs-insert)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "s"
 :prefix-command 'mh/command-search-prefix
 :prefix-map 'mh/prefix-search-map
 "r" 'query-replace-regexp)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "c"
 :prefix-command 'mh/command-shell-prefix
 :prefix-map 'mh/prefix-shell-map)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "h"
 :prefix-command 'mh/command-help-prefix
 :prefix-map 'mh/prefix-help-map)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "n"
 :prefix-command 'mh/command-calc-prefix
 :prefix-map 'mh/prefix-calc-map)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "u"
 :prefix-command 'mh/command-undo-prefix
 :prefix-map 'mh/prefix-undo-map)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "x"
 :prefix-command 'mh/command-system-prefix
 :prefix-map 'mh/prefix-system-map)

(general-define-key
 :keymaps 'mh/prefix-map
 :prefix "m"
 :prefix-command 'mh/command-mark-prefix
 :prefix-map 'mh/prefix-mark-map
 "a" 'mark-whole-buffer)

;; minibuffer keybindings
(general-define-key
 :keymaps 'minibuffer-local-map
 "C-j" 'next-history-element
 "C-k" 'previous-history-element)

(localleader :keymaps 'emacs-lisp-mode-map
  "e" 'eval-last-sexp)

;;==================== built-in package keybindings ===================
(localleader
  :keymaps 'c-mode-base-map
  "c" (lambda (cmd)
	(interactive
	 (list
	  (compilation-read-command compile-command)))
	(compile cmd t))
  "k" 'kill-compilation
  "d" 'manual-entry
  "g" 'gdb)

;;==================== package-specific keybindings ===================
(if (featurep 'c-helm-descbinds)
    (general-define-key
     :keymaps 'mh/prefix-help-map
     "b" 'helm-descbinds)
  (mh:log-init "WARNING" "Failed to define keybindings for helm-descbinds, which was not loaded."))

(if (featurep 'c-evil-numbers)
    (general-define-key
     :states '(normal visual emacs)
     "=" 'evil-numbers/inc-at-pt
     "-" 'evil-numbers/dec-at-pt)
  (mh:log-init "WARNING" "Failed to define keybindings for evil-numbers, which was not loaded."))

(if (featurep 'c-erc)
    (general-def mh/prefix-help-map
      "e" 'mh/erc-freenode-connect
      "E" 'mh/erc-bitlebee-connect)
  (mh:log-init "WARNING" "Failed to define keybindings for erc, which was not loaded."))

(if (featurep 'c-lsp-mode)
    (general-define-key
     :states 'normal
     "g i" 'lsp-find-implementation
     "g x" 'lsp-rename)
  (mh:log-init "WARNING" "Failed to define keybindings for lsp-mode, which was not loaded."))

(if (featurep 'c-lsp-ui)
    (progn
      (general-define-key
       :states 'normal
       "g r" 'lsp-ui-peek-find-references
       "g s" 'lsp-ui-find-workspace-symbol)
      (general-define-key
       :keymaps 'lsp-ui-peek-mode-map
       "j" 'lsp-ui-peek--select-next
       "k" 'lsp-ui-peek--select-prev))
  (mh:log-init "WARNING" "Failed to define keybindings for lsp-ui, which was not loaded."))

(if (featurep 'c-helm-librarian)
    (general-define-key
     :keymaps 'mh/prefix-file-map
     "l" 'helm-librarian)
  (mh:log-init "WARNING" "Failed to define keybindings for helm-librarian, which was not loaded."))

(if (featurep 'c-helm-librarian-recoll)
    (general-define-key
     :keymaps 'mh/prefix-file-map
     "r" 'helm-librarian-recoll)
  (mh:log-init "WARNING" "Failed to define keybindings for helm-librarian-recoll, which was not loaded."))

(if (featurep 'c-clang-format)
    (localleader
      :keymaps 'c-mode-base-map
      "f" 'clang-format-buffer)
  (mh:log-init "WARNING" "Failed to define keybindings for clang-format, which was not loaded."))

(if (featurep 'c-flycheck)
    (general-def mh/prefix-prog-map
      "l" 'flycheck-list-errors)
  (mh:log-init "WARNING" "Failed to define keybindings for flycheck, which was not loaded."))

(if (featurep 'c-sx)
    (progn
      (general-def 'normal sx-inbox-mode-map
        "RET" 'sx-display)
      (general-def mh/prefix-search-map
        "S" 'sx-search)
      (localleader :keymaps 'sx-question-mode-map
        "A" 'sx-accept
        "a" 'sx-answer
        "u" 'sx-upvote
        "d" 'sx-downvote))
  (mh:log-init "WARNING" "Failed to define keybindings for sx, which was not loaded."))

(if (featurep 'c-pdf-tools)
    (progn
      (general-define-key
       :states 'normal
       :keymaps 'pdf-view-mode-map
       "j" 'mh/pdf-view-scroll-down
       "J" (lambda ()
             (interactive)
             (pdf-view-next-line-or-next-page 10))
       "k" 'mh/pdf-view-scroll-up
       "K" (lambda ()
             (interactive)
             (pdf-view-previous-line-or-previous-page 10))
       "SPC" 'mh/command-prefix
       "g l" 'pdf-view-goto-page
       "l" 'image-forward-hscroll
       "L" (lambda ()
             (interactive)
             (funcall-interactively 'image-forward-hscroll 10))
       "h" 'image-backward-hscroll
       "H" (lambda ()
             (interactive)
             (funcall-interactively 'image-backward-hscroll 10)))

      (general-define-key
       :state 'normal
       :keymaps 'pdf-outline-buffer-mode-map
       "<tab>" 'outline-toggle-children)

      (localleader :keymaps 'pdf-view-mode-map
        "s" 'pdf-occur
        "g" 'pdf-view-goto-page
        "l" 'pdf-links-isearch-link
        "h" 'pdf-view-fit-height-to-window
        "w" 'pdf-view-fit-width-to-window))
  (mh:log-init "WARNING" "Failed to define keybindings for pdf-tools, which was not loaded."))

(general-def mh/prefix-system-map
  "r" 'mh/nix-rebuild
  "R" 'mh/nix-rebuild-show-trace)

(if (featurep 'c-cc-mode)
    (general-define-key
     :keymaps 'c-mode-base-map
     "RET" 'newline-and-indent)
  (mh:log-init "WARNING" "Failed to define keybindings for nix-base, which was not loaded."))

;; TODO should go in dumb-jump
;; (localleader 'nix-mode-map
;;   "d" 'dumb-jump-go)

(if (featurep 'c-org)
    (progn
      (localleader :keymaps 'org-mode-map
        "b" 'mh/open-book-from-outline)
      ;; evil appears to override certain org-mode keybindings with the
      ;; outline-mode counterparts. revert them here.
      (general-define-key
       :keymaps 'org-mode-map
       :states '(normal motion)
       "<tab>" 'org-cycle
       "g p" 'org-mark-ring-goto
       "g d" 'org-open-at-point
       "j" 'evil-next-visual-line
       "k" 'evil-previous-visual-line
       "$" 'evil-end-of-line-or-visual-line
       "0" 'evil-beginning-of-visual-line
       "V" 'evil-visual-screen-line)

      (general-def 'normal org-mode-map
        "M-j" 'mc/mark-next-like-this
        "M-k" 'mc/mark-previous-like-this
        "g j" 'org-forward-heading-same-level
        "g k" 'org-backward-heading-same-level
        "g l" 'org-next-visible-heading
        "g h" 'org-previous-visible-heading
        "C-j" 'outline-move-subtree-down
        "C-k" 'outline-move-subtree-up)

      ;; local org mode commands
      ;; TODO add local keymaps
      (localleader :keymaps 'org-mode-map
        "T" 'org-babel-tangle
        "l" 'org-insert-link
        ":" 'org-set-tags-command
        "i" 'org-id-get-create
        "C" 'org-columns
        "E" 'org-set-effort
        "I" 'org-clock-in
        "a" 'org-archive-subtree
        "s" 'org-insert-structure-template
        "p" 'org-set-property
        "t" 'org-todo
        "e" 'org-edit-special
        "c" 'org-ref-cite-insert-helm
        "P" 'org-priority
        "L" 'org-latex-preview
        "z" 'mh/command-org-tex-insert-prefix
        "o" 'org-open-at-point
        "R" 'org-table-iterate-buffer-tables
        "m" 'mh/surround-math-delimiters)

      (general-define-key
       :keymaps 'org-mode-map
       "TAB" 'org-cycle
       "C-RET" 'org-insert-heading-respect-content)

      ;; org agenda keys
      ;; override org agenda keys and add back the ones you want
      ;; (setq org-agenda-mode-map (make-composed-keymap general-override-mode-map))
      (evil-set-initial-state 'org-agenda-mode 'normal)
      (general-def 'normal org-agenda-mode-map
        "j" 'org-agenda-next-line
        "k" 'org-agenda-previous-line)

      (localleader :keymaps 'org-agenda-mode-map
        "c" 'org-agenda-columns
        "q" 'org-agenda-quit
        "i" 'org-agenda-clock-in
        "o" 'org-agenda-clock-out
        "t" 'org-agenda-todo
        "e" 'org-agenda-set-effort
        "r" 'org-agenda-redo)

      ;; global org keys
      (general-define-key
       :keymaps 'mh/prefix-map
       :prefix "o"
       :prefix-command 'mh/command-org-prefix
       :prefix-map 'mh/prefix-org-map
       "c" 'org-capture
       "a" 'org-agenda
       "l" 'org-store-link
       "o" 'org-clock-out
       "i" 'org-clock-in-last)))

(if (featurep 'c-helm)
    (general-def mh/prefix-search-map
      "h" 'helm-org-in-buffer-headings))

(if (featurep 'c-calc)
    (progn
      (general-def mh/prefix-calc-map
        "n" 'calc
        "q" 'quick-calc
        "y" 'calc-grab-region)
      (general-define-key
       :keymaps 'calc-mode-map
       :states 'normal
       "DEL" 'calc-pop)))

(if (featurep 'c-company)
    (general-def company-active-map
      "<tab>" 'company-complete-common)
  ;; TODO replace with `mh:log-init'
  (error "Attempted to set company keybindings without loading 'company'"))

(if (featurep 'c-org-roam)
    (progn
      (general-define-key
       :keymaps 'mh/prefix-map
       :prefix "i"
       :prefix-command 'mh/command-info-prefix
       :prefix-map 'mh/prefix-info-map
       "f" 'org-roam-node-find
       "t" 'mh/org-roam-node-find-todo
       "i" 'org-roam-node-insert)
      (localleader :keymaps 'org-mode-map
        "r" 'org-roam-buffer-toggle))
  (mh:log-init "WARNING" "attempted to set org-roam keybindings without loading 'c-org-roam"))

(if (featurep 'c-org-noter)
    (localleader :keymaps 'org-mode-map
      "n" 'org-noter)
  (mh:log-init "ERROR" "attempted to set org-noter keybindings without loading 'c-org-noter"))

(if (featurep 'c-man)
    (general-def 'normal Man-mode-map
      "RET" 'man-follow)
  (mh:log-init "ERROR" "attempted to set man keybindings without loading 'c-man"))

(if (featurep 'c-info)
    (progn
      (general-define-key
       :states 'normal
       :keymaps 'Info-mode-map
       "H" 'Info-history
       "RET" 'Info-follow-nearest-node
       "g d" 'Info-follow-nearest-node
       "g p" 'Info-backward-node)
      (localleader :keymaps 'Info-mode-map
        "h" 'Info-backward-node
        "l" 'Info-forward-node))
  (mh:log-init "ERROR" "attempted to set info keybindings without loading 'c-info"))

(if (featurep 'c-elfeed)
    (progn
      (general-def mh/prefix-search-map
        "b" 'elfeed)
      (localleader :keymaps 'elfeed-search-mode-map
        "u" 'elfeed-update
        "s" 'elfeed-search-live-filter))
  (mh:log-init "ERROR" "attempted to set elfeed keybindings without loading 'c-elfeed"))

(if (and (featurep 'c-elisp-mode)
         (featurep 'c-dumb-jump))
    (general-define-key
     :keymaps 'emacs-lisp-mode-map
     :states 'normal
     "g d" 'dumb-jump-go
     "g p" 'dumb-jump-back)
  (mh:log-init "ERROR" "attempted to set elisp-mode + dumb-jump keybindings without loading 'c-elisp-mode and 'c-dumb-jump"))

(if (featurep 'c-helm-ls-git)
    (progn
      (general-def helm-ls-git-map
        "M-SPC" 'mh/command-prefix
        ;; gets git status
        "C-v" (lambda ()
                (interactive)
                ;; this isn't ideal and there should be a better way to
                ;; do this, but it works
                (helm-select-nth-action 1)))
      (general-def mh/prefix-search-map
        "g" (lambda ()
              (interactive)
              (if (helm-ls-git-root-dir)
                  (command-execute 'helm-grep-do-git-grep)
                (command-execute 'helm-do-grep-ag)))))
  (mh:log-init "ERROR" "attempted to set helm-ls-git keybindings without loading 'c-helm-ls-git"))

(if (featurep 'c-helm)
    (progn
      (general-def mh/prefix-search-map
        "p" 'helm-ls-git-ls
        "P" 'helm-projects-history)
      (general-def mh/prefix-map
        "SPC" 'helm-M-x)
      (general-def mh/prefix-search-map
        "s" 'helm-occur)
      (general-define-key
       :keymaps 'mh/prefix-file-map
       "f" 'helm-find-files
       "a" 'helm-locate)
      (general-def mh/prefix-buffer-map
        "b" 'helm-buffers-list)
      (general-def helm-map
        "C-j" 'helm-next-line
        "C-k" 'helm-previous-line
        "C-h" 'helm-find-files-up-one-level
        "C-l" 'helm-execute-persistent-action)
      (general-def helm-read-file-map
        "C-l" 'helm-execute-persistent-action)
      (general-def mh/prefix-system-map
        "l" 'helm-locate-library)
      (general-def mh/prefix-prog-map
        "e" (lambda ()
              (helm-browse-project-find-files "~/src/dotfiles/emacs")))

      ;; keybindings for candidates when invoking `helm-find-files'.
      (general-define-key
       :keymaps 'helm-find-files-map
       ;; navigate into directory at point
       "C-l" 'helm-execute-persistent-action
       "C-e" 'helm-ff-run-eshell-command-on-file
       "C-d" 'helm-ff-run-delete-file
       "C-s" 'helm-ff-run-grep
       ;; open file in adjacent window
       ;; "C-o" 'helm-ff-run-switch-other-window
       "C-c" 'helm-ff-run-copy-file
       "C-r" 'helm-ff-run-rename-file
       "C-y" 'yank
       "C-t" 'helm-ff-run-ediff-file
       "C-p" 'helm-ff-run-browse-project
       ;; display file properties
       "C-n" 'helm-ff-properties-persistent
       "M-SPC" 'mh/command-prefix)

      ;; keybindings for candidates in `helm-buffers-list'
      (general-def helm-buffer-map
        "C-d" 'helm-buffer-run-kill-persistent)
      (general-def mh/prefix-help-map
        "i" 'helm-info
        "m" 'helm-man-woman))
  (mh:log-init "ERROR" "attempted to set helm keybindings without loading 'c-helm"))

(if (featurep 'c-helpful)
    (general-def mh/prefix-help-map
      "h" 'helpful-at-point
      "f" 'helpful-function
      "v" 'helpful-variable
      "k" 'helpful-key
      "M" 'helpful-macro)
  (mh:log-init "ERROR" "attempted to set helpful keybindings without loading 'c-helpful"))

(if (featurep 'c-hexl)
    (localleader :keymaps 'hexl-mode-map
      "a" 'hexl-goto-address)
  (mh:log-init "ERROR" "attempted to set hexl keybindings without loading 'c-hexl"))

(if (featurep 'c-image-mode)
    (general-define-key
     :keymaps 'image-map
     "i" 'image-increase-size
     "o" 'image-decrease-size
     "l" 'image-next-frame
     "h" 'image-previous-frame)
  (mh:log-init "ERROR" "attempted to set image-mode keybindings without loading 'c-image-mode"))

(if (featurep 'c-helm-eww)
    (localleader :keymaps 'eww-mode-map
      "H" 'helm-eww-history)
  (mh:log-init "ERROR" "attempted to set helm-eww keybindings without loading 'c-helm-eww"))

(if (featurep 'c-eww)
    (progn
      (general-def mh/prefix-search-map
        "i" 'eww)
      (localleader :keymaps 'eww-mode-map
        "h" 'eww-back-url
        "l" 'eww-forward-url)
      (general-define-key
       :states 'normal
       :keymaps 'eww-mode-map
       "L" 'evil-window-bottom
       "H" 'evil-window-top))
  (mh:log-init "ERROR" "attempted to set eww keybindings without loading 'c-eww"))

(if (and (featurep 'c-eww)
         (featurep 'c-evil))
    (general-define-key
     :states 'normal
     :keymaps 'eww-mode-map
     "L" 'evil-window-bottom
     "H" 'evil-window-top)
  (mh:log-init "ERROR" "attempted to set eww + evil keybindings without loading 'c-eww and 'c-evil"))

(if (featurep 'c-helm-notmuch)
    (general-def mh/prefix-search-map
      "m" 'helm-notmuch)
  (mh:log-init "ERROR" "attempted to set helm-notmuch keybindings without loading 'c-helm-notmuch"))

(if (featurep 'c-notmuch)
    (localleader :keymaps 'notmuch-show-mode-map
      "r" 'notmuch-show-reply)
  (mh:log-init "ERROR" "attempted to set notmuch keybindings without loading 'c-notmuch"))

(if (and (featurep 'c-notmuch)
         (featurep 'c-mml))
    (localleader :keymaps 'notmuch-message-mode-map
      "a" 'mml-attach-file)
  (mh:log-init "ERROR" "attempted to set notmuch + mml keybindings without loading 'c-notmuch and 'c-mml"))

(if (featurep 'c-make-mode)
    (localleader :keymaps 'makefile-mode-map
      "c" '(lambda (cmd)
             (interactive
              (list
               (compilation-read-command compile-command)))
             (compile cmd t)))
  (mh:log-init "ERROR" "attempted to set make-mode keybindings without loading 'c-make-mode"))

(if (featurep 'c-compile)
    (localleader
      :keymaps 'compilation-mode-map
      "i" 'mh/toggle-comint-compilation)
  (mh:log-init "ERROR" "attempted to set compile keybindings without loading 'c-compile"))

(if (featurep 'c-markdown-mode)
    (general-define-key
     :keymaps 'markdown-mode-map
     :states '(normal motion)
     "j" 'evil-next-visual-line
     "k" 'evil-previous-visual-line
     "$" 'evil-end-of-line-or-visual-line
     "0" 'evil-beginning-of-visual-line
     "V" 'evil-visual-screen-line)
  (mh:log-init "ERROR" "attempted to set 'markdown-mode keybindings without loading 'c-markdown-mode"))

(if (featurep 'c-multiple-cursors)
    (general-def
      "M-j" 'mc/mark-next-like-this
      "M-k" 'mc/mark-previous-like-this)
  (mh:log-init "ERROR" "attempted to set 'multiple-cursors keybindings without loading 'c-multiple-cursors"))

(if (featurep 'c-octave)
    (localleader 'octave-mode-map
      "h" 'octave-help)
  (mh:log-init "ERROR" "attempted to set 'octave keybindings without loading 'c-octave"))

(if (featurep 'c-python)
    (localleader :keymaps 'python-mode-map
      "c" '(lambda (cmd)
             (interactive
              (list
               (compilation-read-command compile-command)))
             (compile cmd t)))
  (mh:log-init "ERROR" "attempted to set 'python keybindings without loading 'c-python"))

(if (featurep 'c-realgud)
    (localleader :keymaps 'python-mode-map
      "d" 'realgud:pdb)
  (mh:log-init "ERROR" "attempted to set 'realgud keybindings without loading 'c-realgud"))

(if (and (featurep 'c-rmsbolt)
         (featurep 'c-cc-mode))
    (localleader :keymaps 'c-mode-base-map
      "C" 'rmsbolt-compile)
  (mh:log-init "ERROR" "attempted to set 'rmsbolt + 'cc-mode keybindings without loading 'c-rmsbolt and 'c-cc-mode"))

(if (and (featurep 'c-rmsbolt)
         (featurep 'c-elisp-mode))
    (localleader :keymaps 'elisp-mode-map
      "C" 'rmsbolt-compile)
  (mh:log-init "ERROR" "attempted to set 'rmsbolt + 'elisp-mode keybindings without loading 'c-rmsbolt and 'c-elisp-mode"))

(if (and (featurep 'c-rmsbolt)
         (featurep 'c-python))
    (localleader :keymaps 'python-mode-map
      "C" 'rmsbolt-compile)
  (mh:log-init "ERROR" "attempted to set 'rmsbolt + 'python keybindings without loading 'c-rmsbolt and 'c-python"))

(if (featurep 'c-sage-shell-mode)
    (general-def mh/prefix-map
      "N" 'sage-shell:run-sage)
  (mh:log-init "ERROR" "attempted to set 'sage-shell-mode keybindings without loading 'c-sage-shell-mode"))

(if (featurep 'c-vterm)
    (progn
      (general-define-key
       :states '(normal insert)
       :keymaps 'vterm-mode-map
       "C-k" 'vterm-send-up
       "C-j" 'vterm-send-down
       ;; TODO this should probably go back to clear if I change recenter to something else
       ;; unbind clear since I'm too used to using C-l for centering the
       ;; page
       "C-l" 'recenter-top-bottom)
      (localleader :keymaps 'vterm-mode-map
        "t" 'vterm-copy-mode
        "c" 'vterm-clear-scrollback)
      ;; TODO evil interferes with this
      (localleader :keymaps 'vterm-copy-mode-map
        "t" 'vterm-copy-mode-done)
      (general-def mh/prefix-shell-map
        "T" 'vterm))
  (mh:log-init "ERROR" "attempted to set 'vterm keybindings without loading 'c-vterm"))

(if (featurep 'c-vterm-toggle)
    (general-def mh/prefix-shell-map
      "t" 'vterm-toggle)
  (mh:log-init "ERROR" "attempted to set 'vterm-toggle keybindings without loading 'c-vterm-toggle"))

(if (featurep 'c-eshell)
    (progn
      (general-def mh/prefix-shell-map
        "e" 'vterm-toggle)
      (general-define-key
       :states '(normal insert)
       :keymaps '(eshell-hist-mode-map)
       "C-k" 'eshell-previous-matching-input-from-input
       "C-j" 'eshell-next-matching-input-from-input))
  (mh:log-init "ERROR" "attempted to set 'eshell keybindings without loading 'c-eshell"))

(if (featurep 'c-comint)
    (general-define-key
     :keymaps 'comint-mode-map
     "C-k" 'comint-previous-input
     "C-j" 'comint-next-input
     "C-r" 'comint-history-isearch-backward-regexp)
  (mh:log-init "ERROR" "attempted to set 'comint keybindings without loading 'c-comint"))

(if (and (featurep 'c-comint)
         (featurep 'c-term))
    (localleader :keymaps 'term-line-mode
      "c" 'comint-clear-buffer)
  (mh:log-init "ERROR" "attempted to set 'comint + 'term keybindings without loading 'c-comint and 'c-term"))

(if (featurep 'c-simple)
    (general-def mh/prefix-shell-map
      "c" 'async-shell-command)
  (mh:log-init "ERROR" "attempted to set 'simple keybindings without loading 'c-simple"))

(if (featurep 'c-proced)
    (progn
      (general-def mh/prefix-system-map
        "p" 'proced)
      (general-define-key
       :states 'normal
       :keymaps 'proced-mode-map
       "g" 'revert-buffer
       "t" 'mh/strace-pid-proced))
  (mh:log-init "ERROR" "attempted to set 'proced keybindings without loading 'c-proced"))

(if (featurep 'c-time)
    (general-def mh/prefix-system-map
      "c" 'display-time-mode)
  (mh:log-init "ERROR" "attempted to set 'time keybindings without loading 'c-time"))

(if (featurep 'c-battery)
    (general-def mh/prefix-system-map
      "b" 'display-battery-mode)
  (mh:log-init "ERROR" "attempted to set 'time keybindings without loading 'c-time"))

(if (featurep 'c-helm-systemd)
    (general-def mh/prefix-system-map
      "d" 'helm-systemd)
  (mh:log-init "ERROR" "attempted to set 'helm-systemd keybindings without loading 'c-helm-systemd"))

(if (featurep 'c-undo-tree)
    (general-def mh/prefix-undo-map
      "u" 'undo-tree-undo
      "r" 'undo-tree-redo
      "U" 'undo-tree-visualize)
  (mh:log-init "ERROR" "attempted to set 'undo-tree keybindings without loading 'c-undo-tree"))

(if (featurep 'c-magit)
    (general-def mh/prefix-prog-map
      "s" 'magit-status
      "S" 'magit-list-repositories)
  (mh:log-init "ERROR" "attempted to set 'magit keybindings without loading 'c-magit"))

;;(if (featurep 'c-git-timemachine)
;;    (general-def mh/prefix-prog-map
;;      "t" 'git-timemachine)
;;  (mh:log-init "ERROR" "attempted to set 'git-timemachine keybindings without loading 'c-git-timemachine"))

;; (if (featurep 'c-verilog-mode)
;;     (progn
;;       (localleader :keymaps 'verilog-mode-map
;;         "c" (lambda (cmd)
;; 	      (interactive
;; 	       (list
;; 	        (compilation-read-command compile-command)))
;; 	      (compile cmd t)))
;;       (general-define-key
;;        :keymaps 'verilog-mode-map
;;        :states 'normal
;;        "g d" 'dumb-jump-go
;;        "g p" 'dumb-jump-back))
;;   (mh:log-init "ERROR" "attempted to set 'verilog-mode keybindings without loading 'c-verilog-mode"))

(if (featurep 'c-define-word)
    (general-define-key
     :keymaps 'mh/prefix-help-map
     "w" 'define-word-at-point
     "W" 'define-word)
  (mh:log-init "ERROR" "general attempted to set 'define-word keybindings without loading 'c-define-word"))

(provide 'c-general)

;;; c-general.el ends here
