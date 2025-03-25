(setf default-directory (format "%s/" (getenv "HOME")))
(setf custom-file (expand-file-name "custom.el" user-emacs-directory))

(defvar authentication-file (expand-file-name "authentication.el" user-emacs-directory))

(load custom-file)
(load authentication-file)

(defvar *my/keybinds* '(("M-<tab>" . next-buffer)
                        ("M-<iso-lefttab>" . previous-buffer)
                        ("M-0" . delete-window)
                        ("M-1" . delete-other-windows)
                        ("M-2" . split-window-right)
                        ("M-3" . split-window-below)
                        ("M-]" . next-window-any-frame)
                        ("M-[" . previous-window-any-frame)
                        ("C-x b" . consult-buffer)
                        ("C-c m v" . my/mpv)
                        ("C-c m a" . my/play-album)
                        ("C-c w c" . my/clip-random-password)
                        ("C-c w t" . my/get-temp-pass)
                        ("C-c g t" . my/switch-theme)
                        ("C-c b h" . my/hide-buffer)
                        ("C-c b u" . my/unhide-buffer)))

(defun set-keys-with (setter-function)
  (interactive)
  (mapc (lambda (key-and-function)
          (funcall setter-function (car key-and-function) (cdr key-and-function)))
        *my/keybinds*))

(set-keys-with 'keymap-global-set)

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-light-hard)
  (load-theme 'gruvbox-dark-hard)
  (enable-theme 'gruvbox-dark-hard))

(use-package marginalia
  :config (marginalia-mode 1))

(use-package orderless
  :init
  (setf completion-styles '(orderless basic)))

;; (use-package which-key
;;   :config (which-key-mode 1))

(use-package doom-modeline
  :config (doom-modeline-mode 1))

(use-package pinentry
  :init
  (setf epg-pinentry-mode 'loopback)
  :config
  (pinentry-start))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package paredit
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . paredit-mode))

(use-package aggressive-indent
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . aggressive-indent-mode))

(use-package rainbow-delimiters
  :hook
  ((lisp-mode emacs-lisp-mode scheme-mode) . rainbow-delimiters-mode)
  ;; ((lisp-mode emacs-lisp-mode scheme-mode sly-mrepl-mode) . rainbow-delimiters-mode)
  )

(use-package vertico
  :init
  (setf completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion-in-region)
                 args)))
  :config
  (vertico-mode 1))

(use-package expand-region
  :init
  (keymap-global-set "C-=" 'er/expand-region)
  (keymap-global-set "C--" 'er/contract-region))

(use-package corfu 
  :init
  (setq-default pgtk-wait-for-event-timeout 0)
  (setf corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-count 8)
  :config
  (push '(alpha-background . 100) corfu--frame-parameters)
  (global-corfu-mode 1))

(use-package eat :hook (eshell-load . eat-eshell-mode))

;; (use-package ligature
;;   :config
;;   (let ((ligs '("<|" "|>" "<--" "-->" "->" "=>" "<-->" "::")))
;;     (ligature-set-ligatures 'prog-mode ligs)
;;     (ligature-set-ligatures 'org-mode ligs))

;;   (global-ligature-mode 1))

;; (use-package sly
;;   :init
;;   (setf inferior-lisp-program "sbcl")
;;   (setf sly-mrepl-history-file-name "~/.config/emacs/sly/sly-mrepl-history"))

(use-package diredfl
  :config
  (diredfl-global-mode t))

(use-package magit
  :hook (magit-mode . (lambda ()
                               (set-keys-with 'keymap-local-set))))

(setf backup-directory-alist '(("." . "~/.config/emacs/backups"))
      backup-by-copying t)

(add-to-list 'default-frame-alist '(alpha-background . 90))
;; (set-frame-parameter nil 'alpha-background 90)

(defun my/enable-theme (theme opacity)
  (enable-theme theme)
  (set-frame-parameter nil 'alpha-background opacity)
  (setf (cdr (assoc 'alpha-background default-frame-alist)) opacity))

(defun my/switch-theme ()
  "cycle between loaded themes"
  (interactive)
  (let ((current-theme (car custom-enabled-themes)))
    (disable-theme current-theme)
    (if (eq current-theme 'gruvbox-dark-hard)
        (my/enable-theme 'gruvbox-light-hard 100)
      (my/enable-theme 'gruvbox-dark-hard 80))))

(setf frame-title-format "%b - Emacs")

(setf initial-scratch-message nil)

(blink-cursor-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(add-to-list 'default-frame-alist '(undecorated . t))

(custom-set-faces
 '(default
   ((t (:slant normal :height 120 :width normal :family "Hack"))))
 '(italic
   ((t (:slant italic)))))

(global-prettify-symbols-mode 1)

(setf mode-line-compact 'long)

(setf display-line-numbers-type t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'org-mode-hook 'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)

(global-visual-line-mode 1)

(column-number-mode 1)

(setf display-time-format "%R"
      display-time-default-load-average nil)
(display-time-mode 1)

(setq-default indent-tabs-mode nil
              electric-indent-mode nil
              tab-width 4)
;; (setf indent-line-function 'insert-tab)

(add-hook 'prog-mode-hook 'electric-indent-local-mode)

(global-hl-line-mode 1)

(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(setf dired-listing-switches "-Ahl --group-directories-first")

(setf dired-kill-when-opening-new-dired-buffer t)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(setf dired-dwim-target t)

(defun my/get-open-file-buffers ()
  (save-window-excursion
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
                "\n"))))))

(defun my/dired-do-command (command)
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

(setf eshell-prompt-function
      (lambda ()
    (concat
     (propertize (concat "\n " (eshell/pwd) "\n") ;; 'face '(:foreground "#b8bb26")
             )
     ;; (propertize (user-login-name) 'face `(:foreground "#83a598"))
     ;; (propertize "@" 'face `(:foreground "#d9f5d7"))
     ;; (propertize (system-name) 'face `(:foreground "#d3869b"))
     (propertize (if (= (user-uid) 0) " #" " λ") ;; 'face '(:foreground "#fabd2f")
             )
     (propertize " " ;; 'face '(:foreground "#ebdbb2")
             ))))

(setf eshell-prompt-regexp ".* λ ")

;; (add-to-list 'tramp-remote-path "/run/current-system/profile/bin")

(setf geiser-guile-binary "/run/current-system/profile/bin/guile")
(setf geiser-guile-load-init-file t)
(setf geiser-repl-add-project-paths nil)

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

(unless (boundp '*hidden-buffers*)
    (defvar *hidden-buffers* '()))

(setf savehist-additional-variables '(*hidden-buffers*))

(defun hidden-buffer-p (window buffer bury-or-kill)
  (cl-find (buffer-name buffer) *hidden-buffers* :test #'string=))

(customize-set-variable 'switch-to-prev-buffer-skip 'hidden-buffer-p)

(defun my/hide-buffer ()
  "Adds buffer to \"hidden\" buffers list by name to be ignored by next-buffer and previous-buffer. See also *hidden-buffers* variable and \"unhide-buffer\" function."
  (interactive)
  (cl-pushnew (buffer-name) *hidden-buffers* :test #'string=))

(defun my/unhide-buffer ()
  "Removes buffer from \"hidden\" buffers list by name, so as to be seen by next-buffer and previous-buffer. See also *hidden-buffers* variable and \"hide-buffer\" function."
  (interactive)
  (setf *hidden-buffers* (remove (buffer-name) *hidden-buffers*)))

(defun my/play-album ()
  (interactive)
  (let ((album-name (shell-quote-argument
                     (file-name-nondirectory (dired-get-filename)))))
    (call-process-shell-command
     (format "mpv --input-ipc-server=/tmp/mpv-socket --playlist=%s/%s--Album.txt"
             album-name album-name)
     nil
     0)))

(defun my/mpv ()
  (interactive)
  (let ((audio (if (eq major-mode 'dired-mode)
                   (dired-get-filename)
                 (thing-at-point 'url))))
    (call-process-shell-command
     (format "mpv --profile=1200p --force-window=immediate --pause %s"
             (shell-quote-argument audio))
     nil
     0)))

(defun my/get-temp-pass ()
  (interactive)
  (call-process-shell-command
   (format "riverctl map normal Super+Shift T spawn \"wl-copy %s\""
       (read-from-minibuffer "temporary password: "))))

(defun my/clip-random-password ()
  (interactive)
  (call-process-shell-command "pwgen -Bcnys 20 | wl-copy"))

(setf org-startup-folded t)

(add-hook 'org-mode-hook (lambda () (org-indent-mode 1)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((scheme . t)
   (python . t)
   (R . t)))

(setf org-edit-src-content-indentation 0)

(require 'ox-beamer)
(require 'ox-haunt)

(setf ox-haunt-recognized-metadata '(:author :date :tags :title))

(setf proced-enable-color-flag t)

(setf proced-format-alist '((custom pid user start time pcpu pmem comm)))

(setf proced-sort 'pmem)

(fset #'jsonrpc--log-event #'ignore)

(fset 'epg-wait-for-status 'ignore)

(setf gnus-use-dribble-file nil)

(setf use-short-answers t)

(global-auto-revert-mode 1)

(repeat-mode 1)

(pixel-scroll-precision-mode 1)

(context-menu-mode 1)

(defun sudo-shell-command (command)
  (interactive "MShell command (root): ")
  (with-temp-buffer
    (cd "/sudo::/")
    (async-shell-command command)))
