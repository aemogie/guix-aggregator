;;; wm.el --- Window Manger File ---- -*- lexical-binding: t -*-
;;; Commentary:
;;;; EXWM Configuration

;;; Code:

;; So that every `split-sensibly` operation produces a horizontal split

(setq split-width-threshold nil)

;;; Avy : To Jump Around!

(use-package avy
  :init
  (avy-setup-default)
  :bind (("M-g c" . avy-goto-char)
	 ("M-g l" . avy-goto-line)
	 ("M-g w" . avy-goto-word-0))

  :commands (avy-goto-char avy-goto-word-0 avy-goto-line))
  ;; :general
  ;; (divya/leader-keys
  ;;   "j" '(:ignore t :which-key "jump")
  ;;   "jj"  '(avy-goto-char :which-key "jump to char")
  ;;   "jw"  '(avy-goto-word-0 :which-key "jump to word")
  ;;   "jl"  '(avy-goto-line :which-key "jump to line")))

;;; Window management with ace-window

(use-package ace-window
  :bind (("M-o" . ace-window)
	 ())
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1))

;;; popup window managment
(use-package popper
  :straight t ; or :straight t
  :bind (("M-`"     . popper-toggle-latest)
	 ("M-~"     . popper-cycle)
	 ("C-x M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
	'("\\*Messages\\*"
	  "\\*Warnings\\*"
	  "\\*xref\\*"
	  "\\*Backtrace\\*"
	  "*Flymake diagnostics.*"
	  "\\*eldoc\\*"
	  "\\*compilation\\*"
	  "^*tex"
	  "Output\\*$"
	  help-mode
	  compilation-mode))
  (setq popper-display-control 'user)
  (popper-mode +1))

;;; Certain window rules
;; If the current buffer is in a particular window then the new buffer using `switch-to-buffer' should pop a new window instead of using the same one.
(setq switch-to-buffer-obey-display-actions t)
(setq switch-to-buffer-in-dedicated-window 'pop)
(setq split-height-threshold 80)
(setq split-width-threshold 125)

(setq display-buffer-alist
      '(
	("\\*Occur\\*"
	 (display-buffer-reuse-mode-window
	  display-buffer-below-selected)
	 ;; Parameters
	 (dedicated . t)
	 (window-height . fit-window-to-buffer))
	))

;;; For moving and transposing frames

(use-package transpose-frame
  :straight t
  :bind (("C-`" . transpose-frame)
	 ("C-~" . flip-frame)
	 ("C-M-`" . flop-frame)
	 ("C-!" . rotate-frame-clockwise)
	 ("C-#" . rotate-frame-anti-clockwise)))

;;; Winner mode
(winner-mode 1)
(global-set-key (kbd "C-x ~") 'winner-undo)
(global-set-key (kbd "C-x !") 'winner-redo)

;; Easier window splitting
(global-set-key (kbd "M-n v") 'split-window-vertically)
(global-set-key (kbd "M-n h") 'split-window-horizontally)
(global-set-key (kbd "M-n f") 'delete-other-windows)
(global-set-key (kbd "M-n c") 'delete-window)

(provide 'init)
;;; wm.el ends here
