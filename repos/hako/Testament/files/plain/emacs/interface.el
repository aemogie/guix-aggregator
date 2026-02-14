;;; -*- lexical-binding: t -*-
;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025-2026 Hilton Chain <hako@ultrarare.space>

(use-package emacs
  :custom
  (blink-cursor-mode nil)
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
  ("M-o" . other-window)
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

;;guix:emacs-adaptive-wrap
(use-package adaptive-wrap
  :hook
  (visual-line-mode . adaptive-wrap-prefix-mode))

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
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key)
  ([remap describe-command]  . helpful-command)
  ([remap describe-symbol]   . helpful-symbol)
  ("C-c C-d" . helpful-at-point))

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
  ([remap move-beginning-of-line] . mwim-beginning)
  ([remap move-end-of-line] . mwim-end))

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

;;guix:emacs-valign
(use-package valign
  :hook
  (org-mode . valign-mode))

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

;;guix:emacs-visual-fill-column
(use-package visual-fill-column
  :custom
  (visual-fill-column-center-text t)
  :hook
  (visual-line-mode . visual-fill-column-mode))

(use-package which-key
  :config
  (which-key-setup-side-window-right-bottom)
  :hook
  (after-init . which-key-mode))
