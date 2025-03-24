(require 'gnus)
(require 'nnrss)
(require 'nnimap)

(setq user-mail-address "divya@subvertising.org"
      user-full-name "Divya Ranjan")

(setq gnus-select-method '(nnnil ""))

;; Mail
(setq gnus-select-method
      '(nnimap "divya-autistici"
		(directory "/mnt/LDisk-D/email/autistici")
		(nnimap-address "mail.autistici.org") ;; Replace with your IMAP server
		(nnimap-server-port 993)))

(setq fast-read-process-output nil)
(setq gnus-search-use-imap t)

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-smtp-server "smtp.autistici.org"
      smtpmail-stream-type 'ssl
      smtpmail-auth-credentials "~/.authinfo.gpg"
      smtpmail-smtp-service 465)

;; For RSS Feeds
;; (add-to-list 'gnus-secondary-select-methods '(nnrss ""))
(setq gnus-secondary-select-methods '(
				      (nntp "news.gmane.io"
					    (nntp-open-connection-function nntp-open-network-stream)
					    (nntp-connection-timeout 5))
				      (nntp "feedbase"
					    (nntp-open-connection-function nntp-open-tls-stream)
					    (nntp-address "feedbase.org")
					    (nntp-connection-timeout 5)
					    (nntp-port-number 563))))

;;; Gnus Agent
(setq gnus-agent t)
(setq gnus-agent-plugged t)
(setq gnus-agent-queue-mail t)
(setq gnus-agent-auto-agentize-methods
      '((nnimap "divya-autistici")
	(nntp "feedbase")
	(nntp "news.gmane.io")
	(nntp "news.gwene.org")))
(setq gnus-agent-fetch-selected-article 'fetch)
(setq gnus-agent-enable-expiration t)
(setq gnus-agent-cache t)
(setq gnus-agent-go-online t)
(setq gnus-agent-always-agent t)

(setq gnus-agent-directory "/mnt/LDisk-D/email/")

;; Async and Fetching
(setq gnus-asynchronous t)
(setq gnus-use-article-prefetch 50)
(setq gnus-fetch-old-headers 100)
(setq gnus-parameters
      '(("INBOX"
	 (gnus-fetch-old-headers 100))))

(setq gnus-large-newsgroup 1000)


;; Groups

;;; Gnus Demon
(require 'gnus-demon)
(setq gnus-check-mail t)
(setq gnus-use-demon t)
(defun divya/gnus-demon-fetch ()
  (interactive)
  (gnus-demon-scan-mail)
  ;; (gnus-group-get-new-news)
  (gnus-demon-scan-news)
  (message "Mail and news scanned from the Gnus demon at %s" (current-time-string)))
;; (gnus-demon-add-handler #'divya/gnus-demon-fetch 10 nil)
;; (gnus-demon-init)

;; (setq gnus-plugged nil)
;; (defun divya/gnus-fetch-all
;;     "Fetch everything, mail and news."
;;   (gnus-group-get-new-news)
;;   (gnus-demon-scan-news))
;; (gnus-demon-add-handler 'gnus-demon-scan-news 21600 t)
;; (gnus-demon-add-handler 'gnus-demon-scan-news 600 nil)
;; (setq gnus-newsrc-alist
;;       '((nnimap+divya-autistici "INBOX")
;; 	(nnimap+divya-autistici "Sent")))
;; (setq gnus-read-active-file nil)

(defun divya/gnus-check ()
  (interactive)
  "create new thread for check"
  (make-thread (lambda ()
		 (gnus-group-get-new-news))))

;;;; UI of Gnus

;; Group Buffer
(defun divya/gnus-group-display ()
  (setq left-margin-width 20)
  (setq right-margin-width 20)

  (set-window-buffer nil (current-buffer)))

;; Group Names
(setq group-name-map '(("nnimap+divya-autistici:INBOX" . "Inbox")
		       ("nnimap+divya-autistici:Sent" . "Sent")
		       ("nnimap+divya-autistici:Spam" . "Spam")
		       ("nnimap+divya-autistici:Trash" . "Trash")
		       ("nnimap+divya-autistici:Drafts" . "Drafts")))

(setq gnus-group-line-format "%M%S%5y/%-5t: %uG %D\n")

(defun gnus-user-format-function-G (arg)
  (let ((mapped-name (assoc gnus-tmp-group group-name-map)))
    (if (null mapped-name)
        gnus-tmp-group
      (cdr mapped-name))))

;; Summary Buffer
(setq gnus-summary-line-format "%U%R%z %d %I%-30,30n %I%-120,120s\n")

(setq gnus-thread-indent-level 2)  ;; Adjust indentation level for deeper threads
(setq truncate-lines nil)  ;; Allows horizontal scrolling

(defun divya/gnus-summary-display ()
  (setq left-margin-width 6   ;; Set left margin width
        right-margin-width 6) ;; Set right margin width

  (set-window-buffer nil (current-buffer)))

;; Sorting
(setq gnus-thread-sort-functions
	'((not gnus-thread-sort-by-date)
	  (not gnus-thread-sort-by-number)))

;; Hooks
(add-hook 'message-mode-hook 'turn-off-auto-fill)
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
(add-hook 'gnus-group-mode-hook #'divya/gnus-group-display)
(add-hook 'gnus-summary-mode-hook #'divya/gnus-summary-display)
