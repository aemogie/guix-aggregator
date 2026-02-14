;;; -*- lexical-binding: t -*-
;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025-2026 Hilton Chain <hako@ultrarare.space>

(use-package emacs
  :custom
  ;; Disable tab indentation.
  (indent-tabs-mode nil)
  ;; CJK support.
  (word-wrap-by-category t)
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
                    (directory
                     . ,(concat (or (getenv "XDG_CACHE_HOME")
                                    "~/.cache")
                                "/ccls-cache")))))))
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
  (geiser-repl-query-on-kill-p nil))

(use-package geiser-mode
  :custom
  (geiser-mode-smart-tab-p t)
  (geiser-mode-start-repl-p t)
  :bind
  (:map geiser-mode-map
        ("M-." . nil)
        ("M-," . nil)))

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

;;guix:emacs-macrostep-geiser
(use-package macrostep-geiser
  :after (geiser-mode)
  :hook
  (geiser-mode . macrostep-geiser-setup))

(use-package macrostep-geiser
  :after (geiser-repl)
  :hook
  (geiser-repl-mode . macrostep-geiser-setup))

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

;;guix:emacs-treesit-auto
;;guix:tree-sitter-cmake
;;guix:tree-sitter-dockerfile
;;guix:tree-sitter-go
;;guix:tree-sitter-gomod
;;guix:tree-sitter-kdl
;;guix:tree-sitter-lua
;;guix:tree-sitter-rust
;;guix:tree-sitter-typescript
;;guix:tree-sitter-yaml
(use-package treesit-auto
  :config
  ;; FIXME: These modes aren't loaded automatically.
  (require 'cmake-ts-mode)
  (require 'dockerfile-ts-mode)
  (require 'go-ts-mode)
  (require 'lua-ts-mode)
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

;;guix:emacs-yasnippet
;;guix:emacs-yasnippet-snippets
(use-package yasnippet
  :hook
  (after-init . yas-global-mode))
