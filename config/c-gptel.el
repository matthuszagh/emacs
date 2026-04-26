;;; c-gptel.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'gptel))

(require 'gptel)
(require 'gptel-org)

(gptel-make-anthropic "Claude" :stream t :key gptel-api-key)
(gptel-make-anthropic "Claude-thinking"
  :stream t
  :key gptel-api-key
  :request-params '(:thinking (:type "enabled" :budget_tokens 4096)
                    :max_tokens 8192))

;; local DeepSeek
(gptel-make-openai "DeepSeek-Local-HQ"
  :host "localhost:8080"
  :stream t
  :models '("deepseek-v3.1-local")
  :request-params '(:temperature 0.7
                    :top_p 0.95
                    :repeat_penalty 1.05))

(custom-set-variables
 '(gptel-model "gpt-4.1")
 '(gptel-track-media t))

(defun mh/gptel-org-new-thread (title)
  "Add a new org headline for a GPT thread.
TITLE is the name of the headline.  This invokes a highly customized
workflow for my personal needs and isn't a proper general-purpose
function.  But, it automates a frequent, tedious task so it is
currrently useful."
  (interactive "sTitle: ")
  (funcall-interactively 'org-insert-heading-respect-content)
  (mh/insert-current-date)
  (insert ": ")
  (insert title)
  (org-set-property "GPTEL_MODEL" "claude-opus-4-7")
  (org-set-property "GPTEL_BACKEND" "Claude-thinking")
  (org-set-property "GPTEL_SYSTEM" "Prioritize being explanatory, clear, and correct over being overly concise. When typesetting LaTeX math (and only in this case), use \"\\(\" and \"\\)\" as delimiters and only include valid characters (e.g., \\lambda, not λ). When typesetting currencies, use eg USD 500 or EUR 300 etc. (don't use a dollar sign). Define all variables and symbols. Use \\ket{}, \\bra{}, and \\braket{}{} instead of combinations of '|', '\\rangle', and '\\langle'.")
  (org-id-get-create)
  ;; TODO this basically inlines `gptel-org-set-topic'. Unfortunately,
  ;; there doesn't seem to be a good way to call that here and use the
  ;; default value.
  (org-set-property "GPTEL_TOPIC" (downcase
                                   (truncate-string-to-width
                                    (substring-no-properties
                                     (replace-regexp-in-string
                                      "\\s-+" "-"
                                      (org-entry-get nil "ITEM")))
                                    50)))
  (funcall-interactively 'org-insert-heading-respect-content)
  (funcall-interactively 'org-demote-subtree)
  (insert "question"))

;; TODO add a function to normalize heading level of responses
;; (perhaps just as simple as demoting level 2 to 4, while also
;; demoting subheadings in a corresponding way).

;; TODO add a function to normalize whitespace around headings in org
;; buffers. This should remove whitespace between a heading and
;; subsequent text, while preserving a newline between the content of
;; a section and the subsequent newline. It should also remove
;; extraneous newlines between unpopulated sections. This should go in
;; c-org itself and maybe be added as a save hook.

(provide 'c-gptel)
;;; c-gptel.el ends here
