;; irc.el --- Divya's Emacs IRC Config --- -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;;; ERC

(require 'erc)

;;; ERC
(require 'erc)
;; Server configurations
;; (erc-tls :server "irc.libera.chat"
;; 	 :nick "divya")

(setopt erc-modules
	(seq-union '(nicks scrolltobottom)
		   erc-modules))

;; Rebinding 'send' to something other than RET.
(define-key erc-mode-map (kbd "C-c C-c") 'erc-send-current-line)

;; Prevent from being notified for joining and other stuff
(require 'erc-track)
(setopt erc-track-faces-priority-list
	(remq 'erc-notice-face erc-track-faces-priority-list))

(setq erc-server "oracle.vivekkadre.com:1025"
      erc-nick "divya"
      erc-user-full-name "Divya Ranjan"
      erc-track-shorten-start 8)

(setq rcirc-server "oracle.vivekkadre.com:1025"
      rcirc-default-nick "divya"
      rcirc-default-full-name "Divya Ranjan")

(setq rcirc-server-alist '(("oracle.vivekkadre.com" :port 1025 :encryption tls)))

;; (add-hook 'erc-mode-hook 'erc-nickbar-mode)

(provide 'irc)
;;; irc.el ends here
