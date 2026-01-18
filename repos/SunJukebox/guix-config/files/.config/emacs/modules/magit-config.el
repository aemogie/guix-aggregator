;;; magit-config.el --- Configure magit              -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'pcase)

;; We need to :ensure t transient because transient and magit are often
;; developed side-by-side, which means that if we want the newest magit, we ALSO
;; need the newest transient.
(use-package transient
  :ensure nil
  :defer nil)

(use-package magit
  :ensure nil
  :defer t
  :requires compat
  :bind
  (;; Open Magit Status (git status) for git handling
   ("C-x g" . #'magit-status)
   ;; Bring up a small menu to choose to do magit things
   ("C-x M-g" . #'magit-dispatch)
   ;; With `git blame`, we can find out the commits that changed certain lines and/or regions
   ("C-c b" . #'magit-blame))
  :custom
  (magit-no-confirm '(stage-all-changes unstage-all-changes))
  (magit-clone-default-directory "~/Repos/")
  (magit-auto-revert-mode t)
  (magit-tramp-pipe-stty-settings 'pty))

;; Display TODO/FIXME/other tagged items in the repository in the magit-status
;; buffer.
(use-package magit-todos
  :ensure nil
  :demand t ; Use :demand, because we still autoload magit
  :after magit
  :custom
  (magit-todos-keywords-list
   (mapcar (pcase-lambda (`(,keyword . ,rgb-face))
             keyword)
           hl-todo-keyword-faces))
  (magit-todos-auto-group-items 50)
  (magit-todos-exclude-globs '(".git/"))
  :config
  (magit-todos-mode))

(use-package forge
  :ensure nil
  :after magit)

;; Add major-modes for .gitconfig, .gitattributes, and .gitignore, along with
;; their other named variants.
(use-package git-modes
  :ensure nil
  :defer t)

(provide 'magit-config)
;;; magit-config.el ends here
