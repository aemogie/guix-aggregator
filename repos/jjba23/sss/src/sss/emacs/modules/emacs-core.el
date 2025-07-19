;;; emacs-core.el --- Configuring Emacs core -*- lexical-binding: t -*-

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

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

(use-package flymake
  :ensure nil
  :bind(("C-c ! b" . flymake-show-buffer-diagnostics)
	("C-c ! n" . flymake-goto-next-error)
	("C-c ! p" . flymake-show-project-diagnostics)
	("C-c ! f" . flymake-mode)))

(use-package which-key
  :ensure (:host github :repo "justbur/emacs-which-key")
  :config
  (setq which-key-sort-order 'which-key-key-order-alpha
	which-key-max-description-length 35)
  (setq-default which-key-idle-delay 0.4)
  (which-key-setup-minibuffer)
  (which-key-mode))

(setq sss-emacs-is-first-frame t)

(defun new-frame-setup (frame)
  (if (display-graphic-p frame)
      (progn
	      (message "window system")
	      (if sss-emacs-is-first-frame
            (progn
              (message "initializing SSS UI scaling for first frame")
              (tekengrootte-set-scale-small)
              (setq sss-emacs-is-first-frame nil)))
        (sss-set-base-faces))
    (progn
      (message "not a window system")
      (setq sss-emacs-is-first-frame nil)
      (sss-set-base-faces))
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
         ("C-c # f" . sss-full-reconfigure)
         ("C-c w r" . sss-project-start-repl-process)
         ("C-c w f" . sss-project-fmt)
         ("C-c w t" . sss-project-start-test)
         ("C-c w d" . sss-project-start-dev)
         ("C-c w s" . sss-print-random-standup-order)
         ("C-c g l" . guix-package-location-on-mark)
         ("C-c t a" . sort-lines)
         ("C-c t p" . kbd-scheme-make-parameter)
         ("C-c t h" . kbd-scheme-hygguile-abstraction))
  :hook ((text-mode . visual-line-mode)
         (prog-mode . display-fill-column-indicator-mode))
  :config
  (setq-default line-spacing 6
                pgtk-wait-for-event-timeout 0
                electric-indent-inhibit t)

  (setopt read-extended-command-predicate #'command-completion-default-include-p
          backward-delete-char-untabify-method 'hungry)

  (setopt compilation-always-kill t)

  (setopt treesit-font-lock-level 4
          ring-bell-function #'ignore
          frame-resize-pixelwise t
          completion-cycle-threshold 3
          tab-always-indent 'complete
          text-mode-ispell-word-completion nil
          vc-follow-symlinks t
          read-file-name-completion-ignore-case t
          read-buffer-completion-ignore-case t
          completion-ignore-case t
          use-dialog-box nil
          delete-by-moving-to-trash t
          tab-width 2
          fill-column 78
          sentence-end-double-space t)

  (setopt safe-local-variable-directories
          (list (string-replace "$HOME" (getenv "HOME") "$HOME/fork/guix/")))

  (savehist-mode 1)
  (save-place-mode 1)
  (global-auto-revert-mode 1)
  (delete-selection-mode +1)

  (ignore-errors
    (set-frame-parameter nil 'alpha-background 90)
    (add-to-list 'default-frame-alist '(alpha-background . 90)))

  (when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings))

  (defalias 'yes-or-no-p 'y-or-n-p)

  (setopt dired-listing-switches "-lAh --group-directories-first"
          dired-kill-when-opening-new-dired-buffer t)

  (add-hook 'dired-mode-hook
            (lambda () (dired-hide-details-mode 1)))
  (setq-default indent-tabs-mode nil)
  (global-prettify-symbols-mode +1)

  (setopt initial-buffer-choice
          (lambda () (ignore-errors
                  (welkomscherm)
                  (get-buffer welkomscherm/buffer-name))))

  (recentf-mode 1)
  (setopt recentf-max-menu-items 100
          recentf-max-saved-items 100)

  (global-hl-line-mode +1)
  (setq-default cursor-type 'bar)

  (add-to-list 'after-make-frame-functions 'new-frame-setup t))


(provide 'sss/emacs-self)

;;; emacs-core.el ends here
