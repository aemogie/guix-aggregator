;; -*- lexical-binding: t; -*-

;; Garbage Collections
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Compile warnings
(setq warning-minimum-level :emergency 
      native-comp-async-report-warnings-errors 'silent) ;; native-comp warning
;; (setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))

(setq package-native-compile t)
(setq native-comp-jit-compilation nil)

;; optimizations (froom Doom's core.el). See that file for descriptions.
(setq idle-update-delay 1.0)

;; Disabling bidi (bidirectional editing stuff)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)  ; emacs 27 only - disables bidirectional parenthesis

(setq highlight-nonselected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq inhibit-compacting-font-caches t)

;; Data emacs reads from process
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; (setq package-enable-at-startup t)

;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)

;; Set the right directory to store the native comp cache
;; (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;; Startup speed, annoyance suppression
(setq gc-cons-threshold (* 10 1000 1000)
      byte-compile-warnings '(not obsolete)
      warning-suppress-log-types '((comp) (bytecomp))
      native-comp-async-report-warnings-errors 'silent)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration
(setq frame-resize-pixelwise t)
(dolist (mode '(tool-bar-mode menu-bar-mode ; Menus
                scroll-bar-mode             ; Scroll-bar
                tooltip-mode                ; Tooltip
                indent-tabs-mode            ; Tabs
                blink-cursor-mode           ; Cursor
                fringe-mode))               ; Fringe
  (funcall mode 0))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda () (message
                 "*:** Emacs loaded in %s seconds with %d garbage collections."
                 (emacs-init-time "%.2f")
                 gcs-done)))

(setq default-frame-alist
      '((fullscreen . maximized)

        ;; no scroll bars
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)

        ;; Setting the face in here prevents flashes of
        ;; color as the theme gets activated
        (background-color . "#000000")
        (ns-appearance . dark)
        (ns-transparent-titlebar . t)))

;; Ask y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Disable compiler and large file warnings
(setq native-comp-async-report-warnings-errors nil
      large-file-warning-threshold             nil)

;; Remove start message and scratch message
(setq inhibit-startup-message t
      initial-scratch-message nil)

;; theme
(setq custom-theme-directory "~/.config/emacs/themes")
(load-theme 'anemofilia t)
