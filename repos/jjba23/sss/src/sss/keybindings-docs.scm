;;; SSS - Supreme Sexp System

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

;; Commentary:
;; When keybindings (shortcuts) are defined or mentioned, the following legend applies (a la Emacs):
;;   s   -- Super / Windows / CMD key
;;   S   -- Shift key                 
;;   M   -- Meta / Alt / Option key   
;;   C   -- Control key               
;;   SPC -- Space key

(define-module (sss keybindings-docs)
  #:declarative? #t
  #:use-module (gnu)
  #:export (power-user-general-window-manager-keybindings
            power-user-application-window-manager-keybindings
            power-user-sss-specific-emacs-keybindings
            power-user-more-emacs-keybindings
            power-user-sss-keybindings-docs
            universal-session-general-window-manager-keybindings
            universal-session-sss-keybindings-docs))

(define power-user-general-window-manager-keybindings
  '(("s-k" . "Kill/Close a window or application") ("s-l" . "Lock screen")
    ("s-1..9" . "Move focus to workspace 1..9")
    ("s-S-1..9" . "Move window to workspace 1..9")
    ("s-S-." . "Copy screenshot of entire screen")
    ("s-." . "Save screenshot of entire screen")
    ("s-S-," . "Copy screenshot of selected area")
    ("s-," . "Save screenshot of selected area")
    ("s-S-b" . "Set wallpaper to theme's default")
    ("s-S-SPC" . "Toggle floating/tiling mode for window")))

(define power-user-application-window-manager-keybindings
  '(("s-/" . "Launch application fuzzy finder menu (Rofi)")
    ("s-i" . "Open a Web Browser (Firefox)")
    ("s-S-i" . "Open a bloated Web Browser (Chrome)")
    ("s-e" . "Open a new Emacs client frame")
    ("s-t" . "Open a terminal emulator (Alacritty)")
    ("s-S-t" . "Open a new Emacs client frame with EShell")
    ("s-b" . "Open file manager (Nautilus)")))

(define power-user-sss-specific-emacs-keybindings
  '(("M-s r" . "consult-ripgrep: which greps through the project with results in your minibuffer")
    ("M-s o" . "consult-occur: which finds occurences in file")
    ("C-c # s" . "sss-sys-reconfigure: which performs a SSS Guix system rebuild")
    ("C-c # j" . "sss-joe-reconfigure: which performs a SSS Guix Home rebuild for Joe")
    ("C-c # f" . "sss-full-reconfigure: which performs a SSS Guix system + Home (Joe) rebuild")))

(define power-user-more-emacs-keybindings
  '(("C-x C-f" . "find-file: Open a file.")
    ("C-x C-s" . "save-buffer: Save the current buffer.")
    ("C-x C-w" . "write-file: Save the current buffer to a different file.")
    ("C-x C-b" . "list-buffers: List open buffers.")
    ("C-g" . "keyboard-quit: Cancel the current command.")
    ("C-x k" . "kill-buffer: Kill (close) the current buffer.")
    ("C-x C-c" . "save-buffers-kill-emacs: Save all buffers and exit Emacs.")
    ("C-y" . "yank: Paste the most recently killed (cut or copied) text.")
    ("C-w" . "kill-region: Cut the selected region.")
    ("M-w" . "kill-ring-save: Copy the selected region.")
    ("C-k" . "kill-line: Cut the text from the cursor to the end of the line.")
    ("C-d" . "delete-char: Delete the character under the cursor.")
    ("C-a" . "beginning-of-line: Move the cursor to the beginning of the line.")
    ("C-e" . "end-of-line: Move the cursor to the end of the line.")
    ("C-p" . "previous-line: Move the cursor to the previous line.")
    ("C-n" . "next-line: Move the cursor to the next line.")
    ("C-f" . "forward-char: Move the cursor forward one character.")
    ("C-b" . "backward-char: Move the cursor backward one character.")
    ("M-f" . "forward-word: Move the cursor forward one word.")
    ("M-b" . "backward-word: Move the cursor backward one word.")
    ("C-v" . "scroll-up-command: Scroll the buffer up one screen.")
    ("M-v" . "scroll-down-command: Scroll the buffer down one screen.")
    ("C-s" . "isearch-forward: Incremental search forward.")
    ("C-r" . "isearch-backward: Incremental search backward.")
    ("M-x" . "execute-extended-command: Execute an extended command (by name).")
    ("C-h k" . "describe-key: Describe a key binding.")
    ("C-h f" . "describe-function: Describe a function.")
    ("C-h v" . "describe-variable: Describe a variable.")
    ("C-h m" . "describe-mode: Describe the current major mode.")
    ("C-h i" . "info: Open the Emacs Info manual.")
    ("C-x 2" . "split-window-below: Split the current window horizontally.")
    ("C-x 3" . "split-window-right: Split the current window vertically.")
    ("C-x 0" . "delete-window: Delete the current window.")
    ("C-x 1" . "delete-other-windows: Delete all other windows.")
    ("C-x o" . "other-window: Switch to the next window.")
    ("C-l" . "recenter-top-bottom: Recenter the current line in the window.")
    ("M-g g" . "goto-line: Go to a specific line number.")
    ("C-x u" . "undo: Undo the last change.")
    ("C-/" . "redo: Redo the last undone change.")
    ("C-j" . "newline: Insert a newline.")
    ("TAB" . "indent-for-tab-command: Indent the current line (or region).")
    ("M-TAB" . "completion-at-point: Attempt completion at point.")
    ("C-t" . "transpose-chars: Transpose the characters around point.")
    ("M-t" . "transpose-words: Transpose the words around point.")
    ("C-x C-l" . "downcase-region: Convert the selected region to lowercase.")
    ("C-x C-u" . "upcase-region: Convert the selected region to uppercase.")
    ("M-u" . "upcase-word: Uppercase the word at point.")
    ("M-l" . "downcase-word: Lowercase the word at point.")
    ("M-c" . "capitalize-word: Capitalize the word at point.")
    ("C-x h" . "mark-whole-buffer: Select the entire buffer.")
    ("C-v" . "scroll-down: Scroll down in the buffer")
    ("M-v" . "scroll-up: Scroll up in the buffer")))

(define universal-session-general-window-manager-keybindings
  '(("ALT-F4" . "Close window") ("WIN-Up" . "Maximize")))

(define power-user-sss-keybindings-docs
  `(("Window Manager (Niri)" ("General" unquote
                              power-user-general-window-manager-keybindings)
     ("Application" unquote power-user-application-window-manager-keybindings))
    (emacs ("SSS specific" unquote power-user-sss-specific-emacs-keybindings)
           ("More" unquote power-user-more-emacs-keybindings))))

(define universal-session-sss-keybindings-docs
  `(("Window Manager (Labwc)" ("General" unquote
                               universal-session-general-window-manager-keybindings))))
