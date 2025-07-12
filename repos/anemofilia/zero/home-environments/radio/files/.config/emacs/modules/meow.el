(use-package meow
  :custom
  (meow-use-clipboard t)
  (meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  :config
  (apply 'meow-motion-overwrite-define-key
         '(("j" . meow-next)
           ("k" . meow-prev)
           ("<escape>" . ignore)))
  (apply 'meow-leader-define-key
         '(;; SPC j/k will run the original command in MOTION state.
           ("j" . "H-j")
           ("k" . "H-k")
           ;; Use SPC (0-9) for digit arguments.
           ("1" . meow-digit-argument)
           ("2" . meow-digit-argument)
           ("3" . meow-digit-argument)
           ("4" . meow-digit-argument)
           ("5" . meow-digit-argument)
           ("6" . meow-digit-argument)
           ("7" . meow-digit-argument)
           ("8" . meow-digit-argument)
           ("9" . meow-digit-argument)
           ("0" . meow-digit-argument)
           ("/" . meow-keypad-describe-key)
           ("?" . meow-cheatsheet)))
  (apply 'meow-normal-define-key
         '(("0" . meow-expand-0)
           ("9" . meow-expand-9)
           ("8" . meow-expand-8)
           ("7" . meow-expand-7)
           ("6" . meow-expand-6)
           ("5" . meow-expand-5)
           ("4" . meow-expand-4)
           ("3" . meow-expand-3)
           ("2" . meow-expand-2)
           ("1" . meow-expand-1)
           ("-" . negative-argument)
           (";" . meow-reverse)
           ("," . meow-inner-of-thing)
           ("." . meow-bounds-of-thing)
           ("[" . meow-beginning-of-thing) ; s for deletion is strange
           ("]" . meow-end-of-thing) ; g for cancel-selection is weird
           ("a" . meow-append)
           ("A" . meow-open-below)
           ("b" . meow-back-word)
           ("B" . meow-back-symbol)
           ;; meow's c has the same issue as d
           ("c" . meow-change)
           ;; d on kakoune is a misc of meow-kill and meow-delete
           ;; if the selection is empty, it's equivalent to d
           ;; if the selection is non-empty, then d on kakoune is
           ;; equivalent to sd on meow
           ("d" . meow-kill)
           ("e" . meow-next-word)
           ("E" . meow-next-symbol)
           ("f" . meow-find)
           ;; g cancelling selection is kinda strange
           ("g" . meow-cancel-selection)
           ;; This grab thing is kinda fucked up
           ("G" . meow-grab)
           ("h" . meow-left)
           ("H" . meow-left-expand)
           ("i" . meow-insert)
           ("I" . meow-open-above)
           ("j" . meow-next)
           ("J" . meow-next-expand)
           ("k" . meow-prev)
           ("K" . meow-prev-expand)
           ("l" . meow-right)
           ("L" . meow-right-expand)
           ("m" . meow-join)
           ("n" . meow-search)
           ("o" . meow-block)
           ("O" . meow-to-block)
           ("p" . meow-yank)
           ("q" . meow-quit)
           ("Q" . meow-goto-line)
           ("r" . meow-replace) ;; write a proper replace
           ("R" . meow-replace)
           ("s" . meow-kill)
           ("t" . meow-till)
           ("u" . meow-undo)
           ("U" . meow-undo-in-selection)
           ("v" . meow-visit)
           ("w" . meow-mark-word)
           ("W" . meow-mark-symbol)
           ("x" . meow-line)
           ("X" . meow-goto-line)
           ;; y has the same problem as d and c
           ("y" . meow-save)
           ("Y" . meow-sync-grab)
           ("z" . meow-pop-selection)
           ("'" . repeat)
           ("/" . isearch-forward)
           ("?" . isearch-backward)))
  :init (meow-global-mode))
