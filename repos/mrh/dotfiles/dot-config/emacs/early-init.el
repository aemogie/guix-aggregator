(setq vc-follow-symlinks t)

(defun restore-gc-cons-threshold ()
  (setq gc-cons-threshold 64000000
        gc-cons-percentage 0.1))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook #'restore-gc-cons-threshold 105)

(add-to-list 'default-frame-alist '(alpha-background . 75))

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
                      :height 130)

  (set-face-attribute 'fixed-pitch nil
                      :family "DejaVu Sans Mono"
                      :height 130)

  (set-face-attribute 'variable-pitch nil
                      :family "DejaVu Serif"
                      :height 160))

(use-package face-remap
  :config
  (defun my/remap-pitch-faces (_enable)
    (face-remap--remap-face 'fixed-pitch)
    (face-remap--remap-face 'variable-pitch))
  
  (advice-add 'text-scale-mode :after #'my/remap-pitch-faces))

(defun my/enable-variable-pitch-mode (&optional exceptions)
  "Enable `variable-pitch-mode' only in sensible major modes."
  (unless (derived-mode-p 'html-mode 'nxml-mode 'org-mode 'markdown-mode)
    (variable-pitch-mode 1)))

(use-package text-mode
  :defer t
  :config
  (add-hook 'text-mode-hook #'my/enable-variable-pitch-mode))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode)
  :after dired)

(use-package ef-themes
  :custom
  (ef-themes-mixed-fonts t)
  (ef-themes-common-palette-overrides '((fg-main fg-intense)))
  (ef-themes-to-toggle '(ef-melissa-dark ef-melissa-light))
  :config

  (with-eval-after-load 'server
    (add-hook 'server-after-make-frame-hook
              (lambda ()
                (ef-themes-load-theme (ef-themes--current-theme)))))

  (with-eval-after-load 'markdown-mode
    (add-hook 'markdown-mode-hook #'variable-pitch-mode))

  (with-eval-after-load 'org
    (advice-add 'ef-themes-load-theme :after #'my/fontify-org-buffers)
    (add-hook 'org-mode-hook #'variable-pitch-mode))
  
  (ef-themes-select-dark 'ef-melissa-dark))
