;;; -*- lexical-binding: t -*-
;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025-2026 Hilton Chain <hako@ultrarare.space>

(setopt custom-file (locate-user-emacs-file "custom.el"))
(if (not (file-exists-p custom-file))
    (make-empty-file custom-file)
  (load custom-file))

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
  (shell-file-name "/bin/sh"))

(load-file "$$emacs-fonts.el$$")
(load-file "$$emacs-interface.el$$")
(load-file "$$emacs-editing.el$$")
(load-file "$$emacs-miscellaneous.el$$")
