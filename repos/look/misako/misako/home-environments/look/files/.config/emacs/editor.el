(defun meow-search-backward (arg)
  (interactive "p")
  (meow-search
   (if (meow--direction-backward-p)
       arg
     '-)))

(defun meow-search-forward (arg)
  (interactive "p")
  (meow-search
   (if (meow--direction-backward-p)
       '-
     arg)))

(defun lk/meow-kill-or-delete ()
  "Call `meow-kill` if a region is active, else call `meow-delete`."
  (interactive)
  (if (region-active-p)
      (meow-kill)
    (meow-delete)))

(defun acg/with-mark-active (&rest args)
  "Keep mark active after command. To be used as advice AFTER any
function that sets `deactivate-mark' to t."
  (setq deactivate-mark nil))

;; Fix mark deactivation
(dolist (fn '(look/toggle-case
              meow-save
              kill-ring-save))
  (advice-add fn :after #'acg/with-mark-active))

(defun look/toggle-case ()
  (interactive)
  (if (region-active-p)
      (let ((i 0)
            (return-string "")
            (input (buffer-substring-no-properties (region-beginning) (region-end))))
        (while (< i (length input))
          (let* ((char (substring input i (1+ i)))
                 (toggled (if (string= char (downcase char))
                              (upcase char)
                            (downcase char))))
            (setq return-string (concat return-string toggled)))
          (setq i (1+ i)))
        (delete-region (region-beginning) (region-end))
        (insert return-string))
    ;; No region: toggle char under cursor
    (let* ((char (buffer-substring-no-properties (point) (1+ (point))))
           (toggled (if (string= char (downcase char))
                        (upcase char)
                      (downcase char))))
      (delete-char 1)
      (insert toggled)
      (backward-char 1))))

(defun volatile-kill-buffer ()
  "Kill current buffer unconditionally."
  (interactive)
  (let ((buffer-modified-p nil))
    (kill-buffer (current-buffer))))

(defun look/join-line ()
  "Join the current line with the one below, collapsing whitespace
into a single space."
  (interactive)
  (let ((join-point (point)))
    ;; Go to end of current line
    (end-of-line)
    ;; Delete newline and any whitespace after it
    (delete-region (point)
                   (progn (forward-line 1)
                          (skip-chars-forward " \t\n")
                          (point)))
    ;; Insert a single space
    (insert " ")
    ;; Optional: go back to where you were
    (goto-char join-point)))

(defun look/replace (to)
  "Replace all occurrences of '.' with a string entered by the user,
within the selected region."
  (interactive
   (list (read-string "Replace '.' with: ")))
  (if (use-region-p)
      (replace-regexp "." to nil (region-beginning) (region-end))
    (message "No region selected")))

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (setq meow-keypad-leader-dispatch "C-c")
  (defvar-keymap goto-keymap
    :doc "go to:"
    :prefix 'goto-thing
    "e" #'end-of-buffer
    "g" #'beginning-of-buffer
    "h" #'beginning-of-line
    "l" #'end-of-line
    "s" #'beginning-of-line-text
    "n" #'next-buffer
    "p" #'previous-buffer
    "t" #'tab-bar-switch-to-next-tab
    "T" #'tab-bar-switch-to-prev-tab)
  (defvar-keymap match-keymap-inner
    :doc "match inner:"
    "\"" #'er/mark-inside-quotes
    "(" #'er/mark-inside-pairs
    ")" #'er/mark-inside-pairs)
  (defvar-keymap match-keymap-outer
    :doc "match outer:"
    "\"" #'er/mark-outside-quotes
    "(" #'er/mark-outside-pairs
    ")" #'er/mark-outside-pairs)
  (defvar-keymap match-keymap
    :doc "match:"
    "m" #'er/expand-region
    "i" match-keymap-inner
    "a" match-keymap-outer)
  (defvar-keymap window-keymap
    :doc "window:"
    "v" (lambda () (interactive) (split-window-right) (other-window 1))
    "h" (lambda () (interactive) (split-window-below) (other-window 1))
    "1" #'delete-other-windows
    "s" #'window-swap-states
    "o" #'other-window
    "C-w" #'other-window
    "q" #'delete-window)
  (which-key-add-keymap-based-replacements window-keymap
    "v" "Split window vertically"
    "h" "Split window horizontally"
    "1" "Delete all other windows"
    "s" "Swap windows"
    "o" "Other window"
    "C-w" "Other window"
    "q" "Quit window")
  (defvar-keymap workspaces-keymap
    :doc "workspaces:"
    ;; "o" #'tabspaces-open-or-create-project-and-workspace
    ;; "w" #'tabspaces-switch-or-create-workspace
    "w" #'tabspaces-open-or-create-project-and-workspace
    "q" #'tabspaces-kill-buffers-close-workspace)
  (defvar-keymap activities-keymap
    :doc "activities:"
    "d" #'activities-define
    "q" #'activities-suspend
    "s" #'activities-switch
    "r" #'activities-resume
    "o" #'activities-resume
    "a" #'activities-resume)
  (which-key-add-keymap-based-replacements activities-keymap
    "d" "Define an activity"
    "q" "Suspend/quit an activity"
    "s" "Switch to an active activity"
    "r" "Resume an activity"
    "o" "Resume an activity"
    "a" "Resume an activity")
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("g" . magit-status)
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
   '("/" . project-find-regexp)
   '("f" . project-find-file)
   '("p" . meow-clipboard-yank)
   '("R" . meow-replace-save)
   '("P" . look/paste-clipboard-before)
   '("y" . meow-clipboard-save)
   `("w" . ,workspaces-keymap)
   `("a" . ,activities-keymap)
   '("s" . project-switch-project))
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
   '("." . meow-bounds-of-thing)
   '("," . mc/keyboard-quit)
   '("M-," . mc/remove-current-cursor)
   '("." . meow-reverse)
   '(";" . meow-cancel-selection)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("(" . mc/cycle-backward)
   '(")" . mc/cycle-forward)
   '("/" . meow-visit)
   '("~" . look/toggle-case)
   '("=" . indent-region)
   '("&" . mc/vertical-align-with-space)
   '(">" . indent-rigidly-right)
   '("<" . indent-rigidly-left)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("C-b" . scroll-down-command)
   '("c" . meow-change)
   '("C" . mc/mark-next-like-this)
   '("C-/" . comment-line)
   '("d" . lk/meow-kill-or-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("C-f" . scroll-up-command)
   `("g" . ,goto-keymap)
   '("h" . left-char)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . look/join-line)
   '("M-j" . move-text-down)
   '("k" . meow-prev)
   '("K" . join-line)
   '("M-k" . move-text-up)
   '("l" . right-char)
   `("m" . ,match-keymap)
   '("M" . er/contract-region)
   '("n" . meow-search-forward)
   '("N" . meow-search-backward)
   '("o" . meow-open-below)
   '("O" . meow-open-above)
   '("p" . meow-yank)
   '("P" . look/paste-before)
   '("r" . look/replace)
   '("R" . meow-replace)
   '("s" . mc/mark-all-in-region-regexp)
   '("M-s" . mc/edit-ends-of-lines)
   '("t" . meow-till)
   '("u" . undo-only)
   '("U" . undo-redo)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   `("C-w" . ,window-keymap)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("z" . recenter-top-bottom)
   '("'" . repeat)
   '("<escape>" . ignore)))

(global-set-key (kbd "C-x k") 'volatile-kill-buffer)

(setq mc/always-run-for-all 1)

;; Fix append cursor
(setq meow-use-cursor-position-hack t)
(setq meow-visit-sanitize-completion nil)

(setq meow-keypad-ctrl-meta-prefix ?u)

(use-package meow
  ; :hook ((prog-mode text-mode conf-mode) . meow-global-mode)
  :config
  (require 'meow)
  (meow-setup)
  (meow-global-mode 1))
