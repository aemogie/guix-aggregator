(setopt default-directory "~/")

(defvar personal-data (expand-file-name "personal.el" user-emacs-directory))
(load personal-data)

(use-package cus-edit
  :defer t
  :custom
  (custom-file (expand-file-name "custom.el" user-emacs-directory)))

(use-package files
  :custom
  (large-file-warning-threshold 10000000)
  (backup-by-copying t)
  :config
  (add-to-list 'backup-directory-alist
               `("." . ,(expand-file-name "backups" user-emacs-directory))))

(use-package autorevert
  :config
  (global-auto-revert-mode 1))

(use-package saveplace
  :config
  (save-place-mode 1))

(use-package savehist
  :config
  (savehist-mode 1))

(use-package recentf
  :config
  (recentf-mode 1))

(setopt buffer-file-coding-system 'utf-8-unix)

(use-package dired
  :commands dired
  :hook
  (dired-mode . dired-hide-details-mode)
  :custom
  (dired-listing-switches "-Ahl --group-directories-first")
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  :config
  (defun my/dired-run-command (command)
    "Run COMMAND on files marked in `dired'."
    (interactive "Crun on marked files: ")
    (let ((file-buffers (cl-remove-if-not #'buffer-file-name (buffer-list))))
      (save-excursion
        (dolist (marked-file (dired-get-marked-files))
          (find-file marked-file)
          (funcall command)
          (unless (member (current-buffer) file-buffers)
            (save-buffer)
            (kill-buffer)))))))

(use-package diredfl
  :after dired
  :config
  (diredfl-global-mode 1))

(use-package epg
  :config
  (fset 'epg-wait-for-status 'ignore))

(setopt delete-by-moving-to-trash t)

(use-package trashed
  :commands trashed
  :custom
  (trashed-sort-key '("Date deleted" . t))
  (trashed-date-format "%Y-%m-%d %H:%M:%S")
  (trashed-use-header-line t))

(use-package keymap
  :config
  (defvar my/keybinds '(("M-<tab>" . next-buffer)
                        ("M-<iso-lefttab>" . previous-buffer)
                        ("M-0" . delete-window)
                        ("M-1" . delete-other-windows)
                        ("M-2" . split-window-right)
                        ("M-3" . split-window-below)
                        ("M-]" . next-window-any-frame)
                        ("M-[" . previous-window-any-frame)
                        ("M-#" . dictionary-lookup-definition)
                        ("C-x b" . consult-buffer)
                        ("C-c y" . consult-yank-from-kill-ring)
                        ("C-c r s" . consult-register-store)
                        ("C-c r l" . consult-register-load)
                        ("C-c t" . ef-themes-toggle)
                        ("C-c b k" . kill-buffer-and-window)
                        ("C-c b h" . my/hide-buffer)
                        ("C-c b u" . my/unhide-buffer)
                        ("C-c m v" . my/mpv)
                        ("C-c m a" . my/play-album)))

  (defun my/activate-keybinds (&optional local)
    "Activate personal keybinds stored in `my/keybinds'.
If LOCAL is nil set globally with `keymap-global-set'.
Otherwise set locally with `keymap-local-set'."
    (interactive "P")
    (let ((setter-function (if local 'keymap-local-set 'keymap-global-set)))
      (dolist (key-and-function my/keybinds)
        (funcall setter-function (car key-and-function) (cdr key-and-function)))))

  (my/activate-keybinds))

(use-package which-key
  :if
  (>= emacs-major-version 30)
  :config
  (which-key-mode 1))

(use-package repeat
  :config
  (repeat-mode 1))

(add-to-list 'default-frame-alist '(alpha-background . 80))

(setopt initial-scratch-message nil
        inhibit-startup-screen t)

(use-package scroll-bar
  :config
  (scroll-bar-mode -1))

(use-package tool-bar
  :config
  (tool-bar-mode -1))

(use-package menu-bar
  :config
  (menu-bar-mode -1))

(use-package frame
  :config
  (blink-cursor-mode -1))

(setopt frame-title-format "%b")
(add-to-list 'default-frame-alist '(undecorated . t))

(setopt mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                "  "
                mode-line-buffer-identification
                "  "
                mode-line-position-column-line-format
                "  "
                (vc-mode vc-mode)
                "  "
                mode-name
                "  "
                (:eval (unless (zerop
                                (bound-and-true-p text-scale-mode-amount))
                         text-scale-mode-lighter))
                "  "
                mode-line-misc-info
                mode-line-end-spaces))

(setopt mode-line-compact 'long)

(use-package time
  :custom
  (display-time-format "%R")
  (display-time-default-load-average nil)
  :config
  (display-time-mode 1))

(global-visual-line-mode 1)

(use-package hl-line
  :config
  (global-hl-line-mode 1)
  (dolist (hook '(comint-mode-hook eshell-mode-hook))
    (add-hook hook (lambda () (setq-local global-hl-line-mode nil)))))

(use-package display-line-numbers
  :custom
  (display-line-numbers-type t)
  :config
  (dolist (hook '(conf-mode-hook nxml-mode-hook prog-mode-hook))
    (add-hook hook 'display-line-numbers-mode)))

(use-package font-lock)

(use-package faces
  :config
  (set-face-attribute 'default nil
                      :family "DejaVu Sans Mono"
                      :height 125
                      :slant 'normal)

  (set-face-attribute 'fixed-pitch nil
                      :family "DejaVu Sans Mono"
                      :height 125
                      :slant 'normal)

  (set-face-attribute 'variable-pitch nil
                      :family "DejaVu Serif"
                      :height 150
                      :slant 'normal)

  (set-face-attribute 'italic nil
                      :slant 'italic
                      :underline nil))

(use-package face-remap
  :config
  (defun my/enable-variable-pitch-mode ()
    (unless (derived-mode-p 'html-mode 'nxml-mode)
      (variable-pitch-mode 1)))
  
  (defun my/remap-pitch-faces (_enable)
    (face-remap--remap-face 'fixed-pitch)
    (face-remap--remap-face 'variable-pitch))
  
  (advice-add 'text-scale-mode :after #'my/remap-pitch-faces))

(use-package text-mode
  :config
  (when (featurep 'face-remap)
    (add-hook 'text-mode-hook #'my/enable-variable-pitch-mode)))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package ef-themes
  :custom
  (ef-themes-mixed-fonts t)
  (ef-themes-to-toggle '(ef-autumn ef-eagle))
  :config
  (defun my/adjust-opacity (&optional theme)
    "Make sure opacity is correct for given theme."
    (interactive)
    (let ((theme (if theme theme (ef-themes--current-theme))))
      (set-frame-parameter nil 'alpha-background
                           (if (member theme ef-themes-light-themes)
                               100
                             80))))

  (defun my/fontify-org-buffers (&optional _theme)
    "Fontify all org buffers.
Helpful advice for face changing functions."
    (interactive)
    (save-current-buffer
      (dolist (buffer (buffer-list))
        (set-buffer buffer)
        (when (eq major-mode 'org-mode)
          (font-lock-fontify-buffer)))))

  (advice-add 'ef-themes-load-theme :after #'my/adjust-opacity)
  (advice-add 'ef-themes-load-theme :after #'my/fontify-org-buffers)

  (add-hook 'server-after-make-frame-hook
            (lambda ()
              (ef-themes-load-theme (ef-themes--current-theme))))
  
  (ef-themes-select-dark 'ef-autumn)
  :after
  (frame font-lock))

(use-package orderless 
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides nil))

(use-package corfu 
  :init
  (setopt pgtk-wait-for-event-timeout 0)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-count 8)
  (corfu-popupinfo-delay '(1.5 . 0.5))
  :config
  (add-to-list 'corfu--frame-parameters '(alpha-background . 100))
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package vertico
  :config
  (vertico-mode 1))

(setopt use-short-answers t)

(use-package marginalia
  :config
  (marginalia-mode 1)
  :after vertico)

(use-package disable-mouse
  :config
  (global-disable-mouse-mode 1))

(setopt scroll-conservatively 10000
        auto-window-vscroll nil)

(use-package consult
  :custom
  (consult-buffer-sources '(consult--source-hidden-buffer
                            consult--source-modified-buffer
                            consult--source-buffer
                            consult--source-bookmark
                            consult--source-recent-file
                            consult--source-file-register
                            consult--source-project-buffer-hidden
                            consult--source-project-recent-file-hidden
                            consult--source-project-root-hidden)))

(unless (boundp '*hidden-buffers*)
  (defvar *hidden-buffers* ()
    "List of buffer names to be ignored by `next-buffer' and `previous-buffer'.
See also `my/hide-buffer' and `hidden-buffer-p'."))

(with-eval-after-load 'savehist
  (add-to-list 'savehist-additional-variables '*hidden-buffers*))

(defun hidden-buffer-p (_window buffer _bury-or-kill)
  "Hide buffers with name in `*hidden-buffers*'.
See also `switch-to-prev-buffer-skip'."
  (cl-find (buffer-name buffer) *hidden-buffers* :test #'string=))

(setopt switch-to-prev-buffer-skip 'hidden-buffer-p)

(defun my/hide-buffer (&optional buffer-name)
  "Adds BUFFER-NAME to `*hidden-buffers*'.
If BUFFER-NAME is nil then the current buffer name is used via `buffer-name'.
See also `my/unhide-buffer'."
  (interactive)
  (cl-pushnew (if buffer-name buffer-name (buffer-name))
              *hidden-buffers*
              :test #'string=))

(defun my/unhide-buffer (&optional buffer-name)
  "Removes BUFFER-NAME from `*hidden-buffers*'.
If BUFFER-NAME is nil then the current buffer name is used via `buffer-name'.
See also `my/hide-buffer'."
  (interactive)
  (setf *hidden-buffers*
        (remove (if buffer-name buffer-name (buffer-name))
                *hidden-buffers*)))

(setopt split-width-threshold 90)

(use-package delsel
  :config
  (delete-selection-mode 1))

(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-region 'disabled nil)

(use-package page
  :config
  (put 'narrow-to-page 'disabled nil))

(use-package ispell
  :custom
  (ispell-personal-dictionary "~/documents/personal-dictionary"))

(use-package writeroom-mode
  :custom
  (writeroom-width 80)
  (writeroom-fullscreen-effect 'maximized)
  (writeroom-major-modes '(text-mode))
  (writeroom-major-modes-exceptions '(mhtml-mode nxml-mode))
  :config
  (global-writeroom-mode 1))

(use-package prog-mode
  :config
  (global-prettify-symbols-mode 1))

(setopt indent-tabs-mode nil
        tab-width 4)

(use-package tabify
  :commands (tabify untabify)
  :config
  (defun my/dired-tabify-files (&optional untabify)
    "Run eitheir `tabify' or `untabify' on marked files in dired.
See `my/dired-run-command'."
    (interactive "P")
    (let ((tab-function (if untabify #'untabify #'tabify)))
      (my/dired-run-command
       (lambda ()
         (funcall tab-function (point-min) (point-max)))))))

(use-package jsonrpc
  :config
  (fset #'jsonrpc--log-event #'ignore))

(defun my/compile ()
  (interactive)
  (save-buffer)
  (save-window-excursion (compile compile-command)))

(defun my/set-compile-command (command)
  (set (make-local-variable 'compile-command)
       command))

(use-package paredit
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . paredit-mode))

(use-package rainbow-delimiters
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . rainbow-delimiters-mode))

(use-package aggressive-indent
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . aggressive-indent-mode))

(use-package elisp-mode
  :bind
  (:map lisp-interaction-mode-map
        ("C-c C-c" . eval-print-last-sexp)))

(use-package nadvice
  :config
  (defun my/remove-all-advice (sym)
    "Remove all advice from function designated by symbol SYM."
    (interactive)
    (advice-mapc (lambda (advice _props)
                   (advice-remove sym advice))
                 sym)))

(use-package geiser)

(use-package geiser-guile
  :commands geiser-guile
  :custom
  (geiser-guile-load-init-file t)
  :after geiser)

(use-package sly
  :commands sly
  :custom
  (inferior-lisp-program "sbcl")
  (sly-mrepl-history-file-
   (expand-file-name "sly/sly-mrepl-history" user-emacs-directory))
  :config
  (when (featurep 'rainbow-delimiters)
    (add-hook 'sly-mrepl-mode-hook 'rainbow-delimiters-mode)))

(use-package agda2-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.lagda.md$" . agda2-mode)))

(use-package go-mode
  :hook
  (go-mode . my/set-go-compile)
  :bind
  (:map go-mode-map
        ("C-c C-c" . my/compile)
        ("C-c C-r" . my/go-run))
  :config
  (defun my/set-go-compile ()
    (my/set-compile-command "go build"))
  
  (defun my/go-run ()
    (interactive)
    (shell-command "go run")))

(use-package org
  :defer t
  :hook
  (org-mode . org-indent-mode)
  :bind
  (:map org-mode-map
        ("C-c l" . org-cycle-list-bullet))
  :custom
  (org-directory "~/documents/org/")
  (org-default-notes-file (expand-file-name "notes.org" org-directory))
  (org-agenda-files (list (expand-file-name "agenda/" org-directory)))
  
  (org-startup-folded t)
  (org-M-RET-may-split-line '((default . nil)))
  (org-insert-heading-respect-content t)

  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-todo-keywords
   '((sequence "TODO(t)" "BLOCKED(b)" "|" "CANCELED(c)" "DONE(d)")))
  
  (org-edit-src-content-indentation 0)
  (org-babel-python-command "python3")
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (scheme . t)
     (python . t)
     (shell . t)
     (eshell . t)))

  (defvar my/org-cycle-list-bullet-repeat-keymap
    (define-keymap "l" #'org-cycle-list-bullet))

  (put #'org-cycle-list-bullet 'repeat-map
       'my/org-cycle-list-bullet-repeat-keymap))

(use-package org-bullets
  :hook
  (org-mode . org-bullets-mode))

(use-package ox-beamer
  :after org)

(use-package ox-publish
  :commands org-publish
  :config
  (use-package org-publish-rss
    :custom
    (org-publish-rss-publish-immediately t))

  (load (expand-file-name "org-publish.el" user-emacs-directory))
  :after jack)

(use-package markdown-mode
  :defer t)

(use-package latex
  :defer t
  :hook
  (LaTeX-mode . my/set-latex-compile)
  :bind
  (:map LaTeX-mode-map
        ("C-c C-c" . my/compile))
  :config
  (defun my/set-latex-compile ()
    (my/set-compile-command (format "pdflatex %s" (buffer-file-name)))))

(use-package eshell
  :commands eshell
  :hook
  (eshell-mode . (lambda ()
                   (keymap-set eshell-mode-map "C-c M-o" 'my/eshell-clear)))
  :custom
  (eshell-prompt-function
   (lambda ()
     (if (featurep 'ef-themes)
         (let* ((palette (ef-themes--current-theme-palette))
                (orange (cadr (assoc 'yellow-warmer palette)))
                (green (cadr (assoc 'green-warmer palette))))
           (format "\n %s\n %s "
                   (propertize (eshell/pwd)
                               'face `(:foreground ,orange :weight bold))
                   (propertize (if (zerop (user-uid)) "#" "λ")
                               'face `(:foreground ,green :weight bold))))
       (format "\n %s\n λ " (eshell/pwd)))))
  (eshell-prompt-regexp ".* λ ")
  :config
  (defun my/eshell-clear ()
    (interactive)
    (eshell/clear-scrollback)
    (insert "fastfetch")
    (eshell-send-input)))

(defun my/sudo-shell-command (command)
  "Run COMMAND as root via Tramp."
  (interactive "MShell command (root): ")
  (with-temp-buffer
    (cd "/sudo::/")
    (async-shell-command command)))

(use-package buffer-env
  :commands
  (buffer-env-update buffer-env-reset))

(use-package eat
  :hook
  (eshell-load . eat-eshell-mode))

(use-package magit
  :commands magit
  :hook
  (magit-mode . (lambda () (my/activate-keybinds t))))

(use-package pinentry
  :custom
  (epg-pinentry-mode 'loopback)
  :config
  (pinentry-start))

(use-package bluetooth
  :commands bluetooth-list-devices)

(use-package tldr
  :commands
  (tldr tldr-update-docs))

(use-package wgrep
  :commands wgrep)

(use-package htmlize)
(use-package jack)

(use-package eww
  :defer t
  :custom
  (eww-default-download-directory "~/downloads"))

(use-package mu4e
  :commands
  (mu4e)
  :custom
  (mu4e-drafts-folder "/Drafts")
  (mu4e-sent-folder "/Sent")
  (mu4e-trash-folder "/Trash")

  (mail-user-agent 'mu4e-user-agent)
  (mu4e-get-mail-command (format "INSIDE_EMACS=%s mbsync -a"
                                 emacs-version))

  (mu4e-modeline-support nil))

(defun my/make-youtube-feed (channel-url)
  "Create RSS feed url from youtube channel url CHANNEL-URL
and save an appropriate entry for `elfeed-feeds' to the kill ring."
  (interactive "Mchannel url: ")
  (let ((channel-id (car (last (string-split channel-url "/")))))
    (with-temp-buffer
      (print  (list (format "https://www.youtube.com/feeds/videos.xml?channel_id=%s"
                            channel-id)
                    'video)
              (current-buffer))
      (backward-kill-sexp))))

(use-package elfeed
  :commands elfeed
  :custom
  (elfeed-db-directory (expand-file-name "elfeed-db" user-emacs-directory))
  (elfeed-search-filter "@6-months-ago +unread")
  :config
  (defun my/kill-elfeed-search-buffer ()
    (kill-buffer "*elfeed-search*"))
  
  (load (expand-file-name "feeds.el" user-emacs-directory))
  (advice-add 'elfeed-search-quit-window :after #'my/kill-elfeed-search-buffer))

(use-package gnus
  :defer t)

(use-package gnus-start
  :defer t
  :custom
  (gnus-use-dribble-file nil)
  :after gnus)

(defun my/play-album ()
  "Play album in directory at point via mpv.

Opens a socket at =/tmp/mpv-socket= to which mpv commands can be sent
(such as pause, play, next, etc.).

Directory name must be the name of the album, contain the song files,
and contain a file =<album-name>--Album.txt= which lists the song files
in desired playing order, separated by newlines.

See https://codeberg.org/mrh/dotfiles/dot-local/bin for more info."
  (interactive)
  (let* ((album-path (dired-get-filename))
         (album-name (shell-quote-argument (file-name-nondirectory album-path))))
    (call-process-shell-command
     (format "exec mpv --wayland-app-id=mpv-album --input-ipc-server=/tmp/mpv-socket --playlist=%s/%s--Album.txt"
             album-path album-name)
     nil
     0)))

(defun my/mpv (&optional mpv-command)
  "Run custom mpv command on file or url at point."
  (interactive)
  (let ((audio (if (eq major-mode 'dired-mode)
                   (dired-get-filename)
                 (thing-at-point 'url))))
    (call-process-shell-command
     (if mpv-command
         mpv-command
       (format "mpv --profile=1600p --force-window=immediate --pause %s"
               (shell-quote-argument audio)))
     nil
     0)))
