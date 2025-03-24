;;; emacs-core.el --- Configuring Emacs core -*- lexical-binding: t -*-

;; Copyright (C) 2025 Josep Bigorra

;; Author: Josep Bigorra <jjbigorra@gmail.com>
;; Maintainer: Josep Bigorra <jjbigorra@gmail.com>
;; URL: https://codeberg.org/jjba23/sss

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Configuring Emacs core

;;; Code:


(use-package which-key
  :ensure nil
  :config
  (setq which-key-sort-order 'which-key-key-order-alpha
	which-key-max-description-length 35)
  (setq-default which-key-idle-delay 0.4) 
  (which-key-setup-minibuffer)
  (which-key-mode))

(defun new-frame-setup (frame)
  (if (display-graphic-p frame)
      (progn
	(message "window system")
	(tekengrootte-set-scale-small)

	)
    (message "not a window system")
    ))

(use-package emacs 
  :ensure nil 
  :bind (("C-x C-b" . ibuffer) 
         ("C-c a h" . highlight-compare-buffers) 
         ("C-c l d" . toggle-debug-on-error)
         ("C-c l e" . eval-buffer)
         ("C-c C-m C-s" . gnus-group-read-ephemeral-group)
         ("C-c u u" . sss-uuidgen)
         ("C-c # j" . sss-joe-reconfigure)
         ("C-c # s" . sss-sys-reconfigure)
         ("C-c # u" . sss-sys-update)
         ("C-c # m" . sss-publish-manual)
         ("C-c # f" . sss-full-reconfigure))
  :hook ((text-mode . visual-line-mode))
  :config  
  (setq-default line-spacing 6
                pgtk-wait-for-event-timeout 0
                electric-indent-inhibit t)

  (setq read-extended-command-predicate #'command-completion-default-include-p
        backward-delete-char-untabify-method 'hungry)

  (setq compilation-always-kill t)
  
  (setq treesit-font-lock-level 4
	ring-bell-function #'ignore
	frame-resize-pixelwise t
	inhibit-startup-message t
        completion-cycle-threshold 3
	tab-always-indent 'complete
	text-mode-ispell-word-completion nil
        vc-follow-symlinks t
        use-dialog-box nil
	delete-by-moving-to-trash t
	tab-width 2)
  
  (savehist-mode 1)
  (save-place-mode 1)
  (global-auto-revert-mode 1)
  (tool-bar-mode -1) 
  (scroll-bar-mode -1) 
  (menu-bar-mode -1) 
  (delete-selection-mode +1)

  (ignore-errors
    (set-frame-parameter nil 'alpha-background 85) 
    (add-to-list 'default-frame-alist '(alpha-background . 85)))
  
  (when (fboundp 'windmove-default-keybindings) 
    (windmove-default-keybindings))
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq dired-listing-switches "-lAh --group-directories-first" dired-kill-when-opening-new-dired-buffer t)
  (add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1)))
  (setq-default indent-tabs-mode nil)
  (global-prettify-symbols-mode +1)

  (setq initial-buffer-choice
        (lambda () (ignore-errors
                (welkomscherm)
                (get-buffer welkomscherm-buffer-name))))
  
  (recentf-mode 1)
  (setq recentf-max-menu-items 100
        recentf-max-saved-items 100)

  (global-hl-line-mode +1)

  (add-to-list 'after-make-frame-functions 'new-frame-setup t))

(provide 'sss/emacs-self)

;;; emacs-core.el ends here
