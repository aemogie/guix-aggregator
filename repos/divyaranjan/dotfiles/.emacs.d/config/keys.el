;;; keys.el --- Keybinding Configuration File --- -*- lexical-binding: t -*-
;;; Commentary:
;;; Divya's keybindings for GNU Emacs

;;; Code:


(use-package undo-fu
  :straight t)

;; (use-package undo-tree
;;   :straight t)


;; Vim like scrolling
(setq scroll-step            1
      scroll-conservatively  10000
      next-screen-context-lines 5
      ;; move by logical lines rather than visual lines (better for macros)
      line-move-visual nil)

;;;; Custom Keybindings

;; A macro to make life easier (From http://dotshare.it/dots/8464/)
(defmacro bind-all (&rest pairs)
  `(progn
     ,@(mapcar
         (lambda (p)
           (let ((key (car p))
                 (val (cdr p)))
             (if (consp (car val))
                 `(define-key keymap (kbd ,key) (lambda () (interactive) ,@val))
                 `(define-key keymap (kbd ,key) (quote ,(car val))))))
         pairs)))

;; Go to a particular directory and open dired
(defun divya/go-to-dired (s)
  (interactive)
  (find-file s))

;; Your directory navigation function
(defun divya/go-to-dired (s)
  (interactive)
  (find-file s))

;; Define a keymap for C-x d prefix
(defvar directories-map (make-sparse-keymap)
  "Keymap for navigating to directories")


(setq directories-map
      (let ((keymap (make-sparse-keymap)))
        (bind-all
         ("e"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/"))
         ("M"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Movies & Series/"))
         ("b"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/"))
         ("B"   (divya/go-to-dired "~/bib/"))
         ("m"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/MIT OCW/Mathematics/"))
         ("p"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/Philosophy"))
         ("w"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/Writing"))
         ("P"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/Psychology/Psychoanalysis/"))
         ("l"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/Literature"))
         ("c"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/Computer Science and Programming"))
         ("C-p" (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/MIT OCW/Physics/"))
         ("s"   (divya/go-to-dired "/mnt/LDisk-E/Albert Einstein/Books & Resources/Sociology"))
         ("N"   (divya/go-to-dired "~/neuroscience/"))

         ("n"   (divya/go-to-dired "~/notes/"))
         ("o"   (divya/go-to-dired "~/notes/org/org-roam/"))
         ("M-p"  (divya/go-to-dired "~/projects/"))
         ("L"   (divya/go-to-dired "~/life/"))
         ("S"   (divya/go-to-dired "~/Sync/"))

         ("d"   (divya/go-to-dired "~/.dotfiles/"))
         ("C-c" (divya/go-to-dired "~/.config/")))

        keymap))

;; Bind the C-x d prefix to the directories-map keymap
(global-set-key (kbd "C-x d") directories-map)



;;; Keybindings for window management

;;; Meow

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("j" . dired-jump)
   '("?" . meow-cheatsheet))

  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
 '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(use-package meow
  :straight t
  :config
  (meow-setup)
  (meow-setup-indicator)
  (meow-global-mode 1))

(meow-thing-register 'angle
                     '(pair ("<") (">"))
                     '(pair ("<") (">")))
(add-to-list 'meow-char-thing-table
             '(?a . angle))


;; Some more vim stuff

;; (use-package evil-surround
;;   :straight t)

;; Expand-Region
(use-package expand-region
  :bind (("C-;" . er/expand-region)
	 ("C-(" . er/mark-outside-pairs)))

;;; Embark

(use-package embark
  :straight t

  :bind
  (("C-." . embark-act)
   ("C-'" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;; Using only consult-isearch
;; (define-key global-map (kbd "C-s") 'consult-line)

;; Insert λ with a key
(define-key global-map (kbd "M-*") 'geiser-insert-lambda)

(provide 'keys.el)

;;; keys.el ends here
