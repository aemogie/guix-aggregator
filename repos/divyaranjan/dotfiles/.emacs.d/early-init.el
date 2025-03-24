;;; early-init.el --- Early Init File --- -*- lexical binding: t -*-

;;; Commentary:

;; Starting the package manager before initiating the `init.el'.  Apparently this is the case after Emacs 27.

;;; Code:
(defvar native-comp-deferred-compilation-deny-list nil)

;; Garbage Collection Minimize
(defvar file-name-handler-alist-old file-name-handler-alist)

(setq file-name-handler-alist nil
      gc-cons-threshold most-positive-fixnum)
;; Lower threshold to speed up garbage collection
(add-hook 'after-init-hook
	  `(lambda ()
	     (setq file-name-handler-alist file-name-handler-alist-old)
	     (setq gc-cons-threshold 300000000))
	  t)

;;; The Load-path
(let ((default-directory "~/.emacs.d/lisp/"))
  (normal-top-level-add-subdirs-to-load-path))

(byte-recompile-directory (expand-file-name "~/.emacs.d/lisp/"))


;;; PACKAGE LIST

(set-background-color "black")
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("org" . "https://orgmode.org/elpa/")
	("elpa" . "https://elpa.gnu.org/packages/")))

;;; BOOTSTRAP USE-PACKAGE or Straight.el
(require 'package)
(setq package-enable-at-startup nil)
(setq straight-check-for-modifications nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Quelpa
;; (unless (package-installed-p 'quelpa)
;;   (with-temp-buffer
;;     (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
;;     (eval-buffer)
;;     (quelpa-self-upgrade)))

;; (package-initialize)
;; (setq use-package-always-ensure t)
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))
;; (eval-when-compile (require 'use-package))


;; Showing startup time
(defun divya/display-startup-time ()
  (message "Emacs loaded in %s."
	   (format "%.2f seconds"
		   (float-time
		    (time-subtract after-init-time before-init-time)))))

(add-hook 'emacs-startup-hook #'divya/display-startup-time)

;;; early-init.el ends here
