;; -*- lexical-binding: t; -*-

(setq ;; garbage collection
      gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      inhibit-compacting-font-caches t

      ;; native compilation
      native-comp-jit-compilation t
      native-compile-prune-cache t

      ;; somehow this makes the init faster
      file-name-handler-alist-old file-name-handler-alist
      file-name-handler-alist '()

      ;; data emacs reads from process
      read-process-output-max (* 1024 1024) ; 1mb

      ;; silence startup message
      inhibit-startup-echo-area-message (user-login-name)

      ;; Warnings
      warning-suppress-log-types '((comp) (bytecomp))
      warning-minimum-level :emergency
      byte-compile-warnings '(not obsolete)
      native-comp-async-report-warnings-errors nil
      large-file-warning-threshold nil

      ;; miscelaneous conveniences
      highlight-nonselected-windows nil
      fast-but-imprecise-scrolling t

      ;; ask y/n instead of yes/no
      use-short-answers t

      ;; remove start message and scratch message
      inhibit-startup-message t
      initial-scratch-message nil

      ;; theme
      custom-theme-directory "~/.config/emacs/themes"

      ;; frame related settings
      frame-resize-pixelwise t
      default-frame-alist '((fullscreen . maximized)

                            ;; no scroll bars
                            (vertical-scroll-bars . nil)
                            (horizontal-scroll-bars . nil)

                            ;; setting the face here prevents flashes of
                            ;; color as the theme gets activated
                            (background-color . "#000000")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)
                            (undecorated . t)))

;; disabling bidi (bidirectional editing stuff)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; default frame configuration
(dolist (mode '(tool-bar-mode menu-bar-mode ; Menus
                scroll-bar-mode             ; Scroll-bar
                tooltip-mode                ; Tooltip
                indent-tabs-mode            ; Tabs
                blink-cursor-mode           ; Cursor
                fringe-mode))               ; Fringe
  (funcall mode -1))

;; profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda () (message
                 "*:** Emacs loaded in %s seconds with %d garbage collection%s."
                 (emacs-init-time "%.2f")
                 gcs-done
                 (if (= gcs-done 1) "" "s"))))

(load-theme 'anemofilia t)
