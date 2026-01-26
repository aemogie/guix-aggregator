;;; -*- lexical-binding: t -*-

(use-package benchmark-init
  :init
  (benchmark-init/activate)
  :hook (after-init . benchmark-init/deactivate))

(use-package emacs
  :bind
  ("C-x C-b" . nil)
  :config
  ;; who am I?
  (setq user-full-name         "Luis Guilherme Coelho"
        user-email-address     "lgcoelho@disroot.org"
        copyright-names-regexp (format "%s <%s>"
                                       user-full-name
                                       user-email-address))

  ;; load-path
  (add-to-list 'load-path
               "~/.guix-home/profile/share/emacs/site-lisp")

  ;; display-line-numbers variables
  (setq display-line-numbers-current-absolute t
        display-line-numbers-grow-only t
        display-line-numbers-type 'relative
        display-line-numbers-width 4
        display-line-numbers-width-start t)

  ;; guix stuff
  (load-file "~/areas/code/scm/guix/master/etc/copyright.el")

  ;; keep ~/.config/emacs/ clean
  (setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
        url-history-file (expand-file-name "url/history"
                                           user-emacs-directory))

  ;; keep customization settings in a temporary file
  (setq custom-file
        (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
          (expand-file-name (format "emacs-custom-%s.el" (user-uid))
                            temporary-file-directory)))
  (load custom-file t)

  ;; backups and auto-save
  (setq backup-directory-alist
        `((".*" . ,(expand-file-name "backups" user-emacs-directory)))
        make-backup-files nil
        create-lockfiles nil
        backup-by-copying t
        version-control t
        delete-old-versions t
        vc-make-backup-files t
        kept-old-versions 10
        kept-new-versions 10)
  (setq auto-save-file-name-transforms
        `((".*" ,(expand-file-name "autosave"  user-emacs-directory) t))
        auto-save-default nil)

  ;; scrolling
  (setq scroll-conservatively 101
        scroll-margin 2)

  ;; sane defaults
  (setq-default buffer-file-coding-system 'utf-8-unix
                indent-tabs-mode nil)

  ;; nice to have
  (setq enable-recursive-minibuffers t
        use-dialog-box nil
        truncate-string-ellipsis "…"
        completions-detailed t)

  :hook (;; globally enabled modes
         (after-init . minibuffer-depth-indicate-mode)
         (after-init . column-number-mode)
         (after-init . prettify-symbols-mode)
         (after-init . save-place-mode)
         (after-init . savehist-mode)
         (after-init . (lambda ()
                         (setq gc-cons-percentage 0.1)
                         (setq gc-cons-threshold (* 2 1000 1000))
                         (setq file-name-handler-alist file-name-handler-alist-old)))

         ;; builtin-modes enabled in "writting" modes
         ((text-mode prog-mode conf-mode) . display-line-numbers-mode)
         ((text-mode prog-mode conf-mode) . electric-pair-local-mode)

         ;; before save hooks
         (before-save . delete-trailing-whitespace)))

(use-package no-littering)

(use-package diminish)

(use-package on)

(use-package server
  :config (unless (server-running-p)
            (server-start)))

(use-package gcmh
  :diminish gcmh-mode
  :init (gcmh-mode))

(use-package eldoc
  :diminish eldoc-mode)

(use-package which-key
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.2)
  (which-key-enable-extended-define-key nil)
  :hook (on-first-input . which-key-mode))

(use-package autorevert
  :diminish auto-revert-mode
  :hook (on-first-file . global-auto-revert-mode))

(dolist (module '("guix.el" "meow.el" "languages.el"
                  "misc.el" "org.el" "ui.el" "wm.el"))
  (load-file (concat "~/.config/emacs/modules/" module)))
