;;; mail.el --- Mail configuration for Emacs -*- lexical-binding: t -*-

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Mail configuration for Emacs

;;; Code:

(use-package gnus
  :ensure nil
  :bind (("C-c o m" . gnus))
  :config
  (setq gnus-use-cache t
        gnus-asynchronous t
        gnus-use-header-prefetch t)
  (setq gnus-sum-thread-tree-false-root " "
        gnus-sum-thread-tree-indent "  "
        gnus-sum-thread-tree-root "r "
        gnus-sum-thread-tree-single-indent "◎ "
        gnus-sum-thread-tree-vertical        "|"
        gnus-sum-thread-tree-leaf-with-other "├─► "
        gnus-sum-thread-tree-single-leaf     "╰─► "

        ;; │06-Jan│  Sender Name  │ Email Subject
        gnus-summary-line-format (concat "%0{%U%R%z%}"
                                         "%3{│%}" "%1{%d%}" "%3{│%}"
                                         "  "
                                         "%4{%-20,20f%}"
                                         "  "
                                         "%3{│%}"
                                         " "
                                         "%1{%B%}"
                                         "%s\n"))
  (setq gnus-thread-sort-functions
        '(gnus-thread-sort-by-most-recent-date
          (not gnus-thread-sort-by-number))))

(use-package smtpmail
  :ensure nil
  :config
  (setq send-mail-function 'smtpmail-send-it
        smtpmail-debug-info t
        smtpmail-debug-verb t))

(provide 'sss/mail)

;;; mail.el ends here
