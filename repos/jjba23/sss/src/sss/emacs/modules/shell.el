;;; shell.el --- Shell configuration for Emacs -*- lexical-binding: t -*-

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

;; Shell configuration for Emacs

;;; Code:

(defun git-prompt-branch-name ()
  "Get current git branch name."
  (let ((args '("symbolic-ref" "HEAD" "--short")))
    (with-temp-buffer
      (apply #'process-file "git" nil (list t nil) nil args)
      (unless (bobp)
        (goto-char (point-min))
        (buffer-substring-no-properties (point) (line-end-position))))))

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file.  The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))))

(defun eshell/x ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))

(defun fish-path (path max-len)
  "Return a potentially trimmed-down version of the directory PATH, replacing
parent directories with their initial characters to try to get the character
length of PATH (sans directory slashes) down to MAX-LEN."
  (let* ((components (split-string (abbreviate-file-name path) "/"))
         (len (+ (1- (length components))
                 (cl-reduce '+ components :key 'length)))
         (str ""))
    (while (and (> len max-len)
                (cdr components))
      (setq str (concat str
                        (cond ((= 0 (length (car components))) "/")
                              ((= 1 (length (car components)))
                               (concat (car components) "/"))
                              (t
                               (if (string= "."
                                            (string (elt (car components) 0)))
                                   (concat (substring (car components) 0 2)
                                           "/")
                                 (string (elt (car components) 0) ?/)))))
            len (- len (1- (length (car components))))
            components (cdr components)))
    (concat str (cl-reduce (lambda (a b) (concat a "/" b)) components))))

(defun sss-eshell-prompt ()
  (defun with-face (str &rest face-plist)
    (propertize str 'face face-plist))
  (concat
   "\n"
   (with-face user-login-name :inherit 'font-lock-function-name-face)
   "@"
   (with-face (system-name) :inherit 'font-lock-function-name-face)
   ": "
   (with-face (if (string= (eshell/pwd) (getenv "HOME"))
	          "~" (fish-path (eshell/pwd) 36))
              :inherit 'font-lock-function-name-face)
   ": "
   (with-face
    (or (ignore-errors (git-prompt-branch-name)) "")
    :inherit 'font-lock-function-name-face)
   "\n"
   (if (= (user-uid) 0)
       "#"
     "λ")
   " "))

(setopt eshell-prompt-regexp "^[^#λ\n]*[#λ] ")
(setopt eshell-prompt-function 'sss-eshell-prompt)
(setopt eshell-highlight-prompt nil)
(setopt eshell-banner-message "Welcome to SSS/GNU - the Supreme Sexp System\n")

(global-set-key (kbd "C-!") 'eshell-here)

(setq sss/eshell-aliases
      '((g  . magit)
	      (gl . magit-log)
	      (d  . dired)
        (h . eshell/history)
	      (o  . find-file)
	      (oo . find-file-other-window)
	      (l  . (lambda () (eshell/ls '-lAh '--group-directories-first)))
        (ll  . (lambda () (eshell/ls '-lAh '--group-directories-first)))
	      (eshell/clear . eshell/clear-scrollback)))

(mapc (lambda (alias)
	(defalias (car alias) (cdr alias)))
      sss/eshell-aliases)

(provide 'sss/shell)

;;; shell.el ends here
