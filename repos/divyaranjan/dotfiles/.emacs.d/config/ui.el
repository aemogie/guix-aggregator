;;; ui.el --- Emacs User Interface Configuration File -*- lexical-binding: t -*-
;;; Commentary:
;;;; Divya's Emacs UI Configurations

;;; Code:
;; Making sure icons work
(use-package all-the-icons
  :straight t
  :if (display-graphic-p))

;;; Icons in dired
(use-package all-the-icons-dired
  :straight t
  :hook
  (dired-mode . all-the-icons-dired-mode))

(use-package crux
  :straight t

  :bind
  (("C-x w v" . crux-swap-windows)
   ("C-o"     . crux-smart-open-line)
   ("C-x B"   . divya/org-scratch)
   :map dired-mode-map
   ("O" . crux-open-with))
  :config
  (defun divya/org-scratch ()
    (interactive)
    (let ((initial-major-mode 'org-mode))
      (crux-create-scratch-buffer))))

;; We don't want the welcome page
(setq inhibit-startup-message t)

;; Disabling Menus and Other things
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;No Fringes & weird breaks
(fringe-mode 0)
(global-visual-line-mode 1)

;; Adding Numbers
(global-display-line-numbers-mode 1)

;; Themes
;; (load-theme 'modus-vivendi t)
(use-package ef-themes
  :straight t)

(use-package sexy-monochrome-theme
  :straight t)

;;(load-theme 'sexy-monochrome-theme t)

(global-set-key (kbd "C-<f12>") 'consult-theme)

;(load-theme 'ef-dark t)
;; Change theme depending on the time of the day
(setq calendar-longitude 85.69
      calendar-latitude 20.16)

;; Highlighting the current line
(global-hl-line-mode 1)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; An eternally blinking cursor
(blink-cursor-mode 1)

;; Recent files
(recentf-mode 1)
(global-set-key (kbd "C-c r") 'consult-recent-file)
;; (divya/leader-keys
;;  "rf" 'crux-recentf-find-file)

;; Saves history of commands
(setq history-length 300)
(savehist-mode 1)

;; Remember where you were last time in the file
(save-place-mode 1)

;; No GUI dialog boxes
(setq use-dialog-box nil)

;; Emacs updates file changes on the fly
(global-auto-revert-mode 1)

;; Do the same with dired
(setq global-auto-revert-non-file-buffers t)

;;;; Display hex colors in emacs
(use-package rainbow-mode
  :straight t
  :init
  (rainbow-mode 1))

;; Notifications

(use-package alert
  :straight t
  :commands alert
  :config
  (setq alert-default-style 'notifications))

;; A nice Doom-like modeline
(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 8)))

(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

;; File size in modeline

(setq size-indication-mode t)
(setq column-number-mode t)

;; Multiple time zones
(setq display-time-world-list
      '(("Etc/UTC" "UTC")
	("America/New_York" "New York")
	("Europe/London" "London")))
(setq display-time-world-time-format "%a, %d %b %I:%M %p %Z")

;;; Disabling line numbers for some modes

(dolist (mode '(org-mode-hook
		eshell-mode-hook
		shell-mode-hook
		term-mode-hook
		eat-mode-hook
		pdf-view-mode-hook
		pdf-outline-buffer-mode-hook
		doc-view-mode-hook
		image-dired-mode-hook
		dired-mode-hook
		nov-mode-hook
		writeroom-mode-hook
		eww-mode-hook
					;		elfeed-search-mode-hook
		elfeed-show-mode-hook
		image-mode-hook
		dirvish-directory-view-mode-hook
		org-agenda-mode-hook
					;		mu4e-headers-mode-hook
					;		mu4e-search-hook
					;		mu4e-org-mode-hook
		hs-lint-mode-hook
		special-mode-hook
		inferior-ess-mode-hook
		help-mode-hook
		mu4e-view-mode-hook
		mu4e-compose-mode-hook
		calendar-mode-hook
                mu4e-main-mode-hook
		dictionary-mode-hook
		forth-interaction-mode-hook
		bookmark-bmenu-mode-hook
		which-key-mode-hook
		erc-mode-hook
		speedbar-mode-hook
		rcirc-mode-hook
		jabber-chat-mode-hook
		ement-room-mode-hook
		magit-popup-mode-hook
		olivetti-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Disabling blinking cursor when reading things.
(dolist (mode '(pdf-view-mode-hook
		doc-view-mode-hook))
  (add-hook mode (lambda () (blink-cursor-mode -1))))

;;; Setting the font

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun fontify-frame (frame)
  (set-frame-parameter frame 'font "Victor Mono Medium-13"))

;; Fontify current frame
(fontify-frame nil)

;; (set-face-attribute 'default nil :font "Spline Sans Mono" :weight 'regular :height 120)

;; ;; Fontify any future frames
(push 'fontify-frame after-make-frame-functions)

;; Unicode, Emojis UTF-8
(use-package unicode-fonts
  :straight t
  :custom
  (unicode-fonts-skip-font-groups '(low-quality-glyps))
  (unicode-fonts-setup))

(prefer-coding-system 'utf-8)

(use-package emojify
  :straight t
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

;; Relative Numbers

(menu-bar--display-line-numbers-mode-relative)

;; Smartparens
(use-package smartparens
  :straight t
  :init (smartparens-global-mode 1)
  :hook (prog-mode . smartparens-mode))

;; which-key
(use-package which-key
  :straight t
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

;;; For some focus in life (Writeroom-mode)
(use-package writeroom-mode
  :straight t
  :init (global-writeroom-mode 1)
  :config
  (setq writeroom-width 100
	writeroom-fullscreen-effect 1
	writeroom-mode-line t
	writeroom-major-modes '(org-mode markdown-mode nov-mode Info-mode)))

(defun divya/enable-focus ()
  "To enable the focus-mode."
  (interactive)
  (writeroom-mode 1)
  (display-line-numbers-mode 0))

(defun divya/disable-focus ()
  "To disable the focus mode."
  (interactive)
  (writeroom-mode 0)
  (display-line-numbers-mode 1))

(defun divya/toggle-focus ()
  "To toggle the focus mode."
  (interactive)
  (if (symbol-value writeroom-mode)
      (divya/disable-focus)
    (divya/enable-focus)))

;; File Icons
(use-package all-the-icons-dired
  :straight t
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

;; Some Tweaks
(setq auto-window-vscroll nil)

;; Currently using Vertico

;;; Vertico : Minibuffer Completion

;; (use-package vertico
;;   :straight t
;;   :bind (:map vertico-map
;;          ("C-j" . vertico-next)
;;          ("C-k" . vertico-previous)
;;          ("C-f" . vertico-exit)
;;          :map minibuffer-local-map
;;          ("M-h" . backward-kill-word))
;;   :custom
;;   (vertico-cycle t)
;;   :init
;;   (vertico-mode))

;;; Replacing Vertico with Icomplete

(use-package icomplete
  :bind (:map icomplete-minibuffer-map
              ("C-n" . icomplete-forward-completions)
              ("C-p" . icomplete-backward-completions)
              ("C-v" . icomplete-vertical-toggle)
              ("RET" . icomplete-force-complete-and-exit))
  :hook
  (after-init . (lambda ()
                  (fido-mode -1)
                  (icomplete-mode 1)
                  (icomplete-vertical-mode 1)))
  :config
  (setq tab-always-indent 'complete)  ;; Starts completion with TAB
  (setq icomplete-delay-completions-threshold 0)
  (setq icomplete-compute-delay 0)
  (setq icomplete-show-matches-on-no-input t)
  (setq icomplete-hide-common-prefix nil)
  (setq icomplete-prospects-height 10)
  (setq icomplete-separator " . ")
  (setq icomplete-with-completion-tables t)
  ;;  (setq icomplete-in-buffer t)
  (setq icomplete-max-delay-chars 0)
  (setq icomplete-scroll t)
  ;; (advice-add 'completion-at-point
  ;;             :after #'minibuffer-hide-completions)
  )

;;; Saving History
(use-package savehist
  :init
  (savehist-mode))

;;; Marginalia Annotation

(use-package marginalia
  :straight t
  :after icomplete
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

;;; Icons in completion
(use-package all-the-icons-completion
  :straight t
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;;; Orderless
(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless))      ; Use orderless
  (completion-category-defaults nil)    ; I want to be in control!
  (completion-category-overrides
   '((file (styles orderless)))))

;;; Consult
(use-package consult
  :straight t
  :bind (("C-c r" . consult-recent-file)
	 ("C-c t" . consult-theme)
	 ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)

         ;; M-s bindings in `search-map'
         ("M-g d" . consult-find)                  ;; Alternative: consult-fd
         ("M-g C-l" . consult-locate)
         ("M-g G" . consult-grep)
         ("M-s-g" . consult-git-grep)
         ("M-g r" . consult-ripgrep)
         ("M-g L" . consult-line)
         ("M-g M-l" . consult-line-multi)
         ("M-g M-k" . consult-keep-lines)
;;         ("C-x s u" . consult-focus-lines)

         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi))            ;; needed by consult-line to detect isearch

  :init
  (setq xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref))

;; Use `consult-completion-in-region' if Vertico is enabled.
;; Otherwise use the default `completion--in-region' function.
;; (setq completion-in-region-function
;;       (lambda (&rest args)
;; 	(apply (if icomplete-vertical-mode
;; 		   #'consult-completion-in-region
;; 		 #'completion--in-region)
;; 	       args)))

;;; Emacs Dashboard

(use-package dashboard
  :straight t
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  ;; Set the title
  (setq dashboard-banner-logo-title "Live to the point of tears!")
  ;; Set the banner
  (setq dashboard-startup-banner "~/.dotfiles/.emacs.d/lisp.png")
  (setq dashboard-image-banner-max-width '250)
  (setq dashboard-image-banner-max-height '250)

  ;; Content is not centered by default. To center, set
  (setq dashboard-center-content t)

  ;; To disable shortcut "jump" indicators for each section, set
  (setq dashboard-show-shortcuts t)

  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-navigator t))

(define-key dashboard-mode-map (kbd "M-r") 'dashboard-refresh-buffer)

(setq dashboard-projects-backend 'project.el)

;;; Some fancy focusing

;; (use-package solaire-mode
;;   :straight t
;;   :init
;;   (solaire-global-mode +1))

;; (use-package dimmer
;;   :straight t
;;   :config
;;   (dimmer-configure-which-key)
;;   (dimmer-mode t))

;;; Golden ratio
;; From https://git.sr.ht/~wklew/golden
;; (require 'golden)
;; (global-golden-mode 1)

;; ;; Hyperbole : Managing hypertexts on buffers
;; (use-package hyperbole
;;   :straight t
;;   :init
;;   (hyperbole-mode 1))

;;; Justify-kp

(use-package justify-kp
  :straight (:host github :repo "Fuco1/justify-kp"))

;;; Drag and drop
(use-package org-download
 :straight t
 :config
 (setq org-download-backend "curl")
 :bind ("C-c y" . org-download-clipboard))

(add-hook 'dired-mode-hook 'org-download-enable)

;; Prettify
(global-prettify-symbols-mode)

;; (setq lisp-prettify-symbols-alist '("lambda" . λ))

;; Show time in 24hr
(setq display-time-format "%Z:%H:%M")
(display-time-mode 1)

(provide 'ui.el)
;;; ui.el ends here
