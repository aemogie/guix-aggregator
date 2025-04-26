(setf default-directory (format "%s/" (getenv "HOME")))
(setf custom-file (expand-file-name "custom.el" user-emacs-directory))

(defvar authentication-file
  (expand-file-name "authentication.el" user-emacs-directory))

(load custom-file)
(load authentication-file)

(setf backup-directory-alist '(("." . "~/.config/emacs/backups"))
      backup-by-copying t)

(defvar *my/keybinds* '(("M-<tab>" . next-buffer)
                        ("M-<iso-lefttab>" . previous-buffer)
                        ("M-0" . delete-window)
                        ("M-1" . delete-other-windows)
                        ("M-2" . split-window-right)
                        ("M-3" . split-window-below)
                        ("M-]" . next-window-any-frame)
                        ("M-[" . previous-window-any-frame)
                        ("C-x b" . consult-buffer)
                        ("C-c r s" . consult-register-store)
                        ("C-c r l" . consult-register-load)
                        ("C-c k" . kill-buffer-and-window)
                        ("C-c g t" . ef-themes-toggle)
                        ("C-c m v" . my/mpv)
                        ("C-c m a" . my/play-album)
                        ("C-c b h" . my/hide-buffer)
                        ("C-c b u" . my/unhide-buffer)
                        ("C-c r y" . my/add-youtube-feed)))

(defun my/activate-keybinds (&optional local)
  "Activate personal keybinds stored in `*my/keybinds*'.
If LOCAL is NIL set globally with `keymap-global-set'.
Otherwise set locally with `keymap-local-set'."
  (interactive "P")
  (let ((setter-function (if local 'keymap-local-set 'keymap-global-set)))
    (dolist (key-and-function *my/keybinds*)
      (funcall setter-function (car key-and-function) (cdr key-and-function)))))

(my/activate-keybinds)

(use-package which-key
  :if (>= emacs-major-version 30)
  :config (which-key-mode 1))

(add-to-list 'default-frame-alist '(alpha-background . 85))

(setf initial-scratch-message nil
      inhibit-startup-screen t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(blink-cursor-mode -1)
(global-hl-line-mode 1)
(global-visual-line-mode 1)

(setf frame-title-format "%b")
(add-to-list 'default-frame-alist '(undecorated . t))

(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-modified
                "    "
                mode-line-buffer-identification
                "  "
                mode-line-position-column-line-format
                "  "
                (vc-mode vc-mode)
                "  "
                mode-name
                "  "
                mode-line-misc-info
                mode-line-end-spaces))

(setf mode-line-compact 'long)

(setf display-time-format "%R"
      display-time-default-load-average nil)
(display-time-mode 1)

(setf display-line-numbers-type t)

(dolist (hook '(conf-mode-hook org-mode-hook prog-mode-hook))
  (add-hook hook 'display-line-numbers-mode))

(column-number-mode 1)

(defvar *my/font* "DejaVu Sans Mono")

(set-face-attribute 'default nil
                    :font *my/font*
                    :slant 'normal
                    :height 120)

(set-face-attribute 'italic nil
                    :slant 'italic
                    :underline nil)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(global-prettify-symbols-mode 1)

(defun my/enable-theme (theme opacity)
  (enable-theme theme)
  (set-frame-parameter nil 'alpha-background opacity)
  (setf (cdr (assoc 'alpha-background default-frame-alist)) opacity))

(defun my/switch-theme ()
  "cycle between loaded themes"
  (interactive)
  (let ((current-theme (car custom-enabled-themes)))
    (if (cl-every #'boundp '(*my/dark-theme* *my/light-theme*))
        (if (eq current-theme *my/dark-theme*)
            (my/enable-theme *my/light-theme* 100)
          (my/enable-theme *my/dark-theme* 75))
      (message "must define both *my/dark-theme* and *my/light-theme*"))))

(defun my/adjust-opacity ()
  (interactive)
  (set-frame-parameter nil 'alpha-background
                       (if (member (ef-themes--current-theme)
                                   ef-themes-light-themes)
                           100
                         80)))

(use-package ef-themes
  :config
  (advice-add 'ef-themes-toggle :after #'my/adjust-opacity)
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

(use-package consult
  :config (delete 'consult--source-recent-file consult-buffer-sources))

(use-package vertico
  :config (vertico-mode 1))

(use-package marginalia
  :config (marginalia-mode 1))

(use-package disable-mouse
  :config (global-disable-mouse-mode 1))

(setf scroll-conservatively 10000
      auto-window-vscroll nil)

(unless (boundp '*hidden-buffers*)
  (defvar *hidden-buffers* ()
    "List of buffer names to be ignored by `next-buffer' and `previous-buffer'.
See also `my/hide-buffer' and `hidden-buffer-p'."))

(with-eval-after-load 'savehist
  (add-to-list 'savehist-additional-variables '*hidden-buffers*))

(defun hidden-buffer-p (window buffer bury-or-kill)
  "Hide buffers with name in `*hidden-buffers*'.
See also `switch-to-prev-buffer-skip'."
  (cl-find (buffer-name buffer) *hidden-buffers* :test #'string=))

(customize-set-variable 'switch-to-prev-buffer-skip 'hidden-buffer-p)

(defun my/hide-buffer (&optional buffer-name)
  "Adds BUFFER-NAME to `*hidden-buffers*'.
If BUFFER-NAME is NIL then the current buffer name is used via `buffer-name'.
See also `my/unhide-buffer'."
  (interactive)
  (cl-pushnew (if buffer-name
                  buffer-name
                (buffer-name))
              *hidden-buffers*
              :test #'string=))

(defun my/unhide-buffer (&optional buffer-name)
  "Removes BUFFER-NAME from `*hidden-buffers*'.
If BUFFER-NAME is NIL then the current buffer name is used via `buffer-name'.
See also `my/hide-buffer'."
  (interactive)
  (setf *hidden-buffers* (remove (if buffer-name
                                     buffer-name
                                   (buffer-name))
                                 *hidden-buffers*)))

(use-package delsel
  :config (delete-selection-mode 1))

(setq-default indent-tabs-mode nil
              electric-indent-mode nil
              tab-width 4)

(add-hook 'prog-mode-hook 'electric-indent-local-mode)

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
  (save-window-excursion (compile compile-command)))

(defun my/set-compile-command (command)
  (set (make-local-variable 'compile-command)
       command))

(use-package paredit
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . paredit-mode))

(use-package rainbow-delimiters
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . rainbow-delimiters-mode))

(use-package aggressive-indent
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . aggressive-indent-mode))

(use-package sly
  :commands (sly)
  :hook (sly-mrepl-mode . rainbow-delimiters-mode)
  :config
  (setf inferior-lisp-program "sbcl"
        sly-mrepl-history-file-name "~/.config/emacs/sly/sly-mrepl-history")
  :after (rainbow-delimiters))

(defun my/remove-all-advice (sym)
  (interactive)
  (advice-mapc (lambda (advice _props)
                 (advice-remove sym advice))
               sym))

(when (executable-find "agda-mode")
  (load-file (let ((coding-system-for-read 'utf-8))
               (shell-command-to-string "agda-mode locate")))
  (setf auto-mode-alist (cons '("\\.lagda.md$" . agda2-mode) auto-mode-alist)))

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

(use-package geiser)

(use-package geiser-guile
  :config
  (setf geiser-guile-load-init-file t)
  :after (geiser))

(use-package org
  :defer t
  :config
  (setf org-startup-folded t
        org-edit-src-content-indentation 0
        org-babel-python-command "python3")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (scheme . t)
     (python . t)
     (shell . t)
     (eshell . t))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package ox-beamer
  :after (org))

(defun my/set-latex-compile ()
  (my/set-compile-command (format "pdflatex %s" (buffer-file-name))))

(use-package latex
  :defer t
  :hook (LaTeX-mode . my/set-latex-compile)
  :bind (:map LaTeX-mode-map
              ("C-c C-c" . my/compile)))

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
      (mapc (lambda (filepath)
              (find-file filepath)
              (funcall command)
              (unless (member (buffer-name) open-file-buffers)
                (save-buffer)
                (kill-buffer)))
            (dired-get-marked-files)))))

(fset 'epg-wait-for-status 'ignore)

(setf delete-by-moving-to-trash t)

(use-package trashed
  :commands (trashed)
  :config
  (setf trashed-sort-key '("Date deleted" . t)
        trashed-date-format "%Y-%m-%d %H:%M:%S"
        trashed-use-header-line t))

(defun my/eshell-clear ()
  (interactive)
  (eshell/clear-scrollback))

(use-package eshell
  :commands (eshell)
  :bind (:map eshell-mode-map
              ("C-c M-o" . my/eshell-clear))
  :config
  (setf eshell-prompt-function
        (lambda ()
          (concat
           (propertize (concat "\n " (eshell/pwd) "\n"))
           (propertize (if (= (user-uid) 0) " #" " λ"))
           (propertize " "))))
  (setf eshell-prompt-regexp ".* λ "))

(defun my/sudo-shell-command (command)
  "Run COMMAND as root via Tramp."
  (interactive "MShell command (root): ")
  (with-temp-buffer
    (cd "/sudo::/")
    (async-shell-command command)))

(use-package eat
  :hook (eshell-load . eat-eshell-mode))

(use-package magit
  :commands (magit)
  :hook (magit-mode . (lambda () (my/activate-keybinds t))))

(use-package pinentry
  :config
  (setf epg-pinentry-mode 'loopback)
  (pinentry-start))

(use-package org-static-blog
  :defer t
  :config (load (expand-file-name "blog-config.el" user-emacs-directory)))

(setf eww-default-download-directory "~/downloads")

(use-package mu4e
  :commands (mu4e)
  :config
  (setf mu4e-drafts-folder "/Drafts"
        mu4e-sent-folder "/Sent"
        mu4e-trash-folder "/Trash"

        mail-user-agent 'mu4e-user-agent
        mu4e-get-mail-command (format "INSIDE_EMACS=%s mbsync -a"
                                      emacs-version))
  (mu4e-modeline-mode -1))

(defun my/make-youtube-feed (channel-url)
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
  (interactive)
  (let ((album-name (shell-quote-argument
                     (file-name-nondirectory (dired-get-filename)))))
    (call-process-shell-command
     (format "mpv --input-ipc-server=/tmp/mpv-socket --playlist=%s/%s--Album.txt"
             album-name album-name)
     nil
     0)))

(defun my/mpv (&optional mpv-command)
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

(setf large-file-warning-threshold 10000000)

(global-auto-revert-mode 1)

(setf use-short-answers t)

(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(defun my/clear-all-registers ()
  (interactive)
  (dolist (register-pair register-alist)
    (let ((register-name (car register-pair)))
      (when (get-register register-name)
        (set-register register-name nil)))))

(setq-default buffer-file-coding-system 'utf-8-unix)
