(in-package :lem-user)

(defun config-file (filename)
  (uiop:merge-pathnames* filename (lem-home)))

(load (config-file #p"buffer-switching.lisp"))

(lem-lisp-mode/paren-coloring::enable)
(lem/line-numbers::line-numbers-mode t)

(define-keys *global-keymap* 
  ("M-[" 'previous-window)
  ("M-]" 'next-window)
  ("M-0" 'delete-active-window)
  ("M-1" 'delete-other-windows)
  ("M-2" 'split-active-window-horizontally)
  ("M-3" 'split-active-window-vertically)
  ("M-Tab" 'next-buffer)
  ("M-Shift-Tab" 'previous-buffer))

(define-keys lem-paredit-mode:*paredit-mode-keymap*
  ("C-)" 'lem-paredit-mode:paredit-slurp)
  ("C-(" 'lem-paredit-mode:paredit-barf))

(define-key lem-lisp-mode:*lisp-mode-keymap* "M-Tab" 'next-buffer)

(add-hook lem-lisp-mode:*lisp-mode-hook*
          (lambda ()
            (lem-paredit-mode:paredit-mode t)))

(add-hook lem-lisp-mode:*lisp-repl-mode-hook*
          (lambda ()
            (lem-paredit-mode:paredit-mode nil)))
