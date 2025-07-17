;; -*- lexical-binding: t; -*-

(setq ;; Garbage collection
      gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      inhibit-compacting-font-caches t

      ;; Data emacs reads from process
      read-process-output-max (* 1024 1024) ; 1mb

      ;; Silence startup message
      inhibit-startup-echo-area-message (user-login-name)

      ;; Warnings
      warning-suppress-log-types '((comp) (bytecomp))
      native-comp-async-report-warnings-errors 'silent
      warning-minimum-level :emergency 
      byte-compile-warnings '(not obsolete)
      native-comp-async-report-warnings-errors nil

      ;; miscelaneous conveniences
      highlight-nonselected-windows nil
      fast-but-imprecise-scrolling t

      ;; Ask y/n instead of yes/no
      use-short-answers t

      ;; Disable compiler and large file warnings
      native-comp-async-report-warnings-errors nil
      large-file-warning-threshold             nil

      ;; Remove start message and scratch message
      inhibit-startup-message t
      initial-scratch-message nil

      ;; Theme
      custom-theme-directory "~/.config/emacs/themes"

      ;; Frame related settings
      frame-resize-pixelwise t
      default-frame-alist '((fullscreen . maximized)

                            ;; no scroll bars
                            (vertical-scroll-bars . nil)
                            (horizontal-scroll-bars . nil)

                            ;; Setting the face here prevents flashes of
                            ;; color as the theme gets activated
                            (background-color . "#000000")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)
                            (undecorated . t)))

;; Disabling bidi (bidirectional editing stuff)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Default frame configuration
(dolist (mode '(tool-bar-mode menu-bar-mode ; Menus
                scroll-bar-mode             ; Scroll-bar
                tooltip-mode                ; Tooltip
                indent-tabs-mode            ; Tabs
                blink-cursor-mode           ; Cursor
                fringe-mode))               ; Fringe
  (funcall mode -1))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda () (message
                 "*:** Emacs loaded in %s seconds with %d garbage collections."
                 (emacs-init-time "%.2f")
                 gcs-done)))

(load-theme 'anemofilia t)
