;;; personal-settings.el --- Settings for making Emacs mine -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Set initial frame's width slighly larger than 80 characters wide.
(add-to-list 'default-frame-alist '(width . 90))

;; Skip the "Welcome" Page
(setq inhibit-startup-message t)

(use-package emacs
  :ensure nil ;; built-in
  ;; This is usually bound by default, but sometimes it does not take effect.
  ;; We manually bind it here, just so we always get keybindings that we want.
  :bind (("M-<delete>" . #'backwards-kill-word))
  :config
  (repeat-mode 1)
  :custom
  ;; Make Emacs treat manual and programmatic buffer switches the same. This
  ;; works by making `switch-to-buffer' actually use `pop-to-buffer-same-window'
  ;; which respects `display-buffer-alist'.
  (switch-to-buffer-obey-display-actions t)
  ;; Increase how much is read from processes in a single chunk. The default
  ;; value of 4096 is a bit small; use 512k in this case.
  (read-process-output-max (* 512 1024))
  ;; According to the POSIX, a line is defined as "a sequence of zero or
  ;; more non-newline characters followed by a terminating newline".
  (require-final-newline t)
  ;; Remove duplicates from the kill ring to reduce clutter
  (kill-do-not-save-duplicates t)
  ;; Improve paren highlighting
  (show-paren-highlight-openparen t)
  (show-paren-when-point-in-periphery t)
  (show-paren-when-point-inside-paren t)
  ;; Do not fontify a window when the user is actively inputting data. This
  ;; should reduce input latency in large buffers. This should also help with
  ;; scroll performance.
  (redisplay-skip-fontification-on-input t)
  ;; Do not delay the delete-pair. That just makes things feel slow.
  ;; I almost never use `delete-pair', but let's make it behave like `kill-sexp'.
  (delete-pair-blink-delay 0))

;; Unbind C-z from suspending the current Emacs frame.
;; This stops me from accidentally minimizing Emacs when running graphically.
;; You can still access this with C-x C-z (which is a default keybinding).
(keymap-global-unset "C-z")

;;;; Turn on Line numbering
(global-display-line-numbers-mode) ;; Show line numbers everywhere
(setq column-number-mode 1) ;; Turn on column numbers in ALL major modes
(global-hl-line-mode 1) ;; Have line with my cursor highlighted

;; Parentheses/Brackets/Braces/Angles modifications
(use-package emacs
  :ensure nil ; Fake built-in package
  :config
  (show-paren-mode) ;; Emphasize MATCHING Parentheses/Brackets/Braces/Angles
  :custom
  ;; Don't let matching parens blink
  (blink-matching-paren nil))
(require 'rainbow-delimiters-config) ;; Pull in rainbow-delimiters config
;(electric-pair-mode 1) ;; Emacs automatically inserts closing pair

;; Enable syntax highlighting for older Emacsen that have it off
(global-font-lock-mode t)

;; Automatic file creation/manipulation/backups
;; I choose to remove the backup~ files because I don't want to have to add every one of those files
;; to the .gitignore for projects.
;; Besides, auto-saving happens frequently enough for it to not really matter.
(setq auto-save-default t) ;; Allow the #auto-save# files. They are removed upon buffer save anyways
;; Do not auto-disable auto-save after deleting large chunks of
;; text. The purpose of auto-save is to provide a failsafe, and
;; disabling it contradicts this objective.
(setq auto-save-include-big-deletions t)
;; Do not delete auto-save files when I kill a buffer. Just leave them sitting
;; around for later clean-up.
(setq kill-buffer-delete-auto-save-files nil)

(setq make-backup-files nil) ;; Disable backup~ files
(setq create-lockfiles nil) ;; Disable .#lockfile files
(setq vc-follow-symlinks t) ;; Never ask whether or not to follow symlinks


;; Disable some minor disturbances that I find quite annoying.
(setq visible-bell nil) ;; Disable the visual bell
(setq ring-bell-function #'ignore) ;; Don't make a ding when failing command

;; NOTE: Emacs calls refreshing a buffer a revert.
;; Unless you have modifications in memory that are not saved to the disk, then you will be fine.
(setq global-auto-revert-mode t) ;; Auto refresh buffers
;; Also refresh dired, but quietly
(setq global-auto-revert-non-file-buffers t) ;; Allow buffers not attached to a file to refresh themselves
;; Usually, a message is generated everytime a buffer is reverted and placed in the *Messages* buffer.
(setq auto-revert-verbose nil) ;; But not right now.
(auto-compression-mode t) ;; Transparently open compressed files

;; Have Emacs always follow compilation outputs in the Compile buffers.
(setq compilation-scroll-output t)

;; Show keystrokes in progress more quickly than default
(setq echo-keystrokes 0.75)

;; ALWAYS ask for confirmation before exiting Emacs
(setq confirm-kill-emacs 'y-or-n-p)

;; ANYTHING that should happen before saving ANY buffers should be put here.
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; I want a keybinding to quickly revert buffers, since sometimes Magit doesn't do it.
(keymap-global-set "C-c g" 'revert-buffer)

;; Try to use UTF-8 for everything
(set-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8) ;; Catch-all

;; Sentences DO NOT need 2 spaces to end.
(setq-default sentence-end-double-space nil)

;; Make sure tab-width is 4, not 8
(setq-default tab-width 4)

;;; Window management

;; Turning on `winner-mode' provides an "undo" function for resetting
;; your window layout.  We bind this to `C-c w u' for winner-undo and
;; `C-c w r' for winner-redo (see below).
(winner-mode 1)

(defcustom onghaik/windows-prefix-key "C-c w"
  "Configure the prefix key for window movement bindings.")

(define-prefix-command 'onghaik/windows-key-map)

(keymap-set 'onghaik/windows-key-map "u" 'winner-undo)
(keymap-set 'onghaik/windows-key-map "r" 'winner-redo)
(keymap-set 'onghaik/windows-key-map "n" 'windmove-down)
(keymap-set 'onghaik/windows-key-map "p" 'windmove-up)
(keymap-set 'onghaik/windows-key-map "b" 'windmove-left)
(keymap-set 'onghaik/windows-key-map "f" 'windmove-right)

(keymap-global-set onghaik/windows-prefix-key 'onghaik/windows-key-map)

(provide 'personal-settings)
;;; personal-settings.el ends here
