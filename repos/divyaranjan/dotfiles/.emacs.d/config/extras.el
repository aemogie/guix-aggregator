;; extras.el --- Divya's Emacs Extras Config --- -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;;; sx.el : Stack Exchange on Emacs

(use-package sx
  :straight t
  :config
  (bind-keys :prefix "C-c s"
	     :prefix-map divya-sx-map
	     :prefix-docstring "Global keymap for sx"
	     ("i" . sx-inbox)
             ("o" . sx-open-link)
             ("u" . sx-tab-unanswered-my-tags)
             ("a" . sx-ask)
             ("s" . sx-search)
	     (";" . sx-tab-switch)
	     ("*" . sx-star)
	     ("m" . sx-tab-month)
	     ("x" . sx-tab-meta-or-main)
	     ("w" . sx-tab-week)
	     ("q" . sx-tab-all-questions)
	     ("f" . sx-tab-frontpage)
	     ("c" . sx-comment)
	     ("^" . sx-upvote)
	     ("d" . sx-display-question)))

;;; Finally, get your favorite Emacs everywhere!

(use-package emacs-everywhere
  :straight t)

;;; YouTube/MPV from Emacs empv.el

(use-package empv
  :ensure t
  :straight (:host github :repo "isamert/empv.el")
  :config
  (bind-key "C-x m" empv-map)
  (with-eval-after-load 'embark (empv-embark-initialize-extra-actions))
  (setq empv-invidious-instance "https://invidious.rocks/api/v1")
  (add-to-list 'empv-mpv-args "--ytdl-format=best" "--save-position-on-quit"))

;;; Emacs Easy Draw
(use-package el-easydraw
  :straight (:host github :repo "misohena/el-easydraw")
  :after org)


(with-eval-after-load 'org
  (require 'edraw-org)
  (edraw-org-setup-default))
(with-eval-after-load "ox"
  (require 'edraw-org)
  (edraw-org-setup-exporter))


;;; EMMS

;; (use-package emms
;;   :straight t
;;   :config
;;   (emms-all))

;;; Screenshots within Emacs

(defun self-screenshot (&optional type)
  "Save a screenshot of type TYPE of the current Emacs frame.
As shown by the function `', type can weild the value `svg',
`png', `pdf'.

This function will output in /tmp a file beginning with \"Emacs\"
and ending with the extension of the requested TYPE."
  (interactive)
  (let* ((type (if type type
		 (intern (completing-read "Screenshot Type: "
					  '(png svg pdf postscript)))))
	 (extension (pcase type
		      ('png        ".png")
		      ('svg        ".svg")
		      ('pdf        ".pdf")
		      ('postscript ".ps")
		      (otherwise (error "Cannot export screenshot of type %s" otherwise))))
	 (filename (make-temp-file "Emacs-" nil extension))
	 (data     (x-export-frames nil type)))
    (with-temp-file filename
      (insert data))
    (kill-new filename)
    (message filename)))

(global-set-key (kbd "C-x M-s") 'self-screenshot)

;;; Ripgrep

(use-package rg
  :straight t)


;;;  Fuzzy finding
(use-package fzf
  :straight t)

;;; Finding across files
(use-package elgrep
  :straight t
  :bind ("C-M-g" . elgrep))

;;; Emacs Speaks Statistics (ESS)
(use-package ess
  :straight t)

;; Clocking time (aka stopwatch) in Emacs
(require 'timeclock)
; Show the time elapsed in mode-line
(setq timeclock-use-elapsed t)
(timeclock-mode-line-display)

(define-key global-map (kbd "C-c C-t i") 'timeclock-in)
(define-key global-map (kbd "C-c C-t o") 'timeclock-out)
(define-key global-map (kbd "C-c C-t c") 'timeclock-change)
(define-key global-map (kbd "C-c C-t r") 'timeclock-reread-log)
(define-key global-map (kbd "C-c C-t u") 'timeclock-update-mode-line)
(define-key global-map (kbd "C-c C-t w") 'timeclock-when-to-leave-string)

;; Emacs Tip of the Day

(require 'cl)
(defun totd ()
  (interactive)
  (with-output-to-temp-buffer "*Tip of the day*"
    (let* ((commands (cl-loop for s being the symbols
                           when (commandp s) collect s))
           (command (nth (random (length commands)) commands)))
      (princ
       (concat "Your tip for the day is:\n========================\n\n"
               (describe-function command)
               "\n\nInvoke with:\n\n"
               (with-temp-buffer
                 (where-is command t)
                 (buffer-string)))))))

(add-hook 'after-init-hook 'totd)

;; Dictionary in Emacs

(define-key global-map (kbd "M-#") 'dictionary-search)

(setq dictionary-server "dict.org")

(setq switch-to-buffer-obey-display-actions t)
(add-to-list 'display-buffer-alist
   '("^\\*Dictionary\\*" display-buffer-in-side-window
     (side . right)
     (window-width . 70)))

;; Encryption in Emacs
(require 'epa-file)
(epa-file-enable)

;; UNIX Pass in Emacs
(use-package with-editor
  :straight t)
(require 'password-store)
(define-key global-map (kbd "C-c p c") 'password-store-copy)
(define-key global-map (kbd "C-c p C") 'password-store-clear)
(define-key global-map (kbd "C-c p r") 'password-store-rename)
(define-key global-map (kbd "C-c p e") 'password-store-edit) ; Press C-x # when done to save it.
(define-key global-map (kbd "C-c p g") 'password-store-generate)
(define-key global-map (kbd "C-c p i") 'password-store-insert)

;; Deleting trailing whitespace before saving

(add-hook 'before-save-hook
	  #'delete-trailing-whitespace)

;; Some koans every hour

;; (defun divya/moments ()
;;   (interactive)
;;    (notifications-notify
;;     :title "Moments"
;;     :body "You do not have a head."))

;; (run-with-timer 0 (* 60 60) 'divya/moments)

;; To explore bugs in GNU projects
(use-package debbugs
  :straight t)

;; Hi-lock (Minor-mode for interactive highlighting in any Emacs buffer)

(global-hi-lock-mode 1)
(setq hi-lock-file-patterns-policy #'(lambda (dummy) t))


;;; Element in Emacs

(use-package ement
  :straight t
  :bind
  ("C-c C-r" . ement-room-send-reaction))

;;; Mastodon in Emacs

(use-package mastodon
  :straight t
  :hook (mastodon-mode . mastodon-async-mode)
  :config
  (setq mastodon-instance-url "https://mathstodon.xyz"
	mastodon-active-user "divyaranjan"
	mastodon-toot--enable-custom-instance-emoji t
	mastodon-use-emojify t))

;; Jabber/XMPP in Emacs

(use-package jabber
  :straight t
  :defer t
  :config
  (setq jabber-account-list '("divya@conversations.im")))


;;; TMSU tagging interaction in Emacs

(use-package tmsu
  :straight t)

(provide 'extras)

;;; extras.el ends here
