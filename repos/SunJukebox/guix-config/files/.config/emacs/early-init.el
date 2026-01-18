;;; early-init.el --- Early initialization  -*- lexical-binding: t; -*-
;;; Commentary:
;;
;;; Code:

;;; Basic settings for quick startup and convenience

;; Increase the amount of heap memory Emacs is allowed to use before GC.
(defvar onghaik/gc-cons-threshold (* 32 1024 1024)
  "Amount of memory used before GC is run.")
(defvar onghaik/gc-cons-percentage 0.8
  "Percent memory used before GC is run.")
(defvar onghaik/message-log-max (* 16 1024)
  "Maximum number of messages to keep in *Messages* buffer.")
(setq-default gc-cons-threshold onghaik/gc-cons-threshold
              gc-cons-percentage onghaik/gc-cons-percentage
              message-log-max onghaik/message-log-max)

;; Silence stupid startup message
;; (setq inhibit-startup-echo-area-message (user-login-name))

;; Make sure Emacs loads up newer config files, even if they aren't compiled
(customize-set-variable 'load-prefer-newer t)

(scroll-bar-mode -1) ;; Remove scroll bar at side
(menu-bar-mode 1) ;; Keep the top menu-bar, with the drop-down menus
(tool-bar-mode -1) ;; Remove big icon tool-bar below the menu-bar.
(tooltip-mode -1) ;; On clickable text, remove tooltip pop-up. Use minibuffer.

;; Change the title of the frame when opened in GUI mode.
(setq-default frame-title-format
              '("%b@" (:eval (or (file-remote-p default-directory 'host)
                                 system-name))
                " - Emacs"))

;;; Packages
;; (load-file (expand-file-name "modules/packages.el" user-emacs-directory))

(provide 'early-init)
;;; early-init.el ends here
