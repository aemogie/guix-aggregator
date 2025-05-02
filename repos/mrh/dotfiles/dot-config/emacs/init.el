(setf default-directory (format "%s/" (getenv "HOME")))

(setf custom-file
      (expand-file-name "custom.el" user-emacs-directory))
(defvar personal-data
  (expand-file-name "personal.el" user-emacs-directory))

(load custom-file)
(load personal-data)

(setf large-file-warning-threshold 10000000)

(global-auto-revert-mode 1)

(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(setq-default buffer-file-coding-system 'utf-8-unix)

(add-to-list 'backup-directory-alist
             `("." . ,(expand-file-name "backups" user-emacs-directory)))

(setf backup-by-copying t)

(use-package dired
  :commands (dired)
  :hook (dired-mode . dired-hide-details-mode)
  :config (setf dired-listing-switches "-Ahl --group-directories-first"
                dired-kill-when-opening-new-dired-buffer t
                dired-dwim-target t))

(use-package diredfl
  :after dired
  :config (diredfl-global-mode t))

(defun my/get-open-file-buffers ()
  (with-temp-buffer
    (list-buffers t)
    (insert-buffer "*Buffer List*")
    (kill-buffer "*Buffer List*")
    (mapcar (lambda (line)
              (let ((parts (string-split (string-trim-left line))))
                (if (string= "*" (car parts))
                    (cadr parts)
                  (car parts))))
            (butlast
             (split-string
              (buffer-substring-no-properties (point-min) (point-max))
              "\n")))))

(defun my/dired-run-command (command)
  "Run COMMAND on marked files.
If a buffer containing the file is open it will be affected but the changes will not be written.
If a there is no open buffer containing the file the changes will be written."
  (interactive "CRun on marked files: ")
  (let ((open-file-buffers (my/get-open-file-buffers)))
    (save-window-excursion
      (dolist (filepath (dired-get-marked-files))
        (find-file filepath)
        (funcall command)
        (unless (member (buffer-name) open-file-buffers)
          (save-buffer)
          (kill-buffer))))))

(fset 'epg-wait-for-status 'ignore)

(setf delete-by-moving-to-trash t)

(use-package trashed
  :commands (trashed)
  :config
  (setf trashed-sort-key '("Date deleted" . t)
        trashed-date-format "%Y-%m-%d %H:%M:%S"
        trashed-use-header-line t))

(defvar *my/keybinds* '(("M-<tab>" . next-buffer)
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
  "Activate personal keybinds stored in `*my/keybinds*'.
If LOCAL is nil set globally with `keymap-global-set'.
Otherwise set locally with `keymap-local-set'."
  (interactive "P")
  (let ((setter-function (if local 'keymap-local-set 'keymap-global-set)))
    (dolist (key-and-function *my/keybinds*)
      (funcall setter-function (car key-and-function) (cdr key-and-function)))))

(my/activate-keybinds)

(use-package which-key
  :if (>= emacs-major-version 30)
  :config (which-key-mode 1))

(repeat-mode 1)

(add-to-list 'default-frame-alist '(alpha-background . 80))

(setf initial-scratch-message nil
      inhibit-startup-screen t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(blink-cursor-mode -1)

(setf frame-title-format "%b")
(add-to-list 'default-frame-alist '(undecorated . t))

(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-modified
                "  "
                mode-line-buffer-identification
                "  "
                mode-line-position-column-line-format
                "  "
                (vc-mode vc-mode)
                "  "
                mode-name
                "  "
                (:eval (unless (zerop text-scale-mode-amount)
                         text-scale-mode-lighter))
                "  "
                mode-line-misc-info
                mode-line-end-spaces))

(setf mode-line-compact 'long)

(setf display-time-format "%R"
      display-time-default-load-average nil)
(display-time-mode 1)

(global-hl-line-mode 1)
(global-visual-line-mode 1)

(setf display-line-numbers-type t)

(dolist (hook '(conf-mode-hook nxml-mode-hook prog-mode-hook))
  (add-hook hook 'display-line-numbers-mode))

(set-face-attribute 'default nil
                    :family "DejaVu Sans Mono"
                    :slant 'normal
                    :height 125)

(set-face-attribute 'fixed-pitch nil
                    :family "DejaVu Sans Mono"
                    :slant 'normal
                    :height 125)

(set-face-attribute 'variable-pitch nil
                    :family "DejaVu Serif"
                    :slant 'normal
                    :height 160)

(set-face-attribute 'italic nil
                    :slant 'italic
                    :underline nil)

(add-hook 'text-mode-hook #'variable-pitch-mode)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(global-prettify-symbols-mode 1)

(defun my/adjust-opacity ()
  "Make sure opacity is correct for given theme."
  (set-frame-parameter nil 'alpha-background
                       (if (member (ef-themes--current-theme)
                                   ef-themes-light-themes)
                           100
                         80)))

(defun my/fontify-org-buffers ()
  "Fontify all org buffers.
Helpful advice for face changing functions."
  (interactive)
  (save-current-buffer
    (dolist (buffer (buffer-list))
      (set-buffer buffer)
      (when (eq major-mode 'org-mode)
        (font-lock-fontify-buffer)))))

(use-package ef-themes
  :config
  (advice-add 'ef-themes-toggle :after #'my/adjust-opacity)
  (advice-add 'ef-themes-toggle :after #'my/fontify-org-buffers)
  (setf ef-themes-mixed-fonts t)
  (setf ef-themes-to-toggle '(ef-autumn ef-eagle))
  (ef-themes-select-dark 'ef-autumn))

(use-package orderless 
  :config
  (setf completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides nil))

(use-package corfu 
  :init
  (setq-default pgtk-wait-for-event-timeout 0)
  :config
  (setf corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-count 8
        corfu-popupinfo-delay '(1.5 . 0.5))
  
  (add-to-list 'corfu--frame-parameters '(alpha-background . 100))
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package vertico
  :config (vertico-mode 1))

(setf use-short-answers t)

(use-package marginalia
  :config (marginalia-mode 1)
  :after (vertico))

(use-package disable-mouse
  :config (global-disable-mouse-mode 1))

(setf scroll-conservatively 10000
      auto-window-vscroll nil)

(use-package consult
  :config (setf consult-buffer-sources
                '(consult--source-hidden-buffer
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

(setf switch-to-prev-buffer-skip 'hidden-buffer-p)

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

(use-package delsel
  :config (delete-selection-mode 1))

(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)

(setf ispell-personal-dictionary (format "%s/documents/personal-dictionary"
                                         (getenv "HOME")))

(use-package writeroom-mode
  :config
  (setf writeroom-width 80
        writeroom-fullscreen-effect 'maximized
        writeroom-major-modes '(text-mode))
  (global-writeroom-mode))

(setq-default indent-tabs-mode nil
              tab-width 4)

(defun my/dired-tabify-files (&optional untabify)
  "Run eitheir `tabify' or `untabify' on marked files in dired.
See `my/dired-run-command'."
  (interactive "P")
  (let ((tab-function (if untabify #'untabify #'tabify)))
    (my/dired-run-command
     (lambda ()
       (funcall tab-function (point-min) (point-max))))))

(fset #'jsonrpc--log-event #'ignore)

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

(keymap-set lisp-interaction-mode-map "C-c C-c" 'eval-print-last-sexp)

(defun my/remove-all-advice (sym)
  "Remove all advice from function designated by symbol SYM."
  (interactive)
  (advice-mapc (lambda (advice _props)
                 (advice-remove sym advice))
               sym))

(use-package geiser)

(use-package geiser-guile
  :commands (geiser-guile)
  :config
  (setf geiser-guile-load-init-file t)
  :after (geiser))

(use-package sly
  :commands (sly)
  :config
  (setf inferior-lisp-program "sbcl")
  (setf sly-mrepl-history-file-name
        (expand-file-name "sly/sly-mrepl-history" user-emacs-directory))
  (when (featurep 'rainbow-delimiters)
    (add-hook 'sly-mrepl-mode-hook 'rainbow-delimiters-mode)))

(use-package agda2-mode
  :defer t
  :init (add-to-list 'auto-mode-alist '("\\.lagda.md$" . agda2-mode)))

(defun my/set-go-compile ()
  (my/set-compile-command "go build"))

(defun my/go-run ()
  (interactive)
  (shell-command "go run"))

(use-package go-mode
  :hook (go-mode . my/set-go-compile)
  :bind (:map go-mode-map
              ("C-c C-c" . my/compile)
              ("C-c C-r" . my/go-run)))

(use-package org
  :defer t
  :hook (org-mode . org-indent-mode)
  :bind (:map org-mode-map
              ("C-c l" . org-cycle-list-bullet))
  :config
  (setf org-directory (expand-file-name "documents/org/" (getenv "HOME")))
  (setf org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-agenda-files (list (expand-file-name "agenda/" org-directory))
        
        org-startup-folded t
        org-M-RET-may-split-line '((default . nil))
        org-insert-heading-respect-content t

        org-log-done 'time
        org-log-into-drawer t
        org-todo-keywords
        '((sequence "TODO(t)" "BLOCKED(b)" "|" "CANCELED(c)" "DONE(d)"))
        
        org-edit-src-content-indentation 0
        org-babel-python-command "python3")
  
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
  :hook (org-mode . org-bullets-mode))

(use-package ox-beamer
  :after (org))

(use-package org-publish-rss
  :defer t
  :config
  (setf org-publish-rss-publish-immediately t))

(use-package ox-publish
  :config
  (load (expand-file-name "org-publish.el" user-emacs-directory))
  :after (jack org-publish-rss))

(use-package markdown-mode
  :defer t)

(defun my/set-latex-compile ()
  (my/set-compile-command (format "pdflatex %s" (buffer-file-name))))

(use-package latex
  :defer t
  :hook (LaTeX-mode . my/set-latex-compile)
  :bind (:map LaTeX-mode-map
              ("C-c C-c" . my/compile)))

(dolist (hook '(comint-mode-hook eshell-mode-hook))
  (add-hook hook (lambda () (setq-local global-hl-line-mode nil))))

(defun my/eshell-clear ()
  (interactive)
  (eshell/clear-scrollback))

(use-package eshell
  :commands (eshell)
  :hook (eshell-mode . (lambda () (keymap-set eshell-mode-map
                                         "C-c M-o"
                                         'my/eshell-clear)))
  :config
  (setf eshell-prompt-function
        (if (featurep 'ef-themes)
            (lambda ()
              (let* ((palette (ef-themes--current-theme-palette))
                     (orange (cadr (assoc 'yellow-warmer palette)))
                     (green (cadr (assoc 'green-warmer palette))))
                (format "\n %s\n %s "
                        (propertize
                         (eshell/pwd)
                         'face `(:foreground ,orange :weight bold))
                        (propertize
                         (if (zerop (user-uid)) "#" "λ")
                         'face `(:foreground ,green :weight bold)))))
          (lambda ()
            (format "\n %s\n λ " (eshell/pwd)))))
  (setf eshell-prompt-regexp ".* λ "))

(defun my/sudo-shell-command (command)
  "Run COMMAND as root via Tramp."
  (interactive "MShell command (root): ")
  (with-temp-buffer
    (cd "/sudo::/")
    (async-shell-command command)))

(use-package buffer-env
  :commands (buffer-env-update buffer-env-reset))

(use-package eat
  :hook (eshell-load . eat-eshell-mode))

(use-package magit
  :commands (magit)
  :hook (magit-mode . (lambda () (my/activate-keybinds t))))

(use-package pinentry
  :config
  (setf epg-pinentry-mode 'loopback)
  (pinentry-start))

(use-package bluetooth
  :commands (bluetooth-list-devices))

(use-package tldr
  :commands (tldr tldr-update-docs))

(use-package wgrep)

(use-package htmlize)
(use-package jack)

(setf eww-default-download-directory "~/downloads")

(use-package mu4e
  :commands (mu4e)
  :config
  (setf mu4e-drafts-folder "/Drafts"
        mu4e-sent-folder "/Sent"
        mu4e-trash-folder "/Trash"

        mail-user-agent 'mu4e-user-agent
        mu4e-get-mail-command (format "INSIDE_EMACS=%s mbsync -a"
                                      emacs-version)

        mu4e-modeline-support nil))

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

(defun my/kill-elfeed-search-buffer ()
  (kill-buffer "*elfeed-search*"))

(use-package elfeed
  :commands (elfeed)
  :config
  (setf elfeed-db-directory
        (expand-file-name "elfeed-db" user-emacs-directory))
  (setf elfeed-search-filter "@6-months-ago +unread")
  (load (expand-file-name "feeds.el" user-emacs-directory))
  (advice-add 'elfeed-search-quit-window :after #'my/kill-elfeed-search-buffer))

(setf gnus-use-dribble-file nil)

(defun my/play-album ()
  "Play album in directory at point via mpv.

Opens a socket at =/tmp/mpv-socket= to which mpv commands can be sent
(such as pause, play, next, etc.).

Directory name must be the name of the album, contain the song files,
and contain a file =<album-name>--Album.txt= which lists the song files
in desired playing order, separated by newlines.

See https://codeberg.org/mrh/dotfiles/dot-local/bin for more info."
  (interactive)
  (let ((album-name (shell-quote-argument
                     (file-name-nondirectory (dired-get-filename)))))
    (call-process-shell-command
     (format "mpv --input-ipc-server=/tmp/mpv-socket --playlist=%s/%s--Album.txt"
             album-name album-name)
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
