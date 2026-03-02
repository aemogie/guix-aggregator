;; -*- lexical-binding: t; -*-

;; options used in multiple locations throughout this config
(setq guixp (fboundp 'guix-emacs-autoload-packages))
(setq guix-src-dir "~/Documents/code/guix/")
(setq user-font "New Heterodox Mono-12")
(setq meowp nil)

;; handle non-guix systems by installing a nice lil package manager
(unless guixp
  (progn
    (load (concat user-emacs-directory "site-lisp/elpaca-bootstrap.el"))
    (when (eq system-type 'windows-nt)
      (elpaca-no-symlink-mode))
    (setq use-package-always-ensure t)
    (elpaca elpaca-use-package
            (elpaca-use-package-mode))))

(use-package no-littering
  :custom
  (custom-file (no-littering-expand-etc-file-name "custom.el"))
  :config
  (let ((dir (no-littering-expand-var-file-name "lock-files/")))
   (make-directory dir t)
   (setq lock-file-name-transforms `((".*" ,dir t))))
  (no-littering-theme-backups))

(use-package emacs
  :ensure nil ; don't ensure emacs exists
  :hook (text-mode . visual-line-mode)
  :custom
  (line-spacing nil)
  (indent-tabs-mode nil) ; always use spaces
  ;; lil mod for corfu
  ;; (tab-always-indent 'complete)
  :init
  (add-to-list 'default-frame-alist
               `(font . ,user-font))
  :config
  (set-face-attribute 'default t :font user-font)
  (if (boundp 'use-short-answers)
      (setq use-short-answers t)
    (advice-add #'yes-or-no-p :override #'y-or-n-p))
  (setq enable-recursive-minibuffers t)
  (defalias #'view-hello-file #'ignore)  ; Never show the hello file

  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes/"))
  ;; (when (display-graphic-p))
  (set-frame-parameter nil 'alpha-background 85)
  (add-to-list 'default-frame-alist  '(alpha-background . 85))
  ;; load guix copyright development shtuff
  (when (file-directory-p guix-src-dir)
    (load-file (concat guix-src-dir "/etc/copyright.el")))
  (setq copyright-names-regexp
        (format "%s <%s>" user-full-name user-mail-address)))

(use-package guix
  :when guixp
  :custom
  (guix-config-guile-program '("guix" "repl"))
  ;; (guix-config-scheme-compiled-directory (getenv "GUILE_LOAD_COMPILED_PATH"))
  (guix-repl-use-latest nil)
  (guix-repl-use-server nil))


(use-package ligature
  ;; use this package when we are using iosevka or sarasa fonts
  :when (or (string-prefix-p "Iosevka" user-font)
            (string-prefix-p "Sarasa" user-font))
  :load-path "path-to-ligature-repo"
  :config
  ;; Enable all Iosevka ligatures in programming modes
  (ligature-set-ligatures '(prog-mode text-mode)
                          '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->"
                            "<--->" "<---->" "<!--" "<==" "<===" "<=" "=>" "=>>" "==>"
                            "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                            
                            "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                            ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:"
                            "=:" "<******>" "++" "+++"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; pretty symbols :3
(use-package prog-mode
  :ensure nil
  :config
  (global-prettify-symbols-mode))

(use-package display-line-numbers
  :ensure nil
  :hook prog-mode conf-mode
  :config
  ;; prevent the lines from shifting everything right when you get to 100 lines
  (setq display-line-numbers-width-start 3)) 

(use-package whitespace
  :ensure nil
  :hook prog-mode conf-mode text-mode
  :config
  (setq whitespace-style '(trailing)))

(use-package tramp
  :config
  ;; fix remoting into guix / nix systems
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package rainbow-mode
  :custom
  (rainbow-ansi-colors nil)
  (rainbow-html-colors nil)
  (rainbow-x-colors nil)
  :config
  (rainbow-mode))

(use-package autothemer
  :config
  (load-theme 'wlo-autothemer t))

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0) 
  :config
  (ultra-scroll-mode 1))

;; (use-package base16-theme
;;   :custom
;;   (base16-distant-fringe-background 0)
;;   :config
;;   (setq base16-theme-256-color-source 'colors)
;;   (setq base16-distinct-fringe-background nil))
;;   ;; (load-theme 'base16-wlo t))

(use-package tool-bar
  :ensure nil
  :config
  (tool-bar-mode -1))

(use-package scroll-bar
  :ensure nil
  :config
  (scroll-bar-mode -1))

(use-package menu-bar
  :unless (eq system-type 'darwin)
  :ensure nil
  :config
  (menu-bar-mode -1))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package meow
  :when meowp
  :config
  (meow-global-mode 1)
  (setq meow-use-clipboard t)
  ;; bind keys
  (meow-leader-define-key
   '("?" . meow-cheatsheet)
   ;; To execute the original e in MOTION state, use SPC e.
   ;; '("e" . "H-e")
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
   '("b k" . kill-buffer)
   '("f p" . project-find-file)
   '("f f" . find-file))
  (meow-normal-define-key
   '("n" . meow-left)
   '("N" . meow-left-expand)
   '("o" . meow-right)
   '("O" . meow-right-expand)
   '("e" . meow-next)
   '("E" . meow-next-expand)
   '("i" . meow-prev)
   '("I" . meow-prev-expand)
   '("0" . meow-expand-0)
   '("1" . meow-expand-1)
   '("2" . meow-expand-2)
   '("3" . meow-expand-3)
   '("4" . meow-expand-4)
   '("5" . meow-expand-5)
   '("6" . meow-expand-6)
   '("7" . meow-expand-7)
   '("8" . meow-expand-8)
   '("9" . meow-expand-9)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("/" . meow-visit)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-block)
   '("H" . meow-to-block)
   '("j" . meow-join)
   '("k" . meow-kill)
   '("l" . meow-line)
   '("L" . meow-goto-line)
   '("M" . meow-mark-word)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("r" . meow-replace)
   '("s" . meow-insert)
   '("S" . meow-open-above)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-search)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("x" . meow-delete)
   '("X" . meow-backward-delete)
   '("y" . meow-save)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("\\" . meow-keypad)
   '("<escape>" . ignore))
  (meow-motion-overwrite-define-key
   '("n" . meow-left)
   '("o" . meow-right)
   '("e" . meow-next)
   '("i" . meow-prev)
   '("<escape>" . ignore)))

;; it's a lil broken idk why 2024-09-05
;; (use-package beacon
;;   :config
;;   (beacon-mode 1))

(use-package rainbow-delimiters
  :custom
  (rainbow-x-colors nil)
  (rainbow-ansi-colors nil)
  (rainbow-html-colors nil)
  :hook (prog-mode . rainbow-delimiters-mode))

;; might be useful for lisp debugging
;; (use-package prism)
;;  :hook (prog-mode . prism-mode))

(use-package avy
  :bind (("C-c s t" . avy-goto-char-2))
  :config
  (setq avy-keys '(?a ?r ?s ?t ?n ?e ?i ?o)))

;; fuzzy stuff
(use-package vertico
  ;; :ensure t ;; TODO remove this line when guix gets vertico working on emacs 30
  :config
  (vertico-mode))

(use-package vertico-mouse
  ;; :when (display-mouse-p)
  :after vertico
  :config
  (vertico-mouse-mode))

(use-package consult
  :bind (("C-x C-b" . 'consult-buffer)
         ("C-c b b" . 'consult-buffer)
         ("C-x b" . 'consult-project-buffer)
         ("C-x C-S-b" . 'ibuffer))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :config
  (when meowp
    (meow-normal-define-key '("P" . consult-yank-pop))))

(use-package savehist
  :ensure nil ;; builtin
  :config
  (savehist-mode))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act))        ;; pick some comfortable binding
  (("C-c RET" . embark-act)     ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package company
  :hook (after-init . global-company-mode))

(use-package company-lsp
  :after company
  :config
  (push 'company-lsp company-backends))

;; python stuff uncomment when messing about with it
;; (use-package company-jedi
;;   :after company jedi)

(use-package nerd-icons)

;; (use-package nerd-icons-completion
;;   :after nerd-icons
;;   :config
;;   (nerd-icons-completion-mode 1)
;;   (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package vundo)

(use-package eshell
  :ensure nil
  :custom
  (eshell-scroll-to-bottom-on-input 'all)
  :config
  (defalias 'ls 'eza '$*))

;; banger terminal emulator
(use-package eat
  :hook ((eshell-load . eat-eshell-mode)
         (eshell-load . eat-eshell-visual-command-mode))
  :config
  ;; hopefully make eat operate better with meow -- https://github.com/meow-edit/meow/issues/505
  (when meowp
    (defun eat-meow-setup ()
      (add-hook 'meow-normal-mode-hook 'eat-emacs-mode nil t)
      (add-hook 'meow-insert-mode-hook
                (lambda ()
                  (goto-char (point-max))
                  (eat-char-mode))
                nil
                t))
    (add-hook 'eat-mode-hook 'eat-meow-setup))
    (add-hook 'eat-mode-hook 'eat-emacs-mode)
  ;; Replace semi-char mode with emacs mode
  (advice-add 'eat-semi-char-mode :after 'eat-emacs-mode))


(use-package app-launcher
  :when guixp
  :ensure nil   ;; we aren't missing anything if it doesn't work.
  :init         ;; because presumably i'm only ever going to use this on desktop
  (defun emacs-run-launcher ()
     "Create and select a frame called emacs-run-launcher which consists only of a minibuffer and has specific dimensions. Run app-launcher on that frame, which is an emacs command that prompts you to select an app and open it in a dmenu like behaviour. Delete the frame after that command has exited"
     (interactive)
     (with-selected-frame (make-frame '((name . "emacs-run-launcher")
                                        (minibuffer . only)
                                        (width . 120)
                                        (height . 11)
                                        (alpha-background . 35)))
       (unwind-protect
           (app-launcher-run-app)
         (delete-frame)))))

(use-package magit)

(use-package mood-line
 :custom
  ;; Use pretty Fira Code-compatible glyphs
 (mood-line-glyph-alist mood-line-glyphs-unicode)
 (mood-line-segment-modal-meow-state-alist
  '((normal . ("" . font-lock-variable-name-face)) ; the normal pill
    (insert . ("" . font-lock-string-face))
    (keypad . ("" . font-lock-keyword-face))
    (beacon . ("" . font-lock-type-face))
    (motion . ("" . font-lock-constant-face))))
 :config
 (mood-line-mode))

(use-package expand-region
  :config
  (when meowp
    (meow-normal-define-key '("m" . er/expand-region))))

(use-package smartparens
  :hook (lisp-mode emacs-lisp-mode scheme-mode lisp-interaction-mode)
  :config
  ;; sane(?) defaults
  (require 'smartparens-config)
  (sp-use-smartparens-bindings))

;; password manager stuff
(use-package pass)
(use-package password-store
  :init
  (defun emacs-run-pass ()
    "Show a password selection launcher"
   (interactive)
   (with-selected-frame (make-frame '((name . "emacs-run-launcher")
                                      (minibuffer . only)
                                      (width . 120)
                                      (height . 11)
                                      (alpha-background . 35)))
     (unwind-protect
         (call-interactively 'password-store-copy)
       (delete-frame)))))

;; (use-package cape
;;   :bind ("C-c p" . cape-prefix-map)
;;   :init
;;   (add-hook 'completion-at-point-functions #'cape-keyword)
;;   (add-hook 'completion-at-point-functions #'cape-file))


(use-package yasnippet
  :config
  (add-to-list 'yas-snippet-dirs (concat guix-src-dir "/etc/snippets/yas"))
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; (use-package yasnippet-capf
;;   :after cape yasnippet
;;   :bind ("M-p y" . yasnippet-capf)
;;   :config
;;   (add-to-list 'completion-at-point-functions #'yasnippet-capf))


;;; programming in general
(use-package php-mode)
(use-package composer
  :after php-mode)

;;; lisp dev
;; scheme (guile)
(use-package geiser
  :custom
  (geiser-repl-per-project-p t))
(use-package geiser-guile
  :after geiser
  :config
  (add-to-list 'geiser-guile-load-path "."))
(use-package flycheck-geiser
  :after geiser
  :hook (scheme-mode . flycheck-mode))

;; (use-package arei
;;   :custom
;;   (geiser-mode-auto-p nil)
;;   :bind (:map arei-mode-map
;;          ("C-c  m" . mu4e)
;;          ("C-c M M" . mu4e)))

;; common lisp
(use-package sly
  :hook lisp-mode)
(use-package sly-asdf
  :after sly)
(use-package sly-macrostep
  :after sly)
;; (use-package sly-package-inferred
;;   :after sly) ; breaks when loading the sly repl

;;; org mode
(use-package org
  ;; use the built in org-mode that comes with emacs
  :ensure nil
  :custom
  (org-directory "~/Documents/notes/org/")
  :bind (("C-c n a" . org-agenda)))

(use-package ol-man
  :load-path "site-lisp"
  :after org)

(use-package olivetti
  :hook text-mode
  :custom (olivetti-body-width 96))

(use-package org-modern
  :config
  (with-eval-after-load 'org (global-org-modern-mode)))

(use-package org-roam
  :custom
  (org-roam-directory (concat org-directory "roam/"))
  :bind (("C-c n t" . org-roam-dailies-capture-today)
         ("C-c n r b" . org-roam-buffer-toggle)
         ("C-c n r f" . org-roam-node-find)
         ("C-c n r d d" . org-roam-dailies-goto-date)
         ("C-c n r d t" . org-roam-dailies-goto-today)
         ("C-c n r d y" . org-roam-dailies-goto-yesterday)
         ("C-c n r d T" . org-roam-dailies-goto-tomorrow))

  :config
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (setq org-directory "~/Documents/notes/org/")
  (setq org-roam-dailies-capture-templates
        '(("a" "default" entry
           "* %<%H:%M>: %?"
           ;; insert the time to every new daily note
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n"))
          ("d" "dream" entry
           "* %<%H:%M>: [[roam:dream]]\n%?"
           ;; insert the time to every new daily note
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n"))))
  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-section
              #'org-roam-reflinks-section
              ;; enabling unlinked references may be slow, but i don't care
              #'org-roam-unlinked-references-section))
  (org-roam-db-autosync-mode)
  ;; keybindings
  )

(use-package org-roam-todo
  :load-path "site-lisp"
  :after org-roam
  :config
  (add-hook 'find-file-hook #'org-roam-todo-update-tag)
  (add-hook 'before-save-hook #'org-roam-todo-update-tag)
  (advice-add 'org-agenda :before #'org-roam-todo-update-files))

(use-package org-roam-ui
  :after org-roam
  :bind ("C-c n r u" . org-roam-ui-open))

(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode)))

(use-package nftables-mode)

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :init (setq markdown-command "pandoc"))

;; email
;;  https://macowners.club/posts/email-emacs-mu4e-macos/
;; far future TODO look into contexts to send emails from multiple accounts
(use-package mu4e
  :ensure nil
  :bind (("C-c M m" . mu4e)
         ("C-c M M" . mu4e))
  :config
  ;;                         t))
  (setq mu4e-maildir "~/.var/spool/mail/"
        mu4e-get-mail-command (concat "mbsync" " -a")
        mu4e-update-interval 300
        mu4e-attachment-dir "~/Downloads/"
        mu4e-change-filenames-when-moving t
        user-mail-address "willow@phantoma.online"
        user-full-name "willow xyz"
        mu4e-user-mail-address-list '("willow@phantoma.online")
        mu4e-sent-folder            "/willow/Sent"
        mu4e-drafts-folder          "/willow/Drafts"
        mu4e-trash-folder           "/willow/Trash"
        mu4e-refile-folder          "/willow/Inbox"
        smtpmail-smtp-user          "willow@phantoma.online")

  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail)
  (setq mail-user-agent 'mu4e-user-agent)
  (setq message-signature "willow xyz // she/her // https://willow.phantoma.online\n")
  ;; allow emails to encrypt to myself as well for future reading purposes
  ;; (mml-secure-message) encrypts with pgp/mime by default, which is what you'll probably always want
  ;; (mml-secure-sign) will just sign it.
  (setq mml-secure-openpgp-encrypt-to-self t))

(use-package mu4e-alert
  :config
  ;; (mu4e-alert-enable-notifications) ;not working in guix as of 2024-09-01
  (mu4e-alert-enable-mode-line-display))

(use-package message-view-patch
  :hook (gnus-part-display . message-view-patch-highlight))

(use-package erc
  :bind
  (("C-c i I" . wlo-connect-irc)
   ("C-c i b" . erc-switch-to-buffer))
  :custom
  (erc-lurker-hide-list '("JOIN" "PART" "QUIT"))
  (erc-sasl-auth-source-function #'erc-sasl-auth-source-password-as-host)
  (erc-kill-buffer-on-part t)
  :init
  (defun wlo-connect-irc ()
    (interactive)
    (let ((erc-sasl-auth-source-function #'erc-sasl-auth-source-password-as-host)
          (soju "irc.xyzzy.link"))
      (erc-tls :server soju
               :port 6698
               :user "wizard/irc.xyzzy.link@erc")
      (erc-tls :server soju
               :port 6698
               :user "wizard/libera.chat@erc")
      (erc-tls :server soju
               :port 6698
               :user "wizard/toast.cafe@erc")
      (erc-tls :server soju
               :port 6698
               :user "wizard/espernet@erc")
      (erc-tls :server soju
               :port 6698
               :user "wizard/irebird@erc")
      (erc-tls :server soju
               :port 6698
               :user "wizard/akkoma@erc")))
  :config
  (add-to-list 'erc-modules 'notifications)
  (add-to-list 'erc-modules 'spelling)
  (add-to-list 'erc-modules 'sasl)
  (erc-update-modules))

(use-package elfeed
  :bind ("C-c w" . elfeed))

(use-package elfeed-org
  :custom
  (rmh-elfeed-org-files (list (concat org-directory "elfeed.org")))
  :config
  (elfeed-org))

(use-package elfeed-tube
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)
  :bind (:map elfeed-show-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)
         :map elfeed-search-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)))

(use-package elfeed-tube-mpv
  :after elfeed-tube
  :bind (:map elfeed-show-mode-map
              ("C-c C-f" . elfeed-tube-mpv-follow-mode)
              ("C-c C-w" . elfeed-tube-mpv-where)))

(use-package dashboard
  :bind ("C-c d" . dashboard-open)
  :custom
  (dashboard-footer-messages
   '("what is it you desire?"))
  (dashboard-set-heading-icons nil)
  (dashboard-set-file-icons nil)
  (dashboard-startup-banner (concat user-emacs-directory "banner.txt"))
  (dashboard-banner-logo-title "welcome home, good hunter")
  (dashboard-center-content t)
  (dashboard-projects-backend 'project-el)
  (dashboard-items
   '((projects . 5)
     (agenda   . 5)))
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-newline
                               dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-navigator
                               dashboard-insert-newline
                               dashboard-insert-items
                               dashboard-insert-newline
                               dashboard-insert-footer  ;; (dashboard-icon-type 'nerd-icons)
                               dashboard-insert-newline
                               dashboard-insert-init-info))
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name))))

(use-package package
  :init
  (add-to-list 'package-archives '("MELPA" . "http://melpa.org/packages/")))

(use-package org-msg
  ;; broken as of 2024-09-01 in guix repos, latest commit needs to be applied
  :ensure t
  :config
  (setq org-msg-default-alternatives '((new           . (text))
                                       (reply-to-html . (text html))
                                       (reply-to-text . (text))))
  (org-msg-mode))

(use-package dirvish
  :bind
  (("C-c f d d" . dirvish-dwim)
   ("C-c f d s" . dirvish-side)
   :map dirvish-mode-map
   ("C-f" . dired-find-file)
   ("C-b" . dired-up-directory))
  :init
  (dirvish-override-dired-mode)
  :config
  ;; (dirvish-peek-mode) ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode)
  (dirvish-define-preview eza (file)
    "Use `eza' to generate directory preview."
    :require ("eza") ; tell Dirvish to check if we have the executable
    (when (file-directory-p file) ; we only interest in directories here
      `(shell . ("eza" "-al" "--color=always" "--icons"
                 "--group-directories-first" ,file))))
  (add-to-list 'dirvish-preview-dispatchers 'eza)
  (setq dirvish-mode-line-format
      '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-mode-line-height 10)
  (setq dirvish-attributes
        '(nerd-icons file-time file-size collapse subtree-state vc-state git-msg))
  (setq dirvish-subtree-state-style 'nerd)
  (setq dirvish-path-separators (list
                                 (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                 (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                 (format " %s " (nerd-icons-faicon "nf-fa-angle_right"))))
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group"))


(use-package debbugs
  ;; only really useful from guix itself
  :when guixp
  :config
  ;;; Bug references.
  (add-hook 'prog-mode-hook #'bug-reference-prog-mode)
  (add-hook 'gnus-mode-hook #'bug-reference-mode)
  (add-hook 'erc-mode-hook #'bug-reference-mode)
  (add-hook 'gnus-summary-mode-hook #'bug-reference-mode)
  (add-hook 'gnus-article-mode-hook #'bug-reference-mode)

  ;;; This extends the default expression (the top-most, first expression
  ;;; provided to 'or') to also match URLs such as
  ;;; <https://issues.guix.gnu.org/58697> or <https://bugs.gnu.org/58697>.
  ;;; It is also extended to detect "Fixes: #NNNNN" git trailers.
  (setq bug-reference-bug-regexp
        (rx (group (or (seq word-boundary
                            (or (seq (char "Bb") "ug"
                                     (zero-or-one " ")
                                     (zero-or-one "#"))
                                (seq (char "Pp") "atch"
                                     (zero-or-one " ")
                                     "#")
                                (seq (char "Ff") "ixes"
                                     (zero-or-one ":")
                                     (zero-or-one " ") "#")
                                (seq "RFE"
                                     (zero-or-one " ") "#")
                                (seq "PR "
                                     (one-or-more (char "a-z+-")) "/"))
                            (group (one-or-more (char "0-9"))
                                   (zero-or-one
                                    (seq "#" (one-or-more
                                              (char "0-9"))))))
                       (seq (? "<") "https://bugs.gnu.org/"
                            (group-n 2 (one-or-more (char "0-9")))
                            (? ">"))
                       (seq (? "<") "https://issues.guix.gnu.org/"
                            (? "issue/")
                            (group-n 2 (one-or-more (char "0-9")))
                            (? ">"))))))
  (setq bug-reference-url-format "https://issues.guix.gnu.org/%s")
  (add-hook 'bug-reference-mode-hook #'debbugs-browse-mode)
  (add-hook 'bug-reference-prog-mode-hook #'debbugs-browse-mode)

  ;; The following allows Emacs Debbugs user to open the issue directly within
  ;; Emacs.
  (setq debbugs-browse-url-regexp
        (rx line-start
            "http" (zero-or-one "s") "://"
            (or "debbugs" "issues.guix" "bugs")
            ".gnu.org" (one-or-more "/")
            (group (zero-or-one "cgi/bugreport.cgi?bug="))
            (group-n 3 (one-or-more digit))
            line-end))

  ;; Change the default when run as 'M-x debbugs-gnu'.
  (setq debbugs-gnu-default-packages '("guix" "guix-patches"))

  ;; Show feature requests.
  (setq debbugs-gnu-default-severities
   '("serious" "important" "normal" "minor" "wishlist")))

(use-package pdf-tools
  :config
  (pdf-tools-install))

(use-package 0x0)

;; useless garbage
(use-package elcord
  :ensure nil)

;; OPTIONAL configuration
(use-package gptel
  :ensure nil
  :config
  (setq
   ;; gptel-max-tokens 500
   gptel-backend (gptel-make-openai "Ollama"
                   :protocol "http"
                   :host "localhost:11434"
                   :stream t
                   :models '(ren-darkidol:latest ren-cavesofqwen:latest ren-eximius:latest)))
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response))

;; optimizes emacs' garbage collection
(use-package gcmh
  :hook (after-init . gcmh-mode)
  :custom
  (gcmh-idle-delay 'auto)
  (gcmh-auto-idle-delay-factor 10))

(if (file-exists-p "out-of-band.el")
    (load "out-of-band.el"))
