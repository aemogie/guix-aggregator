(setopt default-directory "~/")

(defvar personal-data (expand-file-name "personal.el" user-emacs-directory))
(load personal-data)

(use-package cus-edit
  :defer nil
  :custom
  (custom-file null-device))

(use-package files
  :custom
  (large-file-warning-threshold 10000000)
  (backup-by-copying t)
  (safe-local-variable-directories '("~/.config/guix/current/share/guile/site/3.0/"
                                     "~/src/repos/guix"))
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
  :custom
  (trashed-sort-key '("Date deleted" . t))
  (trashed-date-format "%Y-%m-%d %H:%M:%S")
  (trashed-use-header-line t))

(defun my/os-release ()
  (interactive)
  (with-temp-buffer
    (insert-file-contents "/etc/os-release")
    (let ((line (thing-at-point 'line t)))
      (string-trim (cadr (string-split line "=")) "\"" "\"\n"))))

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
                        ("C-c c" . org-capture)
                        ("C-c k" . shr-maybe-probe-and-copy-url)
                        ("C-c t" . modus-themes-toggle)
                        ("C-c y" . consult-yank-from-kill-ring)
                        ("C-c b h" . my/hide-buffer)
                        ("C-c b k" . kill-buffer-and-window)
                        ("C-c b u" . my/unhide-buffer)
                        ("C-c m a" . my/play-album)
                        ("C-c m v" . my/mpv)
                        ("C-c p c" . org-publish-current-file)
                        ("C-c p p" . org-publish)
                        ("C-c r l" . consult-register-load)
                        ("C-c r s" . consult-register-store)))

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

(use-package consult
  :custom
  (consult-buffer-sources '(consult-source-hidden-buffer
                            consult-source-modified-buffer
                            consult-source-buffer
                            consult-source-bookmark
                            consult-source-recent-file
                            consult-source-file-register
                            consult-source-project-buffer-hidden
                            consult-source-project-recent-file-hidden
                            consult-source-project-root-hidden)))

(use-package isearch
  :custom
  (isearch-lazy-count t))

(setopt scroll-conservatively 10000
        auto-window-vscroll nil)

(use-package disable-mouse
  :custom
  (global-disable-mouse-mode-lighter . nil)
  :hook
  (after-init . global-disable-mouse-mode))

(defvar my/hidden-buffers '()
  "List of buffer names to be ignored by `next-buffer' and `previous-buffer'.
See also `my/hide-buffer' and `my/hidden-buffer-p'.")

(with-eval-after-load 'savehist
  (add-to-list 'savehist-additional-variables 'my/hidden-buffers))

(defun my/hidden-buffer-p (_window buffer _bury-or-kill)
  "Hide buffers with name in `my/hidden-buffers'.
See also `switch-to-prev-buffer-skip'."
  (member (buffer-name buffer) my/hidden-buffers))

(setopt switch-to-prev-buffer-skip 'my/hidden-buffer-p)

(defun my/hide-buffer (&optional buffer-name)
  "Adds BUFFER-NAME to `my/hidden-buffers'.
If BUFFER-NAME is nil then the current buffer name is used via `buffer-name'.
See also `my/unhide-buffer'."
  (interactive)
  (cl-pushnew (if buffer-name buffer-name (buffer-name))
              my/hidden-buffers
              :test #'string=))

(defun my/unhide-buffer (&optional buffer-name)
  "Removes BUFFER-NAME from `my/hidden-buffers'.
If BUFFER-NAME is nil then the current buffer name is used via `buffer-name'.
See also `my/hide-buffer'."
  (interactive)
  (setf my/hidden-buffers
        (remove (if buffer-name buffer-name (buffer-name))
                my/hidden-buffers)))

(setopt split-width-threshold 90)

(use-package delsel
  :config
  (delete-selection-mode 1))

(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(use-package ispell
  :custom
  (ispell-personal-dictionary "~/documents/personal-dictionary"))

(use-package writeroom-mode
  :custom
  (writeroom-width 90)
  (writeroom-fullscreen-effect 'maximized)
  (writeroom-major-modes '(text-mode))
  (writeroom-major-modes-exceptions '(mhtml-mode nxml-mode))
  :config
  (global-writeroom-mode -1))

(use-package prog-mode
  :config
  (global-prettify-symbols-mode 1))

(setopt indent-tabs-mode nil
        tab-width 4)

(use-package tabify
  :config
  (with-eval-after-load 'dired
    (defun my/dired-tabify-files (&optional untabify)
      "Run eitheir `tabify' or `untabify' on marked files in dired.
See `my/dired-run-command'."
      (interactive "P")
      (let ((tab-function (if untabify #'untabify #'tabify)))
        (my/dired-run-command
         (lambda ()
           (funcall tab-function (point-min) (point-max))))))))

(use-package jsonrpc
  :config
  (fset #'jsonrpc--log-event #'ignore))

(use-package compile
  :config
  (defun my/compile ()
    (interactive)
    (save-buffer)
    (save-window-excursion (compile compile-command)))

  (defun my/set-compile-command (command)
    (set (make-local-variable 'compile-command)
         command)))

(use-package paredit
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . paredit-mode))

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

(use-package scheme
  :when (string-equal (my/os-release) "Guix System")
  :config (load (expand-file-name "scheme-guix.el" user-emacs-directory)))

(use-package geiser)

(use-package geiser-guile
  :commands (geiser geiser-guile)
  :custom
  (geiser-guile-load-init-file t)
  :after geiser)

(use-package go-mode
  :disabled t
  :defer nil
  :bind
  (:map go-mode-map
        ("C-c C-r" . my/go-run))
  :config
  (defun my/go-run ()
    (interactive)
    (shell-command "go run"))
  
  (with-eval-after-load 'compile
    (defun my/set-go-compile ()
      (my/set-compile-command "go build"))

    (add-hook 'go-mode-hook #'my/set-go-compile)
    (keymap-set 'go-mode-map "C-c C-c" #'my/compile))  )

(setopt org-directory "~/documents/org/"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-agenda-files (list (expand-file-name "agenda/" org-directory)))

(use-package org
  :defer nil
  :hook
  (org-mode . org-indent-mode)
  :bind
  (:map org-mode-map
        ("C-c l" . org-cycle-list-bullet))
  :custom
  (org-startup-folded 'fold)
  (org-M-RET-may-split-line '((default . nil)))
  (org-clock-sound t)
  (org-insert-heading-respect-content t)
  (org-image-actual-width '(300))

  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-todo-keywords
   '((sequence "TODO(t)" "BLOCKED(b)" "|" "CANCELED(c)" "DONE(d)")))

  (org-edit-src-content-indentation 0)
  (org-babel-python-command "python3")
  :config
  (with-eval-after-load 'font-lock
    (defun my/fontify-org-buffers (&optional _theme)
      "Fontify all org buffers.
Helpful advice for face changing functions."
      (interactive)
      (save-current-buffer
        (dolist (buffer (buffer-list))
          (set-buffer buffer)
          (when (eq major-mode 'org-mode)
            (font-lock-fontify-buffer))))))

  (defun my/org-audio-link (path desc format)
    "Allow org to handle audio links."
    (when (equal format 'html)
      (format "<center><audio controls src=\"%s\" type=\"audio/ogg\">%s</audio></center>"
              path (or desc "your browser does not support the audio tag"))))

  (org-link-set-parameters "audio"
                           :follow #'my/mpv
                           :export #'my/org-audio-link
                           :complete #'org-link-complete-file)

  (add-to-list 'org-structure-template-alist '("m" . "src emacs-lisp"))

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
  :custom
  (org-bullets-bullet-list '("◉" "○" "❀" "✿" "◆" "◇" "✸"))
  :hook
  (org-mode . org-bullets-mode)
  :after org)

(use-package ox-beamer
  :after org)

(use-package ox-html
  :custom
  (org-html-htmlize-output-type 'css))

(use-package ox-publish
  :commands
  (org-publish org-publish-current-file)
  :config
  (use-package org-publish-rss
    :custom
    (org-publish-rss-publish-immediately t)
    (org-publish-rss-guid-method 'org-file-id-get-create))

  (load (expand-file-name "org-publish.el" user-emacs-directory))
  :after jack)

(defun my/org-publish-on-save ()
  (interactive)
  (add-hook 'after-save-hook 'org-publish-current-file 1 t))

(use-package org-capture
  :commands org-capture
  :custom
  (org-capture-templates
   '(("w" "website" entry
      (file+headline "" "Websites"))
     ("m" "misc" item
      (file+headline "" "Miscellaneous")))))

(use-package markdown-mode
  :defer nil)

(use-package latex
  :defer nil
  :hook
  (LaTeX-mode . my/set-latex-compile)
  :bind
  (:map LaTeX-mode-map
        ("C-c C-c" . my/compile))
  :config
  (defun my/set-latex-compile ()
    (my/set-compile-command (format "pdflatex %s" (buffer-file-name)))))

(use-package eshell
  :hook
  (eshell-mode . (lambda ()
                   (keymap-set eshell-mode-map "C-c M-o" #'my/eshell-clear)))
  :custom
  (eshell-prompt-function
   (lambda ()
     (if (featurep 'ef-themes)
         (let* ((palette (modus-themes-get-theme-palette))
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

(use-package buffer-env)

(use-package eat
  :config
  (with-eval-after-load 'eshell
    (add-hook 'eshell-mode-hook #'eat-eshell-mode)))

(use-package magit
  :commands magit
  :hook
  (magit-mode . (lambda () (my/activate-keybinds :local))))

(use-package pinentry
  :custom
  (epg-pinentry-mode 'loopback)
  :config
  (defun my/restart-pinentry ()
    (interactive)
    (pinentry-stop)
    (sleep-for 0.5)
    (pinentry-start))

  (pinentry-start))

(use-package bluetooth
  :commands bluetooth-list-devices)

(use-package tldr
  :commands
  (tldr tldr-update-docs))

(use-package wgrep)

(use-package nm)

(use-package htmlize)
(use-package jack)

(use-package eww
  :defer nil
  :commands eww
  :custom
  (eww-default-download-directory "~/downloads"))

(use-package message
  :config
  (defun my/disable-auto-fill-mode ()
    (auto-fill-mode -1))

  (add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)
  (add-hook 'message-mode-hook 'my/disable-auto-fill-mode))

(use-package mml-sec
  :custom
  (mml-secure-openpgp-sign-with-sender t))

(use-package mail-source
  :custom
  (mail-source-directory (expand-file-name "mail" user-emacs-directory)))

(use-package smtpmail
  :custom
  (smtpmail-queue-dir (expand-file-name "mail/queued-mail" user-emacs-directory)))

(use-package mu4e
  :commands mu4e
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
  (elfeed-search-filter "@1-month-ago")
  :config
  (defun my/kill-elfeed-search-buffer ()
    (kill-buffer "*elfeed-search*"))
  
  (load (expand-file-name "feeds.el" user-emacs-directory))
  (advice-add 'elfeed-search-quit-window :after #'my/kill-elfeed-search-buffer))

(defun my/erc-pounce ()
  "Connect to irc via tls using pounce server"
  (interactive)
  (erc-tls :server (format "irc.remote.%s" my/website-domain)
           :nick erc-nick))

(defun my/erc-libera ()
  "Connect to libera.chat irc via tls using certificate authorization"
  (interactive)
  (erc-tls :server "irc.libera.chat"
           :nick erc-nick
           :client-certificate t))

(use-package gnus
  :defer nil)

(use-package gnus-start
  :defer nil
  :custom
  (gnus-use-dribble-file nil)
  (gnus-directory (expand-file-name "news" user-emacs-directory))
  (gnus-startup-file (expand-file-name "newsrc" user-emacs-directory))
  :after gnus)

(defun my/play-album ()
  "Play album in directory at point via mpv.

Opens a socket at =/tmp/mpv-socket= to which mpv commands can be sent
(such as pause, play, next, etc.).

Directory name must be the name of the album, contain the song files,
and contain a file =<album-name>--Album.txt= which lists the song files
in desired playing order, separated by newlines.

See https://codeberg.org/mrh/dotfiles/dot-local/bin/ for more info."
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

(use-package image
  :custom
  (image-use-external-converter 'convert)
  (imagemagick-enabled-types t)
  :config
  (add-to-list 'image-file-name-extensions "avif"))
