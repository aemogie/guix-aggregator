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
  ("C-[" 'lem/frame-multiplexer:frame-multiplexer-prev)
  ("C-]" 'lem/frame-multiplexer:frame-multiplexer-next)
  ("C-0" 'lem/frame-multiplexer:frame-multiplexer-switch-0)
  ("C-1" 'lem/frame-multiplexer:frame-multiplexer-switch-1)
  ("C-2" 'lem/frame-multiplexer:frame-multiplexer-switch-2)
  ("C-3" 'lem/frame-multiplexer:frame-multiplexer-switch-3)
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

;; doesn't work :(
#+lem-sdl2
(sdl2-ffi.functions:sdl-set-window-opacity 
 (lem-sdl2/display:display-window (lem-sdl2/display:current-display))
 0.8f0)

#+lem-sdl2
(let* ((font-path 
         (uiop:merge-pathnames* ".guix-home/profile/share/fonts/truetype/"
                                (user-homedir-pathname)))
       (font-regular (uiop:merge-pathnames* "Hack-Regular.ttf" font-path))
       (font-bold (uiop:merge-pathnames* "Hack-Bold.ttf" font-path)))
  (if (every #'uiop:file-exists-p (list font-regular font-bold))
      (lem-sdl2/display:change-font (lem-sdl2/display:current-display)
                                    (lem-sdl2/font:make-font-config
                                     :size 21
                                     :latin-normal-file font-regular
                                     :latin-bold-file font-bold))
      (message "Fonts not found.")))
