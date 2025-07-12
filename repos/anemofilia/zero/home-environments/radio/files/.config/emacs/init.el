;;; -*- lexical-binding: t -*-

(use-package emacs
  :config
  ;; who am I?
  (setq user-full-name         "Luis Guilherme Coelho"
        user-email-address     "lgcoelho@disroot.org"
        copyright-names-regexp (format "%s <%s>"
                                       user-full-name
                                       user-mail-address))

  (dolist (item '((ns-transparent-titlebar . t)
                  (ns-appearance . dark)
                  (undecorated . t)))
    (add-to-list 'default-frame-alist item))

  ;; load-path
  (add-to-list 'load-path
               "~/.guix-home/profile/share/emacs/site-lisp")

  ;; display-line-numbers variables
  (setq display-line-numbers-current-absolute t
        display-line-numbers-grow-only        t
        display-line-numbers-type             'relative
        display-line-numbers-width            4
        display-line-numbers-width-start      t)

  ;; guix stuff
  (load-file "~/resources/code/scm/guix/etc/copyright.el")

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

  ;; backups
  (setq backup-directory-alist
        `((".*" . ,(expand-file-name "backups" user-emacs-directory)))
        auto-save-file-name-transforms
        `((".*" ,(expand-file-name "autosave/"  user-emacs-directory) t))
        make-backup-files nil
        create-lockfiles     nil
        backup-by-copying    t
        version-control      t
        delete-old-versions  t
        vc-make-backup-files t
        kept-old-versions    10
        kept-new-versions    10)

  ;; autosave
  (auto-save-mode -1)

  ;; dialog box
  (setq use-dialog-box nil)

  ;; scrolling
  (setq scroll-conservatively 101
        scroll-margin 2)

  ;; lmao?
  (setq enable-recursive-minibuffers t)

  ;; indentation
  (setq-default indent-tabs-mode nil)

  ;; misc
  (setq-default buffer-file-coding-system 'utf-8-unix)

  :bind ("C-x C-b" . nil)

  :hook (;; globally enabled modes
         (after-init . column-number-mode)
         (after-init . prettify-symbols-mode)
         (after-init . save-place-mode)
         (after-init . savehist-mode)

         ((text-mode prog-mode conf-mode) . display-line-numbers-mode)
         ((text-mode prog-mode conf-mode) . electric-pair-local-mode)
         ((text-mode prog-mode conf-mode) . whitespace-mode)))

;; diminish
(use-package diminish)

;; server
(use-package server
  :config (unless (server-running-p)
            (server-start)))

;; garbage collector
(use-package gcmh
  :diminish gcmh-mode
  :init (gcmh-mode))

;; no-littering
(use-package no-littering)

;; eldoc
(use-package eldoc
  :diminish eldoc-mode)

;; keys
(use-package which-key
  :diminish which-key-mode
  :custom ((which-key-idle-delay 0.3)
           (which-key-enable-extended-define-key nil))
  :init (which-key-mode))

;; auto-revert
(use-package autorevert
  :diminish auto-revert-mode
  :hook((text-mode prog-mode conf-mode) . auto-revert-mode))

;; rainbow-delimiters
(use-package rainbow-delimiters
  :hook ((text-mode prog-mode conf-mode) . rainbow-delimiters-mode))

;; helpful
(use-package helpful
  :custom
  (help-select-window t)
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h C-." . helpful-at-point)))

;; anzu-mode
(use-package anzu
  :diminish anzu-mode
  :bind
  (([remap query-replace] . anzu-query-replace)
   ([remap query-replace-regexp] . anzu-query-replace-regexp)
   :map isearch-mode-map
   ([remap isearch-query-replace] . anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :init (global-anzu-mode))

;; whitespace
(use-package whitespace
  :diminish whitespace-mode
  :custom ((whitespace-display-mappings
            '((space-mark    ?\   [?⋅])
              ;; fix strange behaviour with hl-fill-column-mode
              (newline-mark  ?\n  [?↩ ?\n])
              (tab-mark      ?\t  [?→ ?\t])))))

;; org
(use-package org
  :custom ((org-hide-emphasis-markers t))
  :hook (org-mode . (lambda ()
                      (interactive)
                      (whitespace-mode 0)
                      (display-fill-column-indicator-mode 0)
                      (add-hook 'completion-at-point-functions #'cape-tex))))

;; origami
(use-package origami)

;; eat
(use-package eat
  :hook (eat-mode . meow-insert-mode))

;; pdf-view
(use-package pdf-tools
  :custom
  (pdf-outline-imenu-use-flat-menus t)
  (pdf-view-display-size 1.5)
  :bind (:map pdf-view-mode-map
              ("r" . pdf-view-rotate)
              ("R" . pdf-view-themed-minor-mode)
              ("J" . pdf-view-next-page)
              ("K" . pdf-view-previous-page)
              ("<tab>" . imenu))
  :hook
  (doc-view-mode . pdf-view-mode)
  (pdf-view-mode . pdf-outline-imenu-enable))

(dolist (module '("guix.el"
                  "meow.el"
                  "communication.el"
                  "completion.el"
                  "dirvish.el"
                  "languages.el"
                  "perspective.el"))
  (load-file (concat "~/.config/emacs/modules/" module)))
