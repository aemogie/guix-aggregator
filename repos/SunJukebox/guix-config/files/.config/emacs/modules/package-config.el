;;; package-config.el --- Set up package.el and use-package  -*- lexical-binding: t; -*-
;;; Commentary:
;; 
;;; Code:

;; Set up package archives (configuring `package.el')
;; (load "$HOME/src/crafted-emacs/modules/crafted-early-init-config")
(require 'package)

;;; Setup Emacs Lisp Package Archives (ELPAs)
;; where to get packages to install
(when (version< emacs-version "28")
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(add-to-list 'package-archives '("stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;; Configure ELPA priorities
;; Prefer GNU sources and stable versions before development versions from MELPA.
(customize-set-variable 'package-archive-priorities
                        '(("gnu"    . 99)   ; prefer GNU packages
                          ("nongnu" . 80)   ; use non-gnu packages if
                                        ; not found in GNU elpa
                          ("stable" . 70)   ; prefer "released" versions
                                        ; from melpa
                          ("melpa"  . 0)))  ; if all else fails, get it
                                        ; from melpa

;;; Forms to refresh package archive contents
;; These functions are available to use for deciding if
;; `package-refresh-contents' needs to be run during startup.  As this
;; can slow things down, it is only run if the archives are considered
;; stale.  Archives are considered stale (by default) when they are 1
;; day old.
(require 'time-date)

(defvar onghaik/package-perform-stale-archive-check t
  "Check if any package archives are stale.")

(defvar onghaik/package-update-days 1
  "Number of days before an archive will be considered stale.")

(defun onghaik/package-archive-stale-p (archive)
  "Return t if ARCHIVE is stale.

ARCHIVE is stale if the on-disk cache is older than
`onghaik/package-update-days' old.  If
`onghaik/package-perform-stale-archive-check' is nil, the check
is skipped"
  (let* ((today (decode-time nil nil t))
         (archive-name (expand-file-name
                        (format "archives/%s/archive-contents" archive)
                        package-user-dir))
         (last-update-time (decode-time (file-attribute-modification-time
                                         (file-attributes archive-name))))
         (delta (make-decoded-time :day onghaik/package-update-days)))
    (when onghaik/package-perform-stale-archive-check
      (time-less-p (encode-time (decoded-time-add last-update-time delta))
                   (encode-time today)))))

(defun onghaik/package-archives-stale-p ()
  "Return t if any package archives' cache is out of date.

Check each archive listed in `package-archives', if the on-disk
cache is older than `onghaik/package-update-days', return a
non-nil value.  Fails fast, will return t for the first stale
archive found or nil if they are all up-to-date"
  (interactive)
  (cl-some #'onghaik/package-archive-stale-p (mapcar #'car package-archives)))

(defun onghaik/package-initialize ()
  "Initialize the package system.

Run this in the `before-init-hook'"

  (when package-enable-at-startup
    (package-initialize)

    (require 'seq)
    (message "onghaik/package-config: checking package archives")
    (cond ((seq-empty-p package-archive-contents)
           (progn
             (message "onghaik/package-config: package archives empty, initalizing")
             (package-refresh-contents)))
          ((onghaik/package-archives-stale-p)
           (progn
             (message "onghaik/package-config: package archives stale, refreshing")
             (package-refresh-contents t))))
    (message "onghaik/package-config: package system initialized!")))

;;; Initialize package system
;; Refresh archives if necessary before init file runs.
(add-hook 'before-init-hook #'onghaik/package-initialize)

;; (unless (package-installed-p 'use-package)
;;   (package-install 'use-package))
;; (require 'use-package)

;; Automatically install packages when not in Guix
;; (setq use-package-always-ensure (not anon/is-guix-system))

;; Never load a package until demanded or triggered
;; (setq use-package-always-defer t)

(provide 'package-config)
;;; package-config.el ends here
