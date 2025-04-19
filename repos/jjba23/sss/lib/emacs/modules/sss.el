;;; sss.el --- SSS configuration for Emacs -*- lexical-binding: t -*-

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

;; SSS configuration for Emacs

;;; Code:

(defgroup sss ()
  "SSS customization group."
  :group 'tools)

(defcustom sss-font-mono "Adwaita Mono"
  "My personal choice for monospaced font family." 
  :type 'string)

(defcustom sss-font-sans "Inter"
  "My personal choice for sans font family." 
  :type 'string)

(defcustom sss-ews-music-directory "~/Muziek"
  "My personal main directory where to read music from."
  :type 'string)

(defcustom sss-clone-dir nil
  "The directory where the SSS (Supreme Sexp System) source code is located."
  :type 'string)

(defcustom sss-notes-roam-dir nil
  "The directory where the Org roam notes should be stored."
  :type 'string)

(defcustom sss-emacs-theme nil
  "The name of the Emacs theme to use, acording to SSS palette."
  :type 'symbol)

(defun sss-joe-reconfigure ()
  "Rebuild GNU Guix Joe's configs."
  (interactive)
  (let ((default-directory (string-replace "$HOME" "~" sss-clone-dir)))
    (async-shell-command "make jr")))

(defun sss-publish-manual ()
  "Rebuild GNU Guix Joe's config manual."
  (interactive)
  (let ((default-directory (string-replace "$HOME" "~" sss-clone-dir)))
    (async-shell-command "make publish-manual")))

(defun sss-full-reconfigure ()
  "Fully Rebuild GNU Guix Joe's configs and Joe's user."
  (interactive)
  (let ((default-directory (string-replace "$HOME" "~" sss-clone-dir)))
    (async-shell-command "make fr")))

(defun sss-sys-reconfigure ()
  "Rebuild GNU Guix Joe's configs."
  (interactive)
  (let ((default-directory (string-replace "$HOME" "~" sss-clone-dir)))
    (async-shell-command "make sr")))

(defun sss-sys-update ()
  "Update GNU Guix packages."
  (interactive)
  (let ((default-directory (string-replace "$HOME" "~" sss-clone-dir)))
    (async-shell-command "make update")))

(defun sss-uuidgen ()
  (interactive)
  (let ((uid (string-replace "\n" "" (shell-command-to-string "uuidgen"))))
    (message (format "generated UUID: %s" uid))
    (kill-new uid)))

(defun sss-uuidgen-string ()
  (string-replace "\n" "" (shell-command-to-string "uuidgen")))

(defun sss-guix-fmt ()
  (interactive)
  (let ((path (file-truename buffer-file-name)))
    (message "formatting current buffer with Guix style")
    (shell-command (format "guix style -f %s" path))
    (revert-buffer :ignore-auto :noconfirm)
    (message "formatted current buffer with Guix style")))

(defun sss-new-buffer-with-json (buffer-name data)
  (get-buffer-create buffer-name)
  (with-current-buffer buffer-name
    (insert data)
    (ignore-errors
      (js-json-mode)
      (json-pretty-print-buffer-ordered)))
  (switch-to-buffer buffer-name)
  (scroll-down 10000))

(provide 'sss/sss)

;;; sss.el ends here
