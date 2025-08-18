;;; -*- lexical-binding: t -*-
;;; SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(setopt custom-file (locate-user-emacs-file "custom.el"))
(if (not (file-exists-p custom-file))
    (make-empty-file custom-file)
  (load custom-file))

(load-file "$$emacs/fonts.el$$")

;; Tweak garbage collection strategy.
;;guix:emacs-gcmh
(use-package gcmh
  :config
  (gcmh-mode 1))

;; Set default storage locations for various packages.
;;guix:emacs-no-littering
(use-package no-littering
  :config
  (no-littering-theme-backups))

(use-package emacs
  :custom
  (auth-source-gpg-encrypt-to '("220F98D95E86204C0036DA7B6DEC4360408B4185"))
  (auth-sources '("~/.local/share/authinfo.gpg"))
  (compile-command "make -k -j$(nproc)")
  (user-full-name "Hilton Chain")
  (user-mail-address "hako@ultrarare.space")
  ;; Workaround to use fish as login shell.
  (shell-file-name "/bin/sh")
  ;; CJK support.
  (word-wrap-by-category t))


;;;
;;; Interface
;;;

(use-package emacs
  :custom
  (blink-cursor-mode nil)
  (browse-url-firefox-program "librewolf")
  (enable-recursive-minibuffers t)
  (inhibit-startup-screen t)
  (initial-scratch-message ";; `M-x butterfly'\n\n")
  (uniquify-buffer-name-style 'forward)
  ;; Exclude unavailable completions.
  (read-extended-command-predicate 'command-completion-default-include-p)
  ;; Case-insensitive completion.
  (completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  :bind
  ([remap list-buffers] . switch-to-buffer)
  :hook
  ;; Scrolling enhancement.
  (after-init . pixel-scroll-precision-mode)
  ;; Indicatior for recursive minibuffers.
  (after-init . minibuffer-depth-indicate-mode)
  ;; Save minibuffer history.
  (after-init . savehist-mode)
  ;; Indicator for `fill-column'.
  (prog-mode . display-fill-column-indicator-mode))

;; Theming
(use-package emacs
  :custom
  (fringe-mode 0)
  (modus-themes-italic-constructs t)
  (scroll-bar-mode nil)
  (tool-bar-mode nil)
  (tooltip-mode nil)
  :config
  (load-theme 'modus-operandi-tinted :no-confirm)
  :hook
  (after-init . menu-bar-mode))

(use-package completion-preview
  :custom
  (global-completion-preview-mode t))

;;guix:emacs-doom-modeline
(use-package doom-modeline
  :custom
  (doom-modeline-icon nil)
  (doom-modeline-height 18)
  :hook
  (after-init . doom-modeline-mode))

;;guix:emacs-helpful
(use-package helpful
  :bind
  (([remap describe-function] . helpful-callable)
   ([remap describe-variable] . helpful-variable)
   ([remap describe-key]      . helpful-key)
   ([remap describe-command]  . helpful-command)
   ([remap describe-symbol]   . helpful-symbol)
   ("C-c C-d" . helpful-at-point)))

;;guix:emacs-hl-todo
(use-package hl-todo
  :custom
  (hl-todo-highlight-punctuation ":")
  :hook
  (prog-mode . hl-todo-mode))

(use-package isearch
  :custom
  (isearch-lazy-count t)
  (isearch-wrap-pause 'no-ding)
  (regexp-search-ring-max 200)
  (search-ring-max 200))

;;guix:emacs-mwim
(use-package mwim
  :bind
  (([remap move-beginning-of-line] . mwim-beginning)
   ([remap move-end-of-line] . mwim-end)))

;;guix:emacs-orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  (orderless-matching-styles '(orderless-literal orderless-flex orderless-regexp)))

;;guix:emacs-org-rainbow-tags
(use-package org-rainbow-tags
  :hook
  (org-mode . org-rainbow-tags-mode))

(use-package paren
  :custom
  (show-paren-context-when-offscreen 'overlay)
  :hook
  (after-init . show-paren-mode))

;;guix:emacs-rainbow-delimiters
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

;;guix:emacs-treesit-auto
;;guix:tree-sitter-cmake
;;guix:tree-sitter-dockerfile
;;guix:tree-sitter-go
;;guix:tree-sitter-gomod
;;guix:tree-sitter-rust
;;guix:tree-sitter-typescript
;;guix:tree-sitter-yaml
(use-package treesit-auto
  :config
  ;; FIXME: These modes aren't loaded automatically.
  (require 'cmake-ts-mode)
  (require 'dockerfile-ts-mode)
  (require 'go-ts-mode)
  (require 'rust-ts-mode)
  (require 'typescript-ts-mode)
  (require 'yaml-ts-mode)
  ;; https://github.com/renzmann/treesit-auto/issues/32#issuecomment-1826270447
  (defun hako/get-tree-sitter-mode (mode)
    (treesit-auto--set-major-remap)
    (alist-get mode major-mode-remap-alist mode))
  (define-advice org-src-get-lang-mode (:filter-return (mode) tree-sitter)
    (hako/get-tree-sitter-mode mode))
  :hook
  (after-init . global-treesit-auto-mode))

;;guix:emacs-vertico
(use-package vertico
  :hook
  (after-init . vertico-mode))

(use-package vertico-directory
  :after (vertico)
  :bind
  ;; More convenient directory navigation commands.
  (:map vertico-map
        ("RET" . vertico-directory-enter)
        ("DEL" . vertico-directory-delete-char)
        ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names.
  :hook
  (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package which-key
  :config
  (which-key-setup-side-window-right-bottom)
  :hook
  (after-init . which-key-mode))


;;;
;;; Editing
;;;

(use-package emacs
  :custom
  ;; Disable tab indentation.
  (indent-tabs-mode nil)
  :config
  ;; Avoid re-indenting current line after entering `RET'.
  (setopt electric-indent-inhibit t)
  :hook
  (before-save . delete-trailing-whitespace)
  ;; Automatic parenthesis pairing.
  (after-init . electric-pair-mode))

;;guix:emacs-citre
(use-package citre
  :custom
  (citre-default-create-tags-file-location 'global-cache)
  (citre-edit-ctags-options-manually nil)
  :bind
  ([remap xref-find-definitions] . citre-jump)
  ([remap xref-find-references]  . citre-jump-to-reference)
  ([remap xref-go-back]          . citre-jump-back)
  ("C-x c p" . citre-ace-peek)
  ("C-x c u" . citre-update-this-tags-file))

(use-package citre-xref-adapter
  :after (citre)
  :config
  (defvar citre-dumb-jump-backend
    (citre-xref-backend-to-citre-backend
     'dumb-jump
     (lambda () t)))
  (defvar citre-elisp-backend
    (citre-xref-backend-to-citre-backend
     'elisp
     (lambda () (derived-mode-p 'scheme-mode))))
  (citre-register-backend 'dumb-jump citre-dumb-jump-backend)
  (citre-register-backend 'elisp citre-elisp-backend))

(use-package citre-backend-interface
  :custom
  (citre-find-definition-backends
   '(eglot elisp tags dumb-jump))
  (citre-find-reference-backends
   '(eglot elisp dumb-jump)))

(use-package citre-config)

;;guix:emacs-dumb-jump
(use-package dumb-jump
  :after (xref)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;;guix:python
;;guix:rust
;;guix:rust:cargo
;;guix:zig
(use-package eglot
  :config
  (dolist (program
           `(((rust-ts-mode rust-mode)
              "$$bin/rust-analyzer$$")
             ((python-mode python-ts-mode)
              "$$bin/pylsp$$")
             ((c-mode c-ts-mode c++-mode c++-ts-mode)
              "$$bin/ccls$$"
              ,(concat
                "--init="
                (json-serialize
                 `((cache
                    (directory . ,(concat (xdg-cache-home) "/ccls-cache")))))))
             ((zig-mode)
              "$$bin/zls$$")))
    (add-to-list 'eglot-server-programs program)))

;; Check syntax on the fly.
;;guix:emacs-flycheck
(use-package flycheck
  :hook
  (after-init . global-flycheck-mode))

;;guix:emacs-flycheck-guile
(use-package flycheck-guile
  :after (flycheck geiser-guile))

;;guix:emacs-geiser
(use-package geiser
  :custom
  (geiser-autodoc-identifier-format "%s → %s")
  (geiser-mode-smart-tab-p t)
  (geiser-mode-start-repl-p t)
  (geiser-repl-query-on-kill-p nil))

;;guix:emacs-geiser-guile
(use-package geiser-guile
  :after (geiser)
  :custom
  (geiser-default-implementation 'guile)
  (geiser-active-implementation '(guile))
  :config
  ;; TODO: Make `flycheck-guile' support `guix repl'.
  (dolist (path
           (mapcar
            #'expand-file-name
            '("~/.config/guix/current/lib/guile/3.0/site-ccache"
              "~/.config/guix/current/share/guile/site/3.0"
              "~/.guix-profile/lib/guile/3.0/site-ccache"
              "~/.guix-profile/share/guile/site/3.0"
              "~/.guix-home/profile/lib/guile/3.0/site-ccache"
              "~/.guix-home/profile/share/guile/site/3.0"
              "/run/current-system/profile/lib/guile/3.0/site-ccache"
              "/run/current-system/profile/share/guile/site/3.0")))
    (add-to-list 'geiser-guile-load-path path t)))

;;guix:emacs-macrostep
(use-package macrostep
  :bind
  ("C-c e" . macrostep-expand))

(use-package org
  :custom
  (org-babel-load-languages
   '((scheme . t)
     (python . t)
     (scheme . t)
     (shell . t)))
  (org-id-track-globally t)
  (org-insert-heading-respect-content t)
  (org-link-file-path-type 'relative)
  (org-log-into-drawer t)
  (org-special-ctrl-a/e t)
  (org-special-ctrl-k t)
  (org-startup-folded 'content)
  (org-todo-keywords '((sequence "TODO(t!)" "DOING(g!)" "|" "DONE(d!)"))))

;;guix:emacs-ox-hugo
(use-package ox-hugo
  :after (ox))

;;guix:emacs-puni
(use-package puni
  :hook
  ((eval-expression-minibuffer-setup nxml-mode prog-mode sgml-mode tex-mode)
   . puni-mode))


;;;
;;; Miscellaneous
;;;

;;guix:emacs-daemons
(use-package daemons
  :custom
  (daemons-list-fill-frame t))

(use-package dired
  :custom
  (dired-listing-switches
   "-lv --all --group-directories-first --human-readable")
  :bind
  ([remap list-directory] . dired))

(use-package dired-aux
  :custom
  (dired-compress-directory-default-suffix ".tar.zst")
  (dired-create-destination-dirs 'ask)
  (dired-create-destination-dirs-on-trailing-dirsep t)
  (dired-vc-rename-file t))

;;guix:emacs-eat-hako
(use-package eat
  :custom
  (eat-kill-buffer-on-exit t)
  (eshell-visual-commands nil)
  :hook
  (eshell-load . eat-eshell-mode))

(use-package project
  :config
  (add-to-list 'project-switch-commands '(eat-project "Eat") t)
  :bind
  (:map project-prefix-map
        ("t" . eat-project)))

;;guix:emacs-envrc
(use-package envrc
  :hook
  (after-init . envrc-global-mode))

;;guix:emacs-magit
(use-package magit
  :custom
  (git-commit-cd-to-toplevel t))

(use-package project
  :config
  (add-to-list 'project-switch-commands '(magit-project-status "Magit") t)
  :bind
  (:map project-prefix-map
        ("m" . magit-project-status)))

;;guix:emacs-forge
(use-package forge
  :after (magit))

;;guix:mu
(use-package mu4e
  :custom
  (mu4e-sent-folder "/Sent")
  (mu4e-drafts-folder "/Drafts")
  (mu4e-trash-folder "/Trash")
  (mu4e-refile-folder "/Archive")
  (mu4e-change-filenames-when-moving t)
  ;; Search.
  (mu4e-query-rewrite-function
   (lambda (expr)
     (if (string-match "maildir:\"/\\(Junk\\|Trash\\)\"" expr)
         expr
       (concat expr " AND NOT (maildir:/Junk OR maildir:/Trash)"))))
  ;; Compose.
  (message-dont-reply-to-names mu4e-personal-or-alternative-address-p)
  (message-kill-buffer-on-exit t)
  (mml-secure-openpgp-encrypt-to-self t)
  (mml-secure-openpgp-signers '("220F98D95E86204C0036DA7B6DEC4360408B4185"))
  :config
  (dolist (format '("text/html" "text/richtext"))
    (add-to-list 'mm-discouraged-alternatives format))
  :bind
  ("C-c M-m" . message-mark-inserted-region))

(use-package smtpmail
  :custom
  (smtpmail-default-smtp-server "mail.boiledscript.com")
  (smtpmail-smtp-service 465)
  (smtpmail-stream-type 'ssl)
  (smtpmail-queue-mail t)
  (smtpmail-queue-dir "~/.local/share/queued-mail"))
