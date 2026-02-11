;; set emacs frame dimensions
(add-to-list 'default-frame-alist '(height . 42))
(add-to-list 'default-frame-alist '(width . 126))

;; disable extra file sometimes used for custom configurations (can be confusing)
(setopt custom-file null-device)

;; setup package repositories
(use-package package
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")))

;; prevent warning and compilation buffers from suddenly popping up
(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

;; prevent windows beep sound upon C-g
(setopt visible-bell nil)

;; right click to open up menu
(context-menu-mode 1)

;; set default directory to be C:\Users\<username>\AppData\Roaming
(setopt default-directory "~/")

;; set directory for emacs' automatically generated backup files to
;; C:\Users\USERNAME\AppData\Roaming\.emacs.d\backups
(add-to-list 'backup-directory-alist
             `("." . ,(expand-file-name "backups" user-emacs-directory)))

;; always do a proper backup by copying the file
(setopt backup-by-copying t)

;; when a buffer is looking at a file,
;; and that file is changed by something other than emacs,
;; update the buffer
(global-auto-revert-mode 1)

;; when re-opening files,
;; emacs will remember where in that file you were when you last had it open
(save-place-mode 1)

;; remember which commands you have run recently
(savehist-mode 1)

;; remember which files you have opened recently
(recentf-mode 1)

;; configure the built-in file manager "dired"
(use-package dired
  :hook
  (dired-mode . dired-hide-details-mode) ; hide extraneous file details
  (dired-mode . hl-line-mode) ; visually highlight selected line
  :custom
  (dired-listing-switches "-Ahl --group-directories-first") ; list folders first
  (dired-kill-when-opening-new-dired-buffer t) ; kill the buffer when switching
  )

;; when "deleting" files, just move them to the trash
(setopt delete-by-moving-to-trash t)

;; setup interface for dealing with trashed files
(use-package trashed
  :ensure t
  :custom
  (trash-use-header-line t)
  (trash-sort-key '("Date deleted" . t))
  (trash-date-format "%Y-%m-%d %H:%M:%S"))

;; describe what key commands do before you finish typing them,
;; e.g. "C-x", "C-c", etc.
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

;; allow you to repeat certain commands without re-doing the entire key-chord.
;; try e.g. "C-x o" when you have multiple windows
(repeat-mode 1)

;; make the mode line more compact and less likely to run off the edge
(setopt mode-line-compact 'long)

;; wrap text when it gets to the end of the screen
(global-visual-line-mode 1)

;; display line numbers in programming modes
(use-package display-line-numbers
  :custom
  (display-line-numbers-type t)
  :config
  (dolist (hook '(prog-mode-hook conf-mode-hook nxml-mode-hook))
    (add-hook hook 'display-line-numbers-mode)))

;; set fonts
;; fixed-pitch = monospaced font (e.g. writing code)
;; variable-pitch = proportially spaced font (e.g. writing prose)
(use-package faces
  :config
  (set-face-attribute 'default nil
                      :family "Consolas"
                      :height 120
                      :slant 'normal)

  (set-face-attribute 'fixed-pitch nil
                      :family "Consolas"
                      :height 1.0)

  (set-face-attribute 'variable-pitch nil
                      :family "Georgia"
                      :height 1.0)

  (set-face-attribute 'italic nil
                      :slant 'italic
                      :underline nil))

;; set default theme
(use-package modus-themes
  :ensure t
  :config
  (modus-themes-include-derivatives-mode 1))

(use-package ef-themes
  :ensure t
  :after modus-themes
  :custom
  (modus-themes-to-toggle '(ef-duo-dark ef-duo-light))
  :config
  (modus-themes-select 'ef-duo-dark))

;; don't show irrelevant command completions
(setopt read-extended-command-predicate #'command-completion-default-include-p)

;; allow fuzzy-find completion in the minibuffer
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides nil))

;; show completion options in buffer when hitting TAB
(use-package corfu
  :ensure t
  :custom
  (tab-always-indent 'complete) ; tab key will "complete" at point by default
  :config
  (global-corfu-mode 1)
  
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

;; show a vertical pop-up of minibuffer completions,
;; e.g. when searching for a file, or typing M-x
(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

;; show descriptive annotations for completion candidates
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

;; make scrolling smoother
(pixel-scroll-precision-mode 1)
(setopt scroll-conservatively 10000
        auto-window-vscroll nil)

;; if you highlight text and start typing, you will replace that text,
;; like in most applications
(delete-selection-mode 1)

;; set file for personal dictionary of spellings
(setopt ispell-personal-dictionary "~/personal-dictionary")

;; use "space" characters instead of tab ones (otherwise indentation will look odd)
(setq-default indent-tabs-mode nil
              tab-width 4)

;; set up org-mode
(use-package org
  :hook
  (org-mode . org-indent-mode) ; indent subheadings
  :bind
  (:map org-mode-map
        ("C-c l" . org-cycle-list-bullet)) ; add keybind to cycle through list types (e.g. "1." -> "1)")
  :custom
  (org-directory "~/org/")
  
  (org-default-notes-file (expand-file-name "notes.org" org-directory))
  (org-agenda-files (list (expand-file-name "agenda/" org-directory)))

  (org-M-RET-may-split-line '((default . nil))) ; don't split lines when making new bullets/headings
  (org-insert-heading-respect-content t) ; insert new headings after content

  (org-log-done 'time) ; show time of completion when finishing TODO's
  (org-log-into-drawer t) ; put all metadata about notes (like completion time) into a foldable subheading
  :config
  (org-babel-do-load-languages ; enable evaluating org-mode source code blocks
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)))

  ;; cycle more quickly/easily through list types
  (defvar my/org-cycle-list-bullet-repeat-keymap
    (define-keymap "l" #'org-cycle-list-bullet))

  (put #'org-cycle-list-bullet 'repeat-map
       'my/org-cycle-list-bullet-repeat-keymap))

;; install a nice "magic" interface to using git
(use-package magit
  :ensure t)

;; technical stuff
(setq-default buffer-file-coding-system 'utf-8-unix)
(use-package tramp
  :config
  (push '("-tt")
        (cadr (assoc 'tramp-login-args
                     (assoc "ssh" tramp-methods)))))
