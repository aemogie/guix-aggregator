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
                        ("C-c m v" . my/mpv)
                        ("C-c m a" . my/play-album)
                        ("C-c w c" . my/clip-random-password)
                        ("C-c w t" . my/get-temp-pass)
                        ("C-c g t" . my/switch-theme)
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

;; (use-package which-key :config (which-key-mode 1))

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

(use-package nerd-icons)

(use-package doom-modeline
  :config (doom-modeline-mode 1)
  :after (nerd-icons))

(setf mode-line-compact 'long)

(setf display-time-format "%R"
      display-time-default-load-average nil)
(display-time-mode 1)

(setf display-line-numbers-type t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'org-mode-hook 'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)

(column-number-mode 1)

(custom-set-faces
 '(default
   ((t (:slant normal :height 120 :width normal :family "Hack"))))
 '(italic
   ((t (:slant italic)))))

(defun my/enable-theme (theme opacity)
  (enable-theme theme)
  (set-frame-parameter nil 'alpha-background opacity)
  (setf (cdr (assoc 'alpha-background default-frame-alist)) opacity))

(defun my/switch-theme ()
  "cycle between loaded themes"
  (interactive)
  (let ((current-theme (car custom-enabled-themes)))
    (if (cl-every #'boundp '(*my/dark-theme* *my/light-theme*))
        (progn (disable-theme current-theme)
               (if (eq current-theme *my/dark-theme*)
                   (my/enable-theme *my/light-theme* 100)
                 (my/enable-theme *my/dark-theme* 80)))
      (message "must define both *my/dark-theme* and *my/light-theme*"))))

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-light-medium t t)
  (load-theme 'gruvbox-dark-hard t)
  (defvar *my/light-theme* 'gruvbox-light-medium)
  (defvar *my/dark-theme* 'gruvbox-dark-hard))

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

(use-package consult)
(use-package vertico :config (vertico-mode 1))

(use-package marginalia :config (marginalia-mode 1))

(pixel-scroll-precision-mode 1)

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

(defun my/compile ()
  (interactive)
  (save-window-excursion (compile compile-command)))

(use-package paredit
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . paredit-mode))

(use-package rainbow-delimiters
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . rainbow-delimiters-mode))

(use-package aggressive-indent
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . aggressive-indent-mode))

(use-package sly
  :defer t
  :init
  (setf inferior-lisp-program "sbcl")
  (setf sly-mrepl-history-file-name "~/.config/emacs/sly/sly-mrepl-history")
  :hook (sly-mrepl-mode . rainbow-delimiters-mode)
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

(defmacro my/go-macro (command)
  `(lambda ()
     (interactive)
     (shell-command
      (format "go %s %s" ,command (buffer-file-name (current-buffer))))))

(add-hook 'go-mode-hook
      (lambda ()
        (setf tab-width 4)
        (local-set-key
         (kbd "C-c C-c")
         (my/go-macro "build"))
        (local-set-key
         (kbd "C-c C-r")
         (my/go-macro "run"))))

(setf geiser-guile-binary "/run/current-system/profile/bin/guile")
(setf geiser-guile-load-init-file t)
(setf geiser-repl-add-project-paths nil)

(fset #'jsonrpc--log-event #'ignore)

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
              (call-interactively command)
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

(setf eshell-prompt-function
      (lambda ()
        (concat
         (propertize (concat "\n " (eshell/pwd) "\n"))
         (propertize (if (= (user-uid) 0) " #" " λ"))
         (propertize " "))))

(setf eshell-prompt-regexp ".* λ ")

(defun my/sudo-shell-command (command)
  "Run COMMAND as root via Tramp."
  (interactive "MShell command (root): ")
  (with-temp-buffer
    (cd "/sudo::/")
    (async-shell-command command)))

(use-package magit
  :defer t
  :hook (magit-mode . (lambda ()
                        (my/activate-keybinds t))))

(use-package pinentry
  :config
  (setf epg-pinentry-mode 'loopback)
  (pinentry-start))

(setf org-startup-folded t)

(add-hook 'org-mode-hook (lambda () (org-indent-mode 1)))

(setf org-edit-src-content-indentation 0)

(use-package org-bullets :hook (org-mode . org-bullets-mode))

(use-package ox-beamer :defer t)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (format "pdflatex %s" (buffer-file-name)))
            (keymap-local-set "C-c c" 'my/compile)))

(use-package org-static-blog
  :defer t
  :config (load (expand-file-name "blog-config.el" user-emacs-directory)))

(use-package mu4e
  :defer t
  :config (setf mu4e-drafts-folder "/Drafts"
                mu4e-sent-folder "/Sent"
                mu4e-trash-folder "/Trash"

                mu4e-get-mail-command (format "INSIDE_EMACS=%s mbsync -a"
                                              emacs-version)))

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
  :defer t
  :config
  (setf elfeed-db-directory
        (expand-file-name "elfeed-db" user-emacs-directory))
  (setf elfeed-search-filter "@3-months-ago")
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

(context-menu-mode 1)

(global-auto-revert-mode 1)

(setf use-short-answers t)

(setq-default indent-tabs-mode nil
              electric-indent-mode nil
              tab-width 4)
;; (setf indent-line-function 'insert-tab)

(add-hook 'prog-mode-hook 'electric-indent-local-mode)

(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(defun my/clear-all-registers ()
  (interactive)
  (dolist (register-pair register-alist)
    (let ((register-name (car register-pair)))
      (when (get-register register-name)
        (set-register register-name nil)))))
