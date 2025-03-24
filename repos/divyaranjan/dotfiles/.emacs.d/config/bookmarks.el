;;; bookmarks.el --- Bookmarks Configuration File --- -*- lexical-binding: t -*-
;;; Commentary:
;;; Divya's Emacs Bookmarking Config file

;;; Code:

;; (setq bookmark-default-file "~/.dotfiles/.emacs.d/bookmarks")

(global-set-key (kbd "C-x r b") 'consult-bookmark)

(require 'bookmark+)

;; Workaround for opening pdf-tool bookmarks with bookmark+
;; https://emacs.stackexchange.com/questions/72786/bookmark-plus-and-pdf-tools-pdf-view-error/72929

(defun my-bmk-pdf-handler-advice (bookmark)
  (bookmark-default-handler (bookmark-get-bookmark bookmark)))

(advice-add 'pdf-view-bookmark-jump-handler
            :after 'my-bmk-pdf-handler-advice)

;; Save bookmarks periodically

(run-with-timer 0 (* 60 60) 'bookmark-save)


(provide 'bookmarks)
;;; bookmarks.el ends here
