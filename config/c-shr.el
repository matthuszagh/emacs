;;; c-shr.el ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(if (featurep 'straight)
    (straight-use-package 'shr))

(require 'shr)

;; use monospaced rather than proportional fonts
(setq shr-use-fonts nil)
(setq shr-use-colors nil)
;; don't limit window and character width
(setq shr-width nil)
(setq shr-max-width nil)

;; TODO integrate into some acceptable PR upstream
;;
;; I've commented out the inserts in both functions that control
;; this. One insert is used before the image and the other is
;; after. Lars
;; [[https://debbugs.gnu.org/cgi/bugreport.cgi?bug=47705#8][has made
;; it abundantly clear]] that he won't accept a PR that removes these,
;; or even makes removal configurable since he feels strongly that
;; large inline images is wrong behavior. What he wants is something
;; that conditionally inlines images when they are sufficiently
;; small. I'm not entirely sure I agree, but this should be doable.
(defun mh/shr-tag-img (dom &optional url)
  (when (or url
	    (and dom
		 (or (> (length (dom-attr dom 'src)) 0)
                     (> (length (dom-attr dom 'srcset)) 0))))
    ;; (when (> (current-column) 0)
    ;;   (insert "\n"))
    (let ((alt (dom-attr dom 'alt))
          (width (shr-string-number (dom-attr dom 'width)))
          (height (shr-string-number (dom-attr dom 'height)))
	  (url (shr-expand-url (or url (shr--preferred-image dom)))))
      (let ((start (point-marker)))
	(when (zerop (length alt))
	  (setq alt "*"))
	(cond
         ((null url)
          ;; After further expansion, there turned out to be no valid
          ;; src in the img after all.
          )
	 ((or (member (dom-attr dom 'height) '("0" "1"))
	      (member (dom-attr dom 'width) '("0" "1")))
	  ;; Ignore zero-sized or single-pixel images.
	  )
	 ((and (not shr-inhibit-images)
	       (string-match "\\`data:" url))
	  (let ((image (shr-image-from-data (substring url (match-end 0)))))
	    (if image
		(funcall shr-put-image-function image alt
                         (list :width width :height height))
	      (insert alt))))
	 ((and (not shr-inhibit-images)
	       (string-match "\\`cid:" url))
	  (let ((url (substring url (match-end 0)))
		image)
	    (if (or (not shr-content-function)
		    (not (setq image (funcall shr-content-function url))))
		(insert alt)
	      (funcall shr-put-image-function image alt
                       (list :width width :height height)))))
	 ((or shr-inhibit-images
	      (and shr-blocked-images
		   (string-match shr-blocked-images url)))
	  (setq shr-start (point))
          (shr-insert alt))
	 ((and (not shr-ignore-cache)
	       (url-is-cached (shr-encode-url url)))
	  (funcall shr-put-image-function (shr-get-image-data url) alt
                   (list :width width :height height)))
	 (t
	  (when (and shr-ignore-cache
		     (url-is-cached (shr-encode-url url)))
	    (let ((file (url-cache-create-filename (shr-encode-url url))))
	      (when (file-exists-p file)
		(delete-file file))))
          (when (image-type-available-p 'svg)
            (insert-image
             (shr-make-placeholder-image dom)
             (or alt "")))
          (insert " ")
	  (url-queue-retrieve
           (shr-encode-url url) #'shr-image-fetched
	   (list (current-buffer) start (set-marker (make-marker) (point))
                 (list :width width :height height))
	   t
           (not (shr--use-cookies-p url shr-base)))))
	(when (zerop shr-table-depth) ;; We are not in a table.
	  (put-text-property start (point) 'keymap shr-image-map)
	  (put-text-property start (point) 'shr-alt alt)
	  (put-text-property start (point) 'image-url url)
	  (put-text-property start (point) 'image-displayer
			     (shr-image-displayer shr-content-function))
	  (put-text-property start (point) 'help-echo
			     (shr-fill-text
			      (or (dom-attr dom 'title) alt))))))))

(advice-add 'shr-tag-img :override #'mh/shr-tag-img)

(defun mh/shr-insert (text)
  (when (and (not (bolp))
	     (get-text-property (1- (point)) 'image-url))
    ;;(insert "\n")
    )
  (cond
   ((eq shr-folding-mode 'none)
    (let ((start (point)))
      (insert text)
      (save-restriction
	(narrow-to-region start (point))
        (shr--translate-insertion-chars)
	(goto-char (point-max)))))
   (t
    (let ((font-start (point)))
      (when (and (string-match "\\`[ \t\n\r]" text)
		 (not (bolp))
		 (not (eq (char-after (1- (point))) ? )))
	(insert " "))
      (let ((start (point))
	    (bolp (bolp)))
	(insert text)
	(save-restriction
	  (narrow-to-region start (point))
	  (goto-char start)
	  (when (looking-at "[ \t\n\r]+")
	    (replace-match "" t t))
	  (while (re-search-forward "[\t\n\r]+" nil t)
	    (replace-match " " t t))
	  (goto-char start)
          (while (re-search-forward "  +" nil t)
            (replace-match " " t t))
          (shr--translate-insertion-chars)
	  (goto-char (point-max)))
	;; We may have removed everything we inserted if it was just
	;; spaces.
	(unless (= font-start (point))
	  ;; Mark all lines that should possibly be folded afterwards.
	  (when bolp
	    (shr-mark-fill start))
	  (when shr-use-fonts
	    (put-text-property font-start (point)
			       'face
			       (or shr-current-font 'variable-pitch)))))))))

(advice-add 'shr-insert :override #'mh/shr-insert)

(provide 'c-shr)
;;; c-shr.el ends here
