;;; anon-core.el --- Provides core configuration for emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  

;; Author:  <kyle@thinkpad490>
;; Keywords: lisp,

;; Code:

;;; -- Basic Configuration Paths -----

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
;; (setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
;;       url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering
  :demand t
  :config
  ;; Set the custom-file to a file that won't be tracked by Git
  (setq custom-file (if (boundp 'server-socket-dir)
                        (expand-file-name "custom.el" server-socket-dir)
                      (no-littering-expand-etc-file-name "custom.el")))
  (when (file-exists-p custom-file)
    (load custom-file t))

  ;; Don't litter project folders with backup files
  (let ((backup-dir (no-littering-expand-var-file-name "backup/")))
    (make-directory backup-dir t)
    (setq backup-directory-alist
          `(("\\`/tmp/" . nil)
            ("\\`/dev/shm/" . nil)
            ("." . ,backup-dir))))

  (setq auto-save-default nil)

  ;; Tidy up auto-save files
  (setq auto-save-default nil)
  (let ((auto-save-dir (no-littering-expand-var-file-name "auto-save/")))
    (make-directory auto-save-dir t)
    (setq auto-save-file-name-transforms
          `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
             ,(concat temporary-file-directory "\\2") t)
            ("\\`\\(/tmp\\|/dev/shm\\)\\([^/]*/\\)*\\(.*\\)\\'" "\\3")
            ("." ,auto-save-dir t)))))

;;; -- Core Key Bindings and Packages ----

(repeat-mode 1)

(column-number-mode)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

(setq large-file-warning-threshold nil)
(setq vc-follow-symlinks t)
(setq ad-redefinition-action 'accept)

;;; -- Appearance --
;; (use-package ef-themes
;;   :config
;;   (ef-themes-select 'ef-dark))

(use-package emacs
  :config
  (load-theme 'modus-vivendi))

;;; -- Tabs and workspaces --

;; (use-package tabspaces
;;   :config
;;   (keymap-global-set "s-/" #'tab-previous)
;;   (keymap-global-set "s-@" #'tab-next)
;;   (keymap-global-set "s-?"
;;                   (lambda ()
;;                     (interactive)
;;                     (tab-move -1)))
;;   (keymap-global-set "s-^"
;;                   (lambda ()
;;                     (interactive)
;;                     (tab-move 1))))


;;; -- Dired --

(use-package all-the-icons-dired)
(use-package dired-ranger)

(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("b" . dired-up-directory)
              ("H" . dired-hide-details-mode))
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-dwim-target 'dired-dwim-target-next
        dired-hide-details-hide-symlink-targets nil
        dired-kill-when-opening-new-dired-buffer t
        delete-by-moving-to-trash t))

(provide 'anon-core-config)
