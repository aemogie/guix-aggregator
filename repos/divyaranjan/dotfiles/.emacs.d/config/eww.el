;;; eww.el --- Eww Configuration File --- -*- lexical-binding: t -*-
;;; Commentary:
;;; Divya's Emacs Browser Config file

;;; Code:

(require 'eww)
(require 'browse-url)

;; `browse-url'
(setq browse-url-browser-function 'eww-browse-url)
(setq browse-url-secondary-browser-function 'browse-url-default-browser)

;;; `goto-addr'
(setq goto-address-url-face 'link)
(setq goto-address-url-mouse-face 'highlight)
(setq goto-address-mail-face nil)
(setq goto-address-mail-mouse-face 'highlight)

;;; `shr'

(setq shr-use-colors t)             ; t is bad for accessibility
(setq shr-use-fonts t)              ; t is not for me
(setq shr-max-width 400)
(setq shr-width 600)
(setq shr-max-image-proportion 0.6)
(setq shr-image-animate t)          ; No GIFs, thank you!
(setq shr-max-width fill-column)
(setq shr-discard-aria-hidden t)
(setq shr-cookie-policy nil)

;;; eww

(setq eww-restore-desktop t)
(setq eww-desktop-remove-duplicates t)
(setq eww-header-line-format nil)
(setq eww-search-prefix "https://duckduckgo.com/html/?q=")
(setq eww-download-directory (expand-file-name "~/Downloads/eww/"))
(setq eww-suggest-uris
      '(eww-links-at-point
        thing-at-point-url-at-point))
(setq eww-bookmarks-directory (locate-user-emacs-file "eww-bookmarks/"))
(setq eww-history-limit 150)
(setq eww-use-external-browser-for-content-type
      "\\`\\(video/\\|audio\\)") ; On GNU/Linux check your mimeapps.list
(setq eww-browse-url-new-window-is-tab nil)
(setq eww-form-checkbox-selected-symbol "[X]")
(setq eww-form-checkbox-symbol "[ ]")
;; NOTE `eww-retrieve-command' is for Emacs28.  I tried the following
;; two values.  The first would not render properly some plain text
;; pages, such as by messing up the spacing between paragraphs.  The
;; second is more reliable but feels slower.  So I just use the
;; default (nil), though I find wget to be a bit faster.  In that case
;; one could live with the occasional errors by using `eww-download'
;; on the offending page, but I prefer consistency.
;;
;; '("wget" "--quiet" "--output-document=-")
;; '("chromium" "--headless" "--dump-dom")
(setq eww-retrieve-command nil)

;; (define-key eww-link-keymap (kbd "v") nil) ; stop overriding `eww-view-source'
;; (define-key eww-mode-map (kbd "L") #'eww-list-bookmarks)
;; (define-key dired-mode-map (kbd "E") #'eww-open-file) ; to render local HTML files
;; (define-key eww-buffers-mode-map (kbd "d") #'eww-bookmark-kill)   ; it actually deletes
;; (define-key eww-bookmark-mode-map (kbd "d") #'eww-bookmark-kill)) ; same


;; (use-package shrface
;;   :straight t
;;   :config
;;   (shrface-basic)
;;   (shrface-trial)
;;   (shrface-default-keybindings)
;;   (setq shrface-href-versatile t))

;; (use-package eww
;;   :straight t
;;   :init
;;   (add-hook 'eww-after-render-hook #'shrface-mode)
;;   :config
;;   (require 'shrface))


;; (add-hook 'eww-mode-hook #'divya/enable-focus)


;; (setq browse-url-generic-program "librewolf")

;;; Search Engines
;; Wikipedia

(defun search-wiki ()
  "Search the TERM entered in Wikipedia.
If there is a phrase is marked, search that."
  (interactive)
  (let ((word (read-string "Wiki: ")))
    (eww (concat "http://en.wikipedia.org/wiki/" word))))

(defun search-libgen ()
  "Search the PHRASE entered in Library Genesis.
If there is a phrase is marked, search that."
  (interactive)
  (let (term (read-string "LibGen: "))
    (eww (concat "https://libgen.li/index.php?req=" word))))

(define-key global-map (kbd "C-x M-w") 'search-wiki)
(define-key global-map (kbd "C-x M-l") 'search-libgen)

(provide 'eww)
;;; eww.el ends here
