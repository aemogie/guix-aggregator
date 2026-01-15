;;; -*- lexical-binding: t -*-
;;; SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

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

;;guix:emacs-eat-dolly
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

;;guix:emacs-notmuch
(use-package notmuch
  :custom
  (mail-user-agent 'notmuch-user-agent)
  (message-hidden-headers '("^Face:" "^X-Face:" "^X-Draft-From:"))
  (message-kill-buffer-on-exit t)
  (mml-secure-openpgp-encrypt-to-self t)
  (mml-secure-openpgp-signers '("220F98D95E86204C0036DA7B6DEC4360408B4185"))
  (notmuch-show-logo nil)
  (notmuch-draft-folder "local/Drafts")
  (notmuch-fcc-dirs "imap/INBOX")
  (notmuch-message-headers
   '("Subject" "To" "Cc" "Date" "Message-ID" "In-Reply-To" "References"))
  (notmuch-search-oldest-first nil)
  :config
  (remove-hook 'notmuch-show-hook 'notmuch-show-turn-on-visual-line-mode)
  (remove-hook 'notmuch-show-insert-text/plain-hook 'notmuch-wash-excerpt-citations)
  :hook
  (notmuch-show-insert-text/plain . notmuch-wash-convert-inline-patch-to-part)
  :bind
  ("C-c M-m" . message-mark-inserted-region))

(use-package smtpmail
  :custom
  (smtpmail-default-smtp-server "mail.boiledscript.com")
  (smtpmail-smtp-service 465)
  (smtpmail-stream-type 'ssl)
  (smtpmail-queue-mail t)
  (smtpmail-queue-dir "~/.local/share/queued-mail"))
