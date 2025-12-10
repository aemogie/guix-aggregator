(require 'package)
(require 'use-package)

(setq custom-file
      (concat (getenv "XDG_CONFIG_HOME")
	      "/emacs/custom.el"))
(load-file custom-file)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq create-lockfiles nil)

(use-package diminish)
(use-package swiper)
(use-package counsel
  :bind (("M-x" . counsel-M-x)
  	 ("C-x b" . counsel-ibuffer)
  	 ("C-x C-f" . counsel-find-file)
  	 :map minibuffer-local-map
  	 ("C-r" . counsel-minibuffer-history)))
(use-package ivy
  :diminish ivy-mode
  :bind (("C-s" . swiper-isearch))
  :config
  (ivy-mode 1))
(use-package projectile
  :diminish projectile-mode
  :init
  (setq projectile-project-search-path'("~/dev/"))
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy))
(use-package which-key
  :diminish which-key-mode
  :defer 0
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(add-to-list 'default-frame-alist '(undecorated . t))

(add-to-list 'default-frame-alist '(alpha-background . 95))

(use-package gruvbox-theme
  :init (load-theme 'gruvbox t))

(set-face-attribute 'default nil
		      :font "Iosevka Term"
		      :height 200)

(set-face-attribute 'variable-pitch nil
		    :font "Iosevka Etoile")

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->"
				       "<!--" "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>"
				       "<===>" "<====>" "<!---" "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!="
				       "===" "!==" ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:"
				       "=:" "<******>" "++" "+++"))
  (global-ligature-mode t))

(setq display-line-numbers-type t) 
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq column-number-mode t)

(setq display-time-24hr-format t
      display-time-format "%H:%M")
(setq display-time-day-and-date t)
(when (not (display-graphic-p))
  (display-battery-mode 1)
  (display-time-mode 1))

(global-hl-line-mode t)

(use-package org-auto-tangle
  :diminish
  :hook (org-mode . org-auto-tangle-mode))

(use-package org-modern
  :diminish org-modern-mode
  :hook (org-mode . org-modern-mode))

(use-package olivetti
  :diminish olivetti-mode
  :hook (org-mode . olivetti-mode))

(use-package mixed-pitch
  :diminish mixed-pitch-mode
  :hook (org-mode . mixed-pitch-mode))

(setq org-capture-templates
      '(("t" "TODO" entry
       (file+headline "~/docs/org/00-inbox.org" "Inbox")
       "* TODO %^{Task}\n"
       ":PROPERTIES:\n"
       ":CREATED: %U\n"
       ":CAPTURED: %a\n"
       ":END:\n%?")
	("i" "Immersion" entry
	 (file+olp+datetree "~/docs/org/immersion.org")
	  "* %^{Immersion|Passive|Active|Reading} %U  :%\\1:"
	 :clock-in t
	 :clock-keep t)))

;; (defun my/org-write-clock-status ()
;;   "Write the current org-clock status to ~/.cache/org-clock-current."
;;   (require 'org-clock)
;;   (let ((file "~/.cache/org-clock-current"))
;;     (with-temp-file file
;;       (if (org-clocking-p)
;;           (insert (format "%s"
;;                           (org-clock-get-clock-string)))
;;         (insert "")))))
;; (add-hook 'org-clock-in-hook #'my/org-write-clock-status)
;; (add-hook 'org-clock-out-hook #'my/org-write-clock-status)
;; (add-hook 'org-clock-cancel-hook #'my/org-write-clock-status)
;; (add-hook 'org-clock-in-resume-hook #'my/org-write-clock-status)
;; (run-with-timer 0 60 #'my/org-write-clock-status)

(use-package org-roam
  :custom
  (org-roam-directory "~/docs/org/roam")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n j" . org-roam-dailies-capture-today)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point))
  :config
  (unless (file-exists-p "~/docs/org/roam")
    (make-directory "~/docs/org" t))
  (org-roam-setup))
(require 'org-protocol)
(server-start)

(use-package jsonrpc)
(use-package eglot
  :hook
  (zig-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  :bind (:map eglot-mode-map
	      ("C-c r" . eglot-rename)
	      ("C-c C-a" . eglot-code-actions)
	      ("C-c C-f" . eglot-format-buffer)
	      ("C-c C-i" . eglot-find-implementations))
  :config
  (add-to-list 'eglot-server-programs
	       '(zig-mode . ("zls")))
  (setq eglot-autoshutdown t))

(setq compilation-save-buffers-predicate nil)
(setq compilation-scroll-output 'first-error)
(setq compilation-ask-about-save nil)
(setq compilation-always-kill t)
(setq ansi-color-for-compilation-mode t)
(setq eglot-events-buffer-size 0)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

(use-package buffer-env
  :config
  (add-hook 'hack-local-variables-hook #'buffer-env-update)
  (add-hook 'comint-mode-hook #'buffer-env-update)
  :custom
  (buffer-env-script-name "manifest.scm"))

(setq gdb-many-windows t)
(setq gdb-find-source-frame t)
(setq gdb-same-frame t)
(setq gdb-show-main t)

(use-package treemacs)
(use-package treemacs-projectile)
(use-package imenu-list
  :config
  (setq imenu-list-focus-after-activation t)
  :bind (("C-." . imenu-list-smart-toggle)))

(add-hook 'c-mode-hook
	  #'(lambda() (add-hook 'before-save-hook
				'eglot-format-buffer nil t)))
(add-hook 'c++-mode-hook
	  #'(lambda() (add-hook 'before-save-hook
				'eglot-format-buffer nil t)))

(use-package zig-mode)

(use-package meow)
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   '("j" . "H-j")
   '("k" . "H-k")
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
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   ;; regular meow
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
   '("c" . org-capture)
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
   '("y" . meow-clipboard-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)
   ;; custom keybindings start here
   '("+" . emms-volume-raise)
   '("=" . emms-volume-lower)
   '("?" . treemacs-add-and-display-current-project-exclusively)))
(require 'meow)
(meow-setup)
(meow-global-mode 1)
