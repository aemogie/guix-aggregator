(require 'package)
(require 'use-package)

(setq custom-file
      (concat (getenv "XDG_CONFIG_HOME")
	      "/custom.el"))
(load-file custom-file)

(use-package swiper)
(use-package counsel
  :bind (("M-x" . counsel-M-x)
  	 ("C-x b" . counsel-ibuffer)
  	 ("C-x C-f" . counsel-find-file)
  	 :map minibuffer-local-map
  	 ("C-r" . counsel-minibuffer-history)))
(use-package ivy
  :diminish
  :bind (("C-s" . swiper-isearch))
  :config
  (ivy-mode 1))
(use-package projectile
  :init
  (setq projectile-project-search-path'("~/dev/"))
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy))
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(add-to-list 'default-frame-alist '(undecorated . t))

(add-to-list 'default-frame-alist '(alpha-background .95))

(use-package gruvbox-theme
  :init (load-theme 'gruvbox t))

(set-face-attribute 'default nil
		      :font "Iosevka Term"
		      :height 200)

(set-face-attribute 'variable-pitch nil
		    :font "Iosevka Etoile")

(setq display-line-numbers-type t) 
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq column-number-mode t)

(global-hl-line-mode t)

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package olivetti
  :hook (org-mode . olivetti-mode))

(use-package mixed-pitch
  :hook (org-mode . mixed-pitch-mode))

(use-package jsonrpc)
(use-package eglot
  :hook
  (c-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  :bind (:map eglot-mode-map
	      ("C-c r" . eglot-rename)
	      ("C-c C-a" . eglot-code-actions)
	      ("C-c C-f" . eglot-format-buffer)
	      ("C-c C-i" . eglot-find-implementations))
  :config
  (setq eglot-autoshutdown t))

(use-package buffer-env
  :config
  (add-hook 'hack-loval-variables-hook #'buffer-env-update)
  (add-hook 'comint-mode-hook #'buffer-env-update)
  :custom
  (buffer-env-script-name "manifest.scm"))

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
