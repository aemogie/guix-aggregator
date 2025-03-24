;;; books.el --- E-book Configuration File --- -*- lexical-binding: t -*-
;;; Commentary:
;;; Divya's Emacs E-reading Config file

;;; Code:

;; ;; PDF in Emacs
;; (use-package pdf-tools
;;   ;; :straight '(pdf-tools :location (recipe
;;   ;; 				   :fetcher github
;;   ;; 				   :repo "dalanicolai/pdf-tools"
;;   ;; 				   :branch "pdf-roll"
;;   ;; 				   :files ("lisp/*.el"
;;   ;; 					   "README"
;;   ;; 					   ("build" "Makefile")
;;   ;; 					   ("build" "server")
;;   ;; 					   (:exclude "lisp/tablist.el" "lisp/tablist-filter.el"))))
;;   :straight t
;; ;  :pin manual
;;   :config
;;   (pdf-tools-install)
;;   ;;   (display-line-numbers-mode-1)
;;   :custom
;;   (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

(require 'pdf-tools)
(setq-default pdf-view-display-size 'fit-page)
(define-key pdf-view-mode-map (kbd "C-,") 'pdf-view-goto-page)
(define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)

(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
(add-hook 'pdf-view-mode-hook 'pdf-annot-minor-mode)

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
	  #'TeX-revert-document-buffer)

;; Some `pdf-tools` tweaks

(setq pdf-cache-image-limit 200)
(setq pdf-cache-prefetch-delay 1)
(setq pdf-cache--prefetch-pages 50)
(setq image-cache-eviction-delay 2)


(defun d/kill-buffer ()
  "Clear the image cache (releasing memory after a pdf buffer is killed)"
  (interactive)
  (kill-buffer)
  (delete-window)
  (clear-image-cache t)
  (pdf-cache-clear-data))

;; Pick up PDF where I left it

;; (use-package pdf-view-restore
;;   :straight t
;;   :hook (pdf-view-mode . pdf-view-restore-mode)
;;   :config
;;   (setq pdf-view-restore-filename  "~/.emacs.d/pdf-view-restore"))

(define-key pdf-view-mode-map (kbd "H") 'pdf-view-fit-height-to-window)
(define-key pdf-view-mode-map (kbd "W") 'pdf-view-fit-width-to-window)
(define-key pdf-view-mode-map (kbd "o") 'pdf-outline)

(use-package saveplace
  :straight t)

(require 'saveplace-pdf-view)

(use-package org-noter
  :straight t
  :bind
  ("C-c C-n o" . org-noter)
  ("C-c C-n i" . org-noter-insert-note)
  ("C-c C-n p" . org-noter-insert-precise-note)
  ("C-c C-n k" . org-noter-sync-prev-note)
  ("C-c C-n j" . org-noter-sync-next-note)
  ("C-c C-n s" . org-noter-create-skeleton)
  ("C-c C-n q" . org-noter-kill-session)

  :config
  (setq
   ;; The WM can handle splits
   ;org-noter-notes-window-location 'other-frame

   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   org-noter-notes-search-path '("~/notes/org/org-roam/" "~/notes/org/org-roam/ref/")
   org-noter-separate-notes-from-heading t
   org-noter-default-heading-title "Page $p$"
   org-noter-auto-save-last-location t
   org-noter-doc-property-in-notes t)


  (setq org-noter-property-doc-file "INTERLEAVE_PDF"
      org-noter-property-note-location "INTERLEAVE_PAGE_NOTE"))

;; More pdf-tools & org-noter stuff
;; (use-package org-pdftools
;;   :hook (org-mode . org-pdftools-setup-link))

;; (use-package org-noter-pdftools
;;   :after org-noter
;;   :config
;;   ;; Add a function to ensure precise note is inserted
;;   (defun org-noter-pdftools-insert-precise-note (&optional toggle-no-questions)
;;     (interactive "P")
;;     (org-noter--with-valid-session
;;      (let ((org-noter-insert-note-no-questions (if toggle-no-questions
;;                                                    (not org-noter-insert-note-no-questions)
;;                                                  org-noter-insert-note-no-questions))
;;            (org-pdftools-use-isearch-link t)
;;            (org-pdftools-use-freepointer-annot t))
;;        (org-noter-insert-note (org-noter--get-precise-info)))))

;;   ;; fix https://github.com/weirdNox/org-noter/pull/93/commits/f8349ae7575e599f375de1be6be2d0d5de4e6cbf
;;   (defun org-noter-set-start-location (&optional arg)
;;     "When opening a session with this document, go to the current location.
;; With a prefix ARG, remove start location."
;;     (interactive "P")
;;     (org-noter--with-valid-session
;;      (let ((inhibit-read-only t)
;;            (ast (org-noter--parse-root))
;;            (location (org-noter--doc-approx-location (when (called-interactively-p 'any) 'interactive))))
;;        (with-current-buffer (org-noter--session-notes-buffer session)
;;          (org-with-wide-buffer
;;           (goto-char (org-element-property :begin ast))
;;           (if arg
;;               (org-entry-delete nil org-noter-property-note-location)
;;             (org-entry-put nil org-noter-property-note-location
;;                            (org-noter--pretty-print-location location))))))))
;;   (with-eval-after-load 'pdf-annot
;;     (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

;;; EPUBs in Emacs : Nov mode
(defun nov-font-setup ()
  (face-remap-add-relative 'variable-pitch :family "ETbb"
			   :height 1.8))

(use-package nov
  :straight t
  :hook
  (nov-mode-hook . nov-font-setup)
  (nov-mode-hook . divya/enable-focus)
  ;; (nov-mode-hook #'shrface-mode)

  :custom
  (setq nov-unzip-program (executable-find "bsdtar")
	nov-unzip-args '("-xC" directory "-f" filename))

  :config
  ;; (setq nov-shr-rendering-functions '((img . nov-render-img) (title . nov-render-title)))
  ;; (setq nov-shr-rendering-functions (append nov-shr-rendering-functions shr-external-rendering-functions))
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; Justifying

(defun divya/nov-window-configuration-change-hook ()
  (divya/nov-post-html-render-hook)
  (remove-hook 'window-configuration-change-hook
	       'divya/nov-window-configuration-change-hook
	       t))

(defun divya/nov-post-html-render-hook ()
  (if (get-buffer-window)
      (let ((max-width (pj-line-width))
            buffer-read-only)
        (save-excursion
          (goto-char (point-min))
          (while (not (eobp))
            (when (not (looking-at "^[[:space:]]*$"))
	      (goto-char (line-end-position))
	      (when (> (shr-pixel-column) max-width)
                (goto-char (line-beginning-position))
                (pj-justify)))
            (forward-line 1))))
    (add-hook 'window-configuration-change-hook
	      'divya/nov-window-configuration-change-hook
	      nil t)))

(setq nov-text-width 185)
(setq visual-fill-column-center-text t)

(add-hook 'nov-post-html-render-hook 'divya/nov-post-html-render-hook)

;; DJVUs in Emacs
(use-package djvu
  :straight t)


;;; Handling multi-file writing systems

(use-package binder
  :straight t)

(provide 'books)
;;; books.el ends here
