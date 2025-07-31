;; generated from config.org via tangle
(require 'package)
(require 'use-package)

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode))

(use-package no-littering)
  (setq backup-directory-alist
	`((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms
	`((".*" ,temporary-file-directory t)))
  (setq create-lockfiles nil)
(setq custom-file "~/.emacs.d/custom.el")
(load-file custom-file)

(setq x-underline-at-descent-line t) ; for some reason there is an issue with modeline

(use-package mixed-pitch) ; prettier org mode

(use-package ligature
  :config
  ;; Enable all Iosevka ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->"
					 "<!--" "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>"
					 "<===>" "<====>" "<!---" "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!="
					 "===" "!==" ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:"
					 "=:" "<******>" "++" "+++"))
;; Enables ligature checks globally in all buffers. You can also do it
;; per mode with `ligature-mode'.
(global-ligature-mode t))

(use-package gruvbox-theme)
(load-theme 'gruvbox)

(use-package swiper)
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	   ("C-x b" . counsel-ibuffer)
	   ("C-x C-f" . counsel-find-file)
	   :map minibuffer-local-map
	   ("C-r" . counsel-minibuffer-history)))
(use-package ivy
  :diminish
  :bind (("C-s" . swiper-isearch))
  :config
  (ivy-mode 1))
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package elfeed)

(setq emms-browser-covers
    '((:browse-dir "~/Music")
      (:cover-name "cover.jpg" "folder.jpg" "AlbumArt.jpg")
      (:thumbnail-dir "~/.cache/emms/thumbnails")
      (:thumbnail-size 128)))
(use-package emms
  :commands (emms
             emms-stop
             emms-pause
             emms-next
             emms-previous
             emms-play-directory)
  :bind (("C-c e p" . emms)
         ("C-c e s" . emms-stop)
         ("C-c e SPC" . emms-pause)
         ("C-c e n" . emms-next)
         ("C-c e b" . emms-previous))
  :config
  (require 'emms-setup)
  (require 'emms-player-mpv)
  (emms-all)
  (setq emms-browser-covers 'emms-browser-cache-thumbnail-async)
  (setq emms-player-list '(emms-player-mpv))
  (setq emms-player-debug t)
  (setq emms-volume-change-function 'emms-volume-mpv-change))

(use-package dired-subtree
  :bind
  (:map dired-mode-map
	("<enter>" . lynn/dwim-toggle-or-open)
	("<return>" . lynn/dwim-toggle-or-open)
	("<tab>" . lynn/dwim-toggle-or-open))
  :config
    (setq dired-subtree-use-backgrounds nil))

(defun lynn/dwim-toggle-or-open ()
  "Toggle the subtree, or open a file."
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (if (and (file-directory-p file)
	     (not (or (string= file ".")
		      (string= file ".."))))
	(dired-subtree-toggle)
      (dired-find-file))))

(use-package pinentry
  :init
  (setf epa-pinentry-mode 'loopback)
  :config
  (pinentry-start))

(use-package org)
(use-package org-modern)
(use-package olivetti)
(use-package org-roam
  :custom
  (org-roam-directory "~/docs/roam/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-M-i"    . completion-at-point))
  :config
  (org-roam-setup))

(use-package auctex)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(use-package rainbow-mode)
(use-package simple-httpd)
(use-package htmlize)

(use-package flycheck)
;(use-package flycheck-pos-tip) this isn't packaged for guix, should find alternative? or package it?



(use-package meow)
    (defun meow-setup ()
      (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
      (meow-motion-overwrite-define-key
       '("j" . meow-next)
       '("k" . meow-prev)
       '("<escape>" . ignore))
      (meow-leader-define-key
       ;; SPC j/k will run the original command in MOTION state.
       '("j" . "H-j")
       '("k" . "H-k")
       ;; Use SPC (0-9) for digit arguments.
       '("1" . meow-digit-argument)
       '("2" . meow-digit-argument)
       '("3" . meow-digit-argument)
       '("4" . meow-digit-argument)
       '("5" . meow-digit-argument)
       '("6" . meow-digit-argument)
       '("7" . meow-digit-argument)
       '("8" . meow-digit-argument)
       '("9" . meow-digit-argument)
       '("0" . meow-digit-argument)
       '("/" . meow-keypad-describe-key)
       '("c" . compile)
       '("?" . meow-cheatsheet))
      (meow-normal-define-key
       ;; music stuff
       '("+" . emms-volume-raise)
       '("=" . emms-volume-lower)
        ;; regular meow
       '("0" . meow-expand-0)
       '("9" . meow-expand-9)
       '("8" . meow-expand-8)
       '("7" . meow-expand-7)
       '("6" . meow-expand-6)
       '("5" . meow-expand-5)
       '("4" . meow-expand-4)
       '("3" . meow-expand-3)
       '("2" . meow-expand-2)
       '("1" . meow-expand-1)
       '("-" . negative-argument)
       '(";" . meow-reverse)
       '("," . meow-inner-of-thing)
       '("." . meow-bounds-of-thing)
       '("[" . meow-beginning-of-thing)
       '("]" . meow-end-of-thing)
       '("a" . meow-append)
       '("A" . meow-open-below)
       '("b" . meow-back-word)
       '("B" . meow-back-symbol)
       '("c" . meow-change)
       '("d" . meow-delete)
       '("D" . meow-backward-delete)
       '("e" . meow-next-word)
       '("E" . meow-next-symbol)
       '("f" . meow-find)
       '("g" . meow-cancel-selection)
       '("G" . meow-grab)
       '("h" . meow-left)
       '("H" . meow-left-expand)
       '("i" . meow-insert)
       '("I" . meow-open-above)
       '("j" . meow-next)
       '("J" . meow-next-expand)
       '("k" . meow-prev)
       '("K" . meow-prev-expand)
       '("l" . meow-right)
       '("L" . meow-right-expand)
       '("m" . meow-join)
       '("n" . meow-search)
       '("o" . meow-block)
       '("O" . meow-to-block)
       '("p" . meow-yank)
       '("q" . meow-quit)
       '("Q" . meow-goto-line)
       '("r" . meow-replace)
       '("R" . meow-swap-grab)
       '("s" . meow-kill)
       '("t" . meow-till)
       '("u" . meow-undo)
       '("U" . meow-undo-in-selection)
       '("v" . meow-visit)
       '("w" . meow-mark-word)
       '("W" . meow-mark-symbol)
       '("x" . meow-line)
       '("X" . meow-goto-line)
       '("y" . meow-clipboard-save)
       '("Y" . meow-sync-grab)
       '("z" . meow-pop-selection)
       '("'" . repeat)
       '("<escape>" . ignore)))
(require 'meow)
(meow-setup)
(meow-global-mode 1)

(use-package eat :hook (eshell-load . eat-eshell-mode))

(use-package clang-format)

(use-package paredit
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . paredit-mode))

(use-package rainbow-delimiters
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . rainbow-delimiters-mode))

(use-package aggressive-indent
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . aggressive-indent-mode))

(use-package bqn-mode)
(defvar-local bqn--idle-timer nil
  "Idle timer to run `bqn-send-buffer` after user stops typing.")

(defcustom bqn-idle-send-delay 1.0
  "Seconds to wait after last input before sending buffer."
  :type 'number
  :group 'bqn)

(defun bqn--reset-idle-timer ()
  "Reset the idle timer to call `bqn-comint-eval-buffer`."
  (when bqn--idle-timer
    (cancel-timer bqn--idle-timer))
  (setq bqn--idle-timer
        (run-with-idle-timer bqn-idle-send-delay nil
                             (lambda ()
                               (when (derived-mode-p 'bqn-mode)
                                 (bqn-comint-eval-buffer))))))

(defun bqn-auto-eval-comint-buffer-on-idle ()
  "Enable automatic `bqn-eval-comint-buffer` after idle delay."
  (add-hook 'after-change-functions
            (lambda (&rest _) (bqn--reset-idle-timer))
            nil t))

(add-hook 'bqn-mode-hook #'bqn-auto-eval-comint-buffer-on-idle)

(defun run-apl ()
  (interactive)
  (let ((buf (get-buffer-create "*APL*")))
    (unless (comint-check-proc buf)
      (apply #'make-comint-in-buffer "APL" buf "apl" nil))
    (display-buffer buf
                    '((display-buffer-reuse-window display-buffer-at-bottom)
                      (window-height . 5)))))
(defun apl-process ()
  (let ((proc (get-buffer-process "*APL*")))
    (unless (and proc (process-live-p proc))
      (error "No active GNU APL process"))
    proc))
(defun apl-send-region (start end)
  (interactive "r")
  (let ((code (buffer-substring-no-properties start end)))
    (comint-send-string (apl-process) (concat code "\n"))))
(define-minor-mode apl-comint-mode
"Minor mode to send APL code to a comint interpreter."
:lighter " APL-REPL"
:keymap (let ((map (make-sparse-keymap)))
          (define-key map (kbd "C-c C-r") 'apl-send-region)
          (define-key map (kbd "C-c C-l") 'apl-send-line)
          map))

(use-package treesit
:commands (treesit-install-language-grammar treesit-install-all-languages)
:init
(setq treesit-language-source-alist
 '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
   (c . ("https://github.com/tree-sitter/tree-sitter-c"))
   (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
   (css . ("https://github.com/tree-sitter/tree-sitter-css"))
   (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
   (html . ("https://github.com/tree-sitter/tree-sitter-html"))
   (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
   (json . ("https://github.com/tree-sitter/tree-sitter-json"))
   (make . ("https://github.com/alemuller/tree-sitter-make"))
   (python . ("https://github.com/tree-sitter/tree-sitter-python"))
   (php . ("https://github.com/tree-sitter/tree-sitter-php"))
   (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
   (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
   (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
   (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
   (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
   (zig . ("https://github.com/maxxnino/tree-sitter-zig"))))
:config
(defun treesit-install-all-languages ()
  "Install all languages specified by `treesit-language-source-alist'."
  (interactive)
  (let ((languages (mapcar 'car treesit-language-source-alist)))
    (dolist (lang languages)
        (treesit-install-language-grammar lang)
        (message "`%s' parser was installed." lang)
        (sit-for 0.75)))))

(use-package company
  :hook
  (zig-mode . company-mode)
  (c-mode . company-mode))
(use-package jsonrpc)
(use-package eglot
  :hook
  (zig-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  :config
  (setq eglot-autoshutdown t)
  (add-to-list 'eglot-server-programs
               '(zig-mode . ("~/.guix-profile/bin/zls")))
  (add-to-list 'eglot-server-programs
               '(c-mode) . ("clangd")))

(use-package zig-mode)

(use-package yaml-mode)
(use-package outline-indent
  :commands outline-indent-minor-mode
  :custom
  (outline-indnet-ellipsis" ▼ "))

(use-package buffer-env
  :config
  (add-hook 'hack-local-variables-hook #'buffer-env-update)
  (add-hook 'comint-mode-hook #'buffer-env-update)
  :custom
  (buffer-env-script-name "manifest.scm"))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(add-to-list 'default-frame-alist '(undecorated . t))
(setf frame-title-format "%b - Emacs")

(when (display-graphic-p)
  (set-face-attribute 'default nil :font "Iosevka Term" :height 200)
  (set-face-attribute 'variable-pitch nil :font "Iosevka Etoile")
  (set-face-attribute 'org-modern-symbol nil :font "Iosevka Etoile"))

(add-to-list 'default-frame-alist '(alpha-background . 95))

(setf display-line-numbers-type t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(column-number-mode 1)

(global-hl-line-mode 1)

(defun ll/org-hook ()
    (org-indent-mode)
    (org-modern-mode)
    (mixed-pitch-mode)
    (auto-fill-mode 0)
    (visual-line-mode 1))
  (defun ll/org-agenda-hook ()
    "Hook to run olivetti mode when entering org-agenda"
    (olivetti-mode))
  (defun ll/org-agenda-view-day ()
    (interactive)
    (org-agenda nil "d"))
  (defun ll/org-agenda-view-todos ()
    (interactive)
    (org-agenda nil "t"))

  (setq org-todo-keywords
        '((sequence "TODO" "WORKING" "COMPLETE")))
  (setq org-clock-in-switch-to-state "WORKING")
  (setq org-clock-out-switch-to-state "TODO")
  (setq org-agenda-custom-commands
        '(("d" "Today's Tasks"
           ((agenda "" ((org-agenda-span 1)
                        (org-agenda-overriding-header "Today's Task")))))))
  (setq org-agenda-files
        (directory-files-recursively "~/docs/org" "\\.org$"))

  (add-hook 'org-mode-hook 'll/org-hook)
  (add-hook 'org-agenda-mode-hook 'll/org-agenda-hook)
  (keymap-global-set "C-c a d" #'ll/org-agenda-view-day)
  (keymap-global-set "C-c a t" #'ll/org-agenda-view-todos)

  (setq org-src-window-setup 'current-window) ; C-c ' in same window

(defun kill-all-buffers ()
  "Kill all buffers except *scratch* and *Messages*."
  (interactive)
  (dolist (buf (buffer-list))
    (unless (member (buffer-name buf) '("*scratch*" "*Messages*"))
      (kill-buffer buf))))

(flycheck-define-checker
 vale
 "A checker for prose"
 :command ("vale" "--output" "line" source)
 :standart-input nil
 :error-patterns
 ((error
   line-start (file-name) ":" line ":" column ":" (id (one-or-more (not (any ":")))) ":" (message) line-end))
 :modes (markdown-mode org-mode text-mode))

(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
		 '("fiction" "
\\documentclass[submission,latterpaper,courier]{sffms}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]
"
		   ("\\chapter*{%s" . "\\chapter*{%s}"))))
(setq org-latex-hyperref-template "")



(setf geiser-guile-binary "/run/current-system/profile/bin/guile")

(defvar geiser-guix-repl-binary (concat user-emacs-directory "/guix-repl.sh")
  "Binary to run when interacting with Guix via geiser")
(defvar geiser-guix-channel-repl-binary (concat user-emacs-directory "/guix-channel-repl.sh")
  "Binary to run when interacting with a Guix channel via geiser")
(defun guix-geiser ()
  (interactive)
  (let ((geiser-guile-binary geiser-guix-repl-binary))
    (geiser 'guile)))
(defun guix-artoria-geiser ()
  (interactive)
  (let ((geiser-guile-binary geiser-guix-channel-repl-binary))
    (geiser 'guile)))





(setq-default tab-width 4)
  (defun clang-format-on-save ()
      "Format the buffer before save."
      (when (locate-dominating-file "." ".clang-format") (clang-format-buffer)))

    (add-hook
     'c-mode-hook (lambda () (add-hook 'before-save-hook 'clang-format-on-save nil t)))
;; temporary
(setq compilation-save-buffers-predicate nil)
(setq compilation-scroll-output 'first-error)
(setq compilation-ask-about-save nil)
(setq compilation-always-kill t)
(setq ansi-color-for-compilation-mode t)
(setq eglot-events-buffer-size 0)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)


