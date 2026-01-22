;;; -*- lexical-binding: t -*-

(defvar mac-command-modifier nil
  "Modifier key to use for the Mac command key.")

(defvar mac-option-modifier nil
  "Modifier key to use for the Mac option key.")

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'none)
(add-to-list 'default-frame-alist '(undecorated-round . t))

;;;;;;;;;;;;;;;;;;;;;
;; emacs settings ;;¡
;;;;;;;;;;;;;;;;;;;;;

(defvar is-guix nil
  "Variable indicating whether system is managed by guix.")

(defvar is-mac nil
  "Variable indicating whether system is managed by guix.")

(when is-mac
  (setq mac-command-modifier 'meta))

(setq is-mac (not (string-equal (system-name) "persepolis.local")))

;; define personal keybinding prefix (an unpragmatic keybinding repurposed for reprogrammed keyboard)
(defvar my-map (make-sparse-keymap))
(define-key global-map (kbd "C-M-]") my-map)

;; remap keyboard-quit For qmk keyboards
(global-set-key (kbd "C-M-s-]") 'keyboard-quit)

;; an all-purpose emacs alarm
(defun my/alarm (&optional length &rest _)
  "My Emacs alarm. If optional parameter LENGTH is `long`, plays the longer alarm."
  (let ((file (expand-file-name (if (equal length "long")
                                    "sounds/bell_multiple.wav"
                                  "sounds/bell.wav")
                                user-emacs-directory)))
    (start-process-shell-command "org" nil (concat "aplay " file))))

;;;;;;;;;;;;;;;;;;;;;;
;; package settings ;; 
;;;;;;;;;;;;;;;;;;;;;;

(when is-guix
  (let ((guix-emacs-dir "/home/pol/.guix-profile/share/emacs/site-lisp"))
    (add-to-list 'load-path guix-emacs-dir))
  (use-package geiser
    :ensure t))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
  			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; refresh package lists
 (unless package-archive-contents
   (package-refresh-contents))

;; straight package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;;;;;;;;;;;;;;;;;;
;; file settings ;;
;;;;;;;;;;;;;;;;;;;

;; store backup files in separate directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; store lock-file symlinks in separate directory
(setq lock-file-name-transforms `((".*" "~/temp/emacs-lockfiles/" t)))

;; super-save
(use-package super-save
  :ensure t
  :custom
  (super-save-auto-save-when-idle t)
  (super-save-all-buffers t)
  (super-save-triggers '(consult-buffer find-file previous-buffer next-buffer))
  :config
  (super-save-mode 1))

(setq auto-save-default nil) ; autosave now redundant

(use-package no-littering
  :ensure t)

;; exclude from recentf
(require 'recentf)
(setq recentf-exclude '("schedule.org" "tasks.org" "init.el" "bookmark-default.el" "COMMIT_EDITMSG" "oauth2-auto.plist"))

;;;;;;;;;;;;;;;;;
;; ui settings ;;
;;;;;;;;;;;;;;;;;

;; everforest
(use-package everforest-theme
  :straight (everforest :type git :host github :repo "Theory-of-Everything/everforest-emacs")
  :defer t
  :config
  (load-theme 'everforest-hard-dark t t)
  (load-theme 'everforest-hard-light t t)
  (load-theme 'everforest-hard-olddark t t)
  (load-theme 'everforest-hard-oldlight t t))

(use-package cherry-seoul256-theme
  :straight (cherry-seoul256 :type git :host github :repo "polhuang/cherry-seoul256")
  :demand t
  :custom
  (cherry-seoul256-background 233)
  :config
  (load-theme 'cherry-seoul256 t))


(defvar my/themes '(cherry-seoul256 modus-vivendi modus-operandi tango-dark)
    "List of themes to cycle through.")

(defvar my/current-theme-index 0
  "Index of the current theme in my/themes list.")

(defun my/cycle-theme ()
  "Cycle through themes in my/themes list."
  (interactive)
  ;; Disable all custom themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load next theme
  (setq my/current-theme-index
        (mod (1+ my/current-theme-index) (length my/themes)))
  (let ((theme (nth my/current-theme-index my/themes)))
    (load-theme theme t)
    (message "Loaded theme: %s" theme)))

;; ansi colors
(require 'ansi-color)
(dolist (pair
         '((ansi-color-black           . "#1b1b23")
           (ansi-color-red             . "#ebb9b9")
           (ansi-color-green           . "#caf6bb")
           (ansi-color-yellow          . "#e6dfb8")
           (ansi-color-blue            . "#cddbf9")
           (ansi-color-magenta         . "#f6bbe7")
           (ansi-color-cyan            . "#b8dceb")
           (ansi-color-white           . "#c8cedc")
           (ansi-color-bright-black    . "#3a3a45")
           (ansi-color-bright-red      . "#d95e59")
           (ansi-color-bright-green    . "#8fc587")
           (ansi-color-bright-yellow   . "#ffcf85")
           (ansi-color-bright-blue     . "#4a83c3")
           (ansi-color-bright-magenta  . "#f6bbe7")
           (ansi-color-bright-cyan     . "#4eb3cd")
           (ansi-color-bright-white    . "#e6e6ee")))
  (let ((face (car pair)) (fg (cdr pair)))
    (set-face-attribute face nil :foreground fg :background 'unspecified)))


(with-eval-after-load 'marginalia
  (set-face-attribute 'marginalia-documentation nil :inherit 'doom-mode-line :slant 'italic))

;; misc ui settings
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'fringe-mode) (fringe-mode 0))

(global-hl-line-mode t)
(tooltip-mode -1)
(global-visual-line-mode 1)
(column-number-mode)
(global-prettify-symbols-mode 1)
(setq visible-bell t
      use-dialog-box nil
      inhibit-startup-message t
      inhibit-splash-screen t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)
(fset #'display-startup-echo-area-message #'ignore)

;; frame + window management
(use-package activities
  :config
  (activities-mode))

;; transparency
(add-to-list 'default-frame-alist '(alpha-background . 65))

(defun my/increase-transparency ()
    "Increase frame transparency by 10 (make more transparent)."
    (interactive)
    (let* ((current-alpha (or (frame-parameter nil 'alpha-background) 100))
           (new-alpha (max 0 (- current-alpha 10))))
      (set-frame-parameter nil 'alpha-background new-alpha)
      (message "Transparency: %d%%" new-alpha)))

(defun my/decrease-transparency ()
  "Decrease frame transparency by 10 (make more opaque)."
  (interactive)
  (let* ((current-alpha (or (frame-parameter nil 'alpha-background) 100))
         (new-alpha (min 100 (+ current-alpha 10))))
    (set-frame-parameter nil 'alpha-background new-alpha)
    (message "Transparency: %d%%" new-alpha)))

;; fonts
(defvar my/font-options
  '(("Aporetic Sans Mono" . 125)
    ("Source Code Pro" . 125)
    ("DejaVu Sans Mono" . 125)
    ("Fira Code" . 125)
    ("IBM Plex Mono" . 125)
    ("Inconsolata" . 150)
    ("Noto Sans Mono" . 110)
    ("AcPlus IBM VGA 8x16" . 170)
    ("JetBrains Mono" . 125)
    ("mononoki" . 125)
    ("Random" . nil))
  "An alist of font names and their corresponding heights.
Each element is a cons cell (FONT-NAME . HEIGHT).")

(defvar my/current-font-index 0
  "Index of the currently selected font in `my/font-options`.")

(defun my/set-font (font-name)
  "Set Emacs font."
  (let* ((font (if (string= font-name "Random")
                   (nth (random (length (remove (assoc "Random" my/font-options) my/font-options))) my/font-options)
                 (assoc font-name my/font-options)))
         (font-name (car font))
         (height (cdr font)))
    (when font
      (set-face-attribute 'default nil :family font-name :height (or height 120))
      (message "Font set to: %s with height %d" font-name (or height 120)))))

(defun my/select-font ()
  "Select font from a list."
  (interactive)
  (let* ((font-names (mapcar #'car my/font-options))
         (selected-font (completing-read "Select font: " font-names nil t)))
    (my/set-font selected-font)))

(defun my/cycle-font ()
  "Cycle through the fonts in `my/font-options` and set the next one."
  (interactive)
  (let* ((num-fonts (length my/font-options))
         (new-index (mod (1+ my/current-font-index) num-fonts))
         (font (nth new-index my/font-options))
         (font-name (car font)))
    (setq my/current-font-index new-index)
    (my/set-font font-name)))

(my/set-font "Fira Code") ;; default

;; fontify-face
(use-package fontify-face
  :ensure t)

;; rainbow mode
(use-package rainbow-mode
  :ensure t)

;; chinese font
(set-fontset-font t
                  (cons (decode-char 'ucs #x4E00) (decode-char 'ucs #x9FFF))
                  "Noto Sans CJK TC")

;; add the new face to the `face-font-family-alternatives` variable
(setq face-font-family-alternatives
      '(("Noto Sans CJK TC" "han" "cjk")
        ("Sans Serif" "latin")))

;; apply the new face to Chinese characters
(set-fontset-font "fontset-default"
                  (cons (decode-char 'ucs #x4E00) (decode-char 'ucs #x9FFF))
                  "my-chinese-face")

;; icons
(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-completion
  :ensure t)

;; uncomment on new systems / move to guix
;; (nerd-icons-install-fonts)

(use-package nerd-icons-corfu
  :ensure t
  ;; nerd-icons-corfu-formatter added to corfu-margin-formatters in corfu section
  )

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :ensure t
  :hook (marginalia-mode . nerd-icons-completion-mode))

(use-package nerd-icons-ibuffer
  :ensure t
  :hook
  (ibuffer-mode . nerd-icons-ibuffer-mode))

;;;;;;;;;;;;;;
;; modeline ;;
;;;;;;;;;;;;;;

(use-package doom-modeline
    :ensure t
    :hook (after-init . doom-modeline-mode))

;; clean up modeline text
(defvar mode-line-cleaner-alist
  `((company-mode . " ⇝")
    (corfu-mode . " ⇝")
    (yas-minor-mode .  " ")
    (smartparens-mode . "()")
    (evil-smartparens-mode . "")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (evil-snipe-local-mode . "")
    (evil-owl-mode . "")
    (evil-rsi-mode . "")
    (evil-commentary-mode . "")
    (ivy-mode . "")
    (counsel-mode . "")
    (wrap-region-mode . "")
    (rainbow-mode . "")
    (which-key-mode . "")
    (undo-tree-mode . "")
    ;; (undo-tree-mode . " ⎌")
    (auto-revert-mode . "")
    ;; Major modes
    (lisp-interaction-mode . "λ")
    (hi-lock-mode . "")
    (python-mode . "py")
    (emacs-lisp-mode . "eλ")
    (nxhtml-mode . "nx")
    (dot-mode . "")
    (scheme-mode . "scm")
    (matlab-mode . "mat")
    (org-mode . "org")
    (eldoc-mode . "")
    (org-cdlatex-mode . "")
    (cdlatex-mode . "")
    (org-indent-mode . "")
    (org-roam-mode . "")
    (visual-line-mode . "")
    (latex-mode . "TeX")
    (tsx-ts-mode . "TypeScript")
    (outline-minor-mode . " ֍") ;; " [o]")
    (org-roam-ui-mode . "UI")
    ;; Evil modes
    (latex-extra-mode . "")
    (strokes-mode . "")
    (gcmh-mode . ""))
  "Alist for `clean-mode-line'.

  ; ;; When you add a new element to the alist, keep in mind that you
  ; ;; must pass the correct minor/major mode symbol and a string you
  ; ;; want to use in the modeline *in lieu of* the original.")

(defun clean-mode-line ()
  (cl-loop for cleaner in mode-line-cleaner-alist
           do (let* ((mode (car cleaner))
                     (mode-str (cdr cleaner))
                     (old-mode-str (cdr (assq mode minor-mode-alist))))
                (when old-mode-str
                  (setcar old-mode-str mode-str))
                ;; major mode
                (when (eq mode major-mode)
                  (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)

;; notifications
(use-package alert
  :ensure nil
  :custom
  (alert-default-style 'notifications))

;; display line numbers
(require 'display-line-numbers)
(global-display-line-numbers-mode 1)                        ; display line numbers
(setq display-line-numbers-width-start t)                   ; uses width necessary to display all line numbers
(defun display-line-numbers--turn-on ()                     ; do not display in pdf-mode or in minibuffer
  "Turn on `display-line-numbers-mode`."
   (unless (or (minibufferp) (eq major-mode 'pdf-view-mode))
    (display-line-numbers-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; navigation settings ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; scrolling
(setq scroll-conservatively 101)
(setq scroll-margin 8)
(setq scroll-preserve-screen-position t)

(defun my-scroll-half-page-down ()
  "Scroll down half a page."
  (interactive)
  (scroll-up-command (/ (window-body-height) 2)))

(defun my-scroll-half-page-up ()   
  "Scroll up half a page."
  (interactive)
  (scroll-down-command (/ (window-body-height) 2)))

(global-set-key (kbd "<prior>") #'my-scroll-half-page-up)
(global-set-key (kbd "<next>") #'my-scroll-half-page-down)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil))
      mouse-wheel-progressive-speed nil
      ring-bell-function 'ignore)

;; bind scroll-one-line  -  eventually have fast / medium /slow / 1-line scrolling speeds 
(global-set-key (kbd "C-n") 'scroll-up-line)
(global-set-key (kbd "C-p") 'scroll-down-line)

;; tab jump out
(use-package tab-jump-out
  :ensure t
  :config
  (tab-jump-out-global-mode t))

;; registers
(set-register ?a (cons 'file "~/.dotfiles/.config/"))
(set-register ?c (cons 'file "~/org/captures.org"))
(set-register ?d (cons 'file "~/org/dictionary"))
(set-register ?e (cons 'file "~/.dotfiles/.emacs.d/init.el"))
(set-register ?h (cons 'file "~/polterguix/files/hypr/hyprland-base.conf"))
(set-register ?s (cons 'file "~/org/schedule.org"))
(set-register ?S (cons 'file "~/projects/cherry-seoul256/cherry-seoul256-theme.el"))
(set-register ?t (cons 'file "~/org/tasks.org"))
(set-register ?z (cons 'file "~/.dotfiles/.zshrc"))
(set-register ?g (cons 'file (concat "~/.dotfiles/polterguix/systems/"
                                     (system-name)
                                     ".scm")))

;; use ibuffer 
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; switch to mini-buffer
(global-set-key (kbd "C-x m") 'switch-to-minibuffer)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; save place in files
(save-place-mode 1)

;; single space after period delimits sentence (for M-a / M-e)
(setq sentence-end-double-space nil)

;; avy
(use-package avy
  :ensure t
  :bind (("C-s" . avy-goto-char)
         ("M-g M-g" . avy-goto-line)))

;; popper
(use-package popper
  :ensure t
  :bind (("M-'"   . popper-cycle)
         ("C-M-'" . popper-toggle-type)) ; turns a popup buffer into a regular window or vice-versa.
  :init
  (popper-mode 1)
  (popper-echo-mode 1)
  :custom
  (popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode
          eat-mode)))

;;;;;;;;;;;;;;
;; org mode ;;
;;;;;;;;;;;;;;

(use-package org
  :ensure t
  :functions org-capture-finalize
  :bind
  (("C-c n C-i" . org-id-get-create)
   ("C-c a" . org-agenda)
   ("C-c o s" . org-save-all-org-buffers)
   ("C-M-] c" . org-capture)
   :map org-mode-map
   ("C-c \\" . puni-mark-sexp-around-point)
   ("C-c c" . my/org-capture-and-kill)
   )
  :hook
  (org-mode . org-indent-mode)
  ;; (org-mode . turn-on-org-cdlatex)
  (org-mode . my/org-syntax-table-modify)
  (org-mode . my/org-add-electric-pairs)
  (org-agenda-mode . (lambda () (setq-local nobreak-char-display nil)))
  (org-mode . (lambda () (setq-local nobreak-char-display nil)))
  :init
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.33)
                 (window-height . fit-window-to-buffer)))
  (display-line-numbers-mode 1)

  ;; kill the frame if one was created for the capture
  (defvar my/delete-frame-after-capture 0 "Whether to delete the last frame after the current capture")

  ;; delete pop-up capture frames after finalize/kill/refile. at popup, set `my/delete-frame-after-capture' to 1
  (defun my/delete-frame-if-necessary (&rest _r)
    (cond
     ((= my/delete-frame-after-capture 0) nil)
     ((> my/delete-frame-after-capture 1)
      (setq my/delete-frame-after-capture (- my/delete-frame-after-capture 1)))
     (t
      (setq my/delete-frame-after-capture 0)
      (delete-frame))))
  
  (advice-add 'org-capture-finalize :after 'my/delete-frame-if-necessary)
  (advice-add 'org-capture-kill :after 'my/delete-frame-if-necessary)
  (advice-add 'org-capture-refile :after 'my/delete-frame-if-necessary)
  
  :custom
  (org-directory "~/org")
  (org-indent-mode-turns-off-org-adapt-indentation nil)
  (org-startup-with-inline-images t)
  (org-startup-with-latex-preview t)
  (org-preview-latex-default-process 'dvipng)
  (org-agenda-files '("~/org/agenda/tasks.org" "~/org/agenda/projects.org" "~/org/agenda/schedule.org" "~/org/agenda/habits.org" "~/org/agenda/ticktick.org" "~/org/agenda/activities.org"))
  (org-agenda-format-date (lambda (date)
                            (require 'cal-iso)
                            (let* ((dayname (calendar-day-name date))
	                           (day (cadr date))
	                           (day-of-week (calendar-day-of-week date))
	                           (month (car date))
	                           (monthname (calendar-month-name month))
	                           (year (nth 2 date))
	                           (iso-week (org-days-to-iso-week
		                              (calendar-absolute-from-gregorian date)))
	                           ;; (weekyear (cond ((and (= month 1) (>= iso-week 52))
	                           ;;        	  (1- year))
	                           ;;        	 ((and (= month 12) (<= iso-week 1))
	                           ;;        	  (1+ year))
	                           ;;        	 (t year)))
	                           (weekstring (if (= day-of-week 1)
			                           (format " W%02d" iso-week)
		                                 "")))
                              (concat "\n"
                                      (make-string (- (window-width) 5) ?-)
                                      "\n"
                                      (format "%-10s %2d %s %4d%s"
	                                      dayname day monthname year weekstring)))))
  (org-super-agenda-groups
   '((:name "Tasks"
            :and (:todo ("TODO" "IN PROGRESS"))
            :order 0)
     (:name "Schedule" ; remove closed tasks in schedule.org; time of close is irrelevant
            :order 1
            :and (:time-grid t :not (:and (:category "schedule" :log closed))))
     (:discard (:anything))
             ;; After the last group, the agenda will display items that didn't
             ;; match any of these groups, with the default order position of 99
             ))
  (org-agenda-custom-commands 
      '(("d" "Daily view (grouped)" agenda ""
         ((org-agenda-span '1)
          (org-deadline-warning-days 0)
          (org-habit-show-habits t)
          (org-super-agenda-groups
           '((:name "Tasks"
                    :todo ("TODO" "IN PROGRESS")
                    :order 0)
             (:name "Habits (remaining)"
                    :and (:habit t :not(:scheduled future))
                    :order 2)
             (:name "Habits (complete)"
                    :habit t
                    :order 3)
             (:name "Schedule"
                    :order 1
                    :time-grid t)
             
         ;; After the last group, the agenda will display items that didn't
         ;; match any of these groups, with the default order position of 99
         ))))))
  (org-agenda-sorting-strategy '(time-up priority-down))
  (org-agenda-start-with-log-mode t)


  (org-clock-idle-time 10)
  (org-clock-persist t)  (org-ellipsis " ▾")
  (org-clock-persist 'history)

  (org-habit-show-all-today t) ; need this in order for completed habits to show up in org-agenda daily view
  (org-habit-show-habits t)
  (org-habit-graph-column 60)
  (org-habit-preceding-days 28)
  (org-habit-following-days 0)

  (org-todo-keywords '((sequence "TODO" "IN PROGRESS")
                       (sequence "TABLED" "TODO" "IN PROGRESS" "|" "DONE")
                       (sequence "ACTIVITY")
                       (sequence "ENTRY")
                       ))
  (org-todo-keyword-faces
        '(("IN PROGRESS" . (:foreground "#F1C40F" :distant-foreground "e6dfb8" :weight bold))
          ("UPCOMING" . (:foreground "#cddbf9" :weight bold))
          ("ENTRY" . (:foreground "#f6bbe7" :weight bold))
          ("ACTIVITY" . (:foreground "#F1C40F" :weight bold))
          ("TABLED" . (:foreground "#ffd700" :distant-foreground "#171717" :weight bold))))
  (org-log-done 'time)
  (electric-indent-mode 1)
  (org-log-into-drawer t)
  (org-id-link-to-org-use-id 'create-if-interactive)
  (org-startup-folded 'content)
  (org-capture-templates
        `(("p" "Protocol Text" entry
           (file+headline ,(concat org-directory "/captures.org") "Captures")
	   "* %^{Title}\nSource: [[%:link][%:description]] %(progn (setq my/delete-frame-after-capture 1) \"\") \nCaptured on: %U\n\n#+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n")
	  ("L" "Protocol Link" entry (file+headline ,(concat org-directory "/captures.org") "Captures")
 "* [[%:link][%:description]] %(progn (setq my/delete-frame-after-capture 1) \"\")\nCaptured on: %U"
 :empty-lines 1)
          ("s")
          ("t" "Task" entry
           (file ,(concat org-directory "/tasks.org"))
           "* TODO %?\nSCHEDULED: <%(org-read-date nil nil)>
:PROPERTIES:
:notify: nil
:END:
"
           :empty-lines-before 1
           :empty-lines-after 2)
        ("d" "Daily" entry
           (file+headline ,(concat org-directory "/daily-tracker.org") ,(format-time-string "%Y-%m" (current-time)))
           "* %<%Y-%m-%d>
:PROPERTIES:
:ad: 0
:xa: 0
:bu: 0
:END:"
           )))
  (org-confirm-babel-evaluate nil)
  (org-src-tab-acts-natively t)
  (org-babel-python-command "python3")
  
  :config
  (global-set-key (kbd "C-'") 'org-cycle-agenda-files)
  (plist-put org-format-latex-options :scale 1.5)
  (set-face-attribute 'org-ellipsis nil :underline nil)
  (org-clock-persistence-insinuate)
  (set-face-attribute 'org-column nil :background 'unspecified)
  (set-face-attribute 'org-column-title nil :background 'unspecified)
  (org-babel-do-load-languages
     'org-babel-load-languages
     '((lisp . t)
       (python . t)
       (js . t)
       (shell . t)))
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("py" . "src python :results output"))
    (add-to-list 'org-structure-template-alist '("jp" . "src jupyter-python :session py"))

  (defun suppress-org-element-warning (orig-fun &rest args)
    "Suppress ‘org-element-at-point’ warning in non-Org buffers."
    (let ((warning-minimum-level :error))
      (apply orig-fun args)))
  
  (advice-add 'org-element-at-point :around #'suppress-org-element-warning)

  (defun my/org-syntax-table-modify ()
    "Modify `org-mode-syntax-table' to treat < and > characters as punctuation."
    (modify-syntax-entry ?< "." org-mode-syntax-table)
    (modify-syntax-entry ?> "." org-mode-syntax-table))

  (defvar org-electric-pairs '((?$ . ?$)))  ; custom electric pairs for org-mode

  (defun my/org-add-electric-pairs ()
    (setq-local electric-pair-pairs (append electric-pair-pairs org-electric-pairs))
    (setq-local electric-pair-text-pairs electric-pair-pairs))

  (defun my/org-capture-and-kill ()
    "Finalize the current Org capture and then kill the buffer."
    (interactive)
    (org-capture-finalize)
    (delete-frame)))

(use-package org-roam
  :ensure t
  :after org
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n g" . org-roam-graph)
         ("C-c n t" . org-roam-tag-add)
	 ("C-c n I" . org-roam-node-insert-immediate)
	 :map org-mode-map
	 (("C-M-i" . completion-at-point)))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :custom
  (org-roam-v2-ack t)
  (org-roam-directory (file-truename "~/org/roam/"))
  (org-roam-completion-everywhere t)
  (org-roam-node-default-sort 'file-atime)
  (org-roam-node-display-template
   (concat "${title:*} "
           (propertize "${tags:20}" 'face 'org-tag)))
  (org-roam-mode-sections
   (list #'org-roam-backlinks-section
	 #'org-roam-reflinks-section))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* ENTRY %<%I:%M %p> \n:PROPERTIES:\n:MOOD: %?\n:END:"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+TODO: TODO IN PROGRESS DONE ACTIVITY ENTRY"))))
  :init
  (require 'org-roam-dailies)
  :config
  (require 'org-roam-protocol)
  (org-roam-db-autosync-mode)
  (defun org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
	  (org-roam-capture-templates (list (append (car org-roam-capture-templates)
						    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))

  (advice-add #'corfu-insert
              :after (lambda ()
                       (when
                           (eq major-mode 'org-mode)
                         (org-roam-link-replace-all)))))

(use-package org-roam-ui
  :ensure t
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start t))

(load "~/projects/org-roam-dailies-tasklog/org-roam-dailies-tasklog")

(use-package org-roam-dailies-tasklog
  :vc (:url "https://github.com/polhuang/org-roam-dailies-tasklog" :rev :newest)
  :after org-roam
  :config
  (org-roam-dailies-tasklog-mode 1))

(use-package org-super-agenda ;; if there's a problem with loading the package, it could be because of dash conflicts - needs to be installed internally, not externally
  :ensure t
  :after org-agenda
  :config
  (org-super-agenda-mode))

(defun my/org-search ()
  "Search through org files ."
  (interactive)
  (consult-ripgrep "~/org"))

;; org-notify
(use-package org-notify
    :ensure t
    :functions (org-notify-start org-notify-add)
    :custom
    (org-notify-timestamp-types '(:deadline :scheduled))
    :config
    (defun my/alarm-long (&rest _)
      "Wrapper function for alarm to fit :actions list below"
      (my/alarm "long"))

    (org-notify-add 'default
                    '(:time "0s" :duration 300
                            :actions (-notify)))
    (org-notify-add 'event
                    '(:time "5s" :duration 50 :urgency critical
                            :actions (my/alarm-long -notify))
                    '(:time "1m" :duration 55
                            :actions (my/alarm -notify))
                    '(:time "5m" :duration 60
                            :actions (-notify))
                    '(:time "15m" :duration 60
                            :actions -notify)
                    '(:time "30m" :duration 1200 :actions -notify))
    (org-notify-start))

;; add snooze functionality to org-notify
(use-package org-notify-snooze
  :if (file-exists-p "~/projects/org-notify-snooze/org-notify-snooze.el")
  :load-path "~/projects/org-notify-snooze")

;; org-pomodoro
(defun my/pomodoro-finished-alert ()
  (interactive)
  (my/alarm)
  (alert (format-time-string "%H:%M")
         :severity 'high
         :title "Pomodoro session finished!"
         :category 'org-pomodoro
         :style 'notifications
         :persistent t))

(defun my/pomodoro-break-finished-alert ()
  (interactive)
  (my/alarm)
  (alert (format-time-string "%H:%M")
         :severity 'high
         :title "Pomodoro break finished!"
         :category 'org-pomodoro
         :style 'notifications
         :persistent t))

(use-package org-pomodoro
  :ensure t
  :hook ((org-pomodoro-finished . (lambda () (my/pomodoro-finished-alert)))
         (org-pomodoro-break-finished . (lambda () (my/pomodoro-break-finished-alert))))
  :custom
  (org-pomodoro-keep-killed-pomodoro-time t)
  (org-pomodoro-format "%s")
  (org-clock-clocked-in-display nil)
  (setq org-pomodoro-ticking-sound t))

;; remind me to clock in/out
(use-package org-clock-reminder
  :ensure t
  :functions (org-clock-reminder-mode org-clock-reminder--icon notifications-notify)
  :custom
  (org-clock-reminder-mode 1)
  (org-clock-reminder-formatters
   '((?c . (org-duration-from-minutes (floor (org-time-convert-to-integer
		                              (time-since org-clock-start-time))
		                             60)))
     (?h . org-clock-heading)
     (?t . (format-time-string "%H:%M" (current-time)))))

  (org-clock-reminder-inactive-title "Big Brother says:")
  (org-clock-reminder-active-title "Big Brother says:")
  (org-clock-reminder-inactive-text "%t: You're not clocked in, bro")
  (org-clock-reminder-active-text "%t: You've been working for %c on %h.")
  (org-clock-reminder-interval (cons 10 5))
  (org-clock-reminder-inactive-notifications-p t)
  :config
  ;; replace function to configure urgency, timeout, icon
  (defun org-clock-reminder-notify (title message)
    (let ((icon-path (org-clock-reminder--icon)))
      (notifications-notify :title title
                            :body message
                            :transient
                            :app-icon icon-path
                            :timeout 30000))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hydra ----------------------------------------------------------------------- ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package hydra
  :demand t
  :ensure t)

(use-package pretty-hydra
  :demand t
  :ensure t)

;; hydra-colossa
(defhydra hydra-colossa (:color amaranth :hint nil)
  "
  _e_: eat
  _E_: erc
  _g_: gptel
  _k_: save and kill emacs
  _m_: mu4e
  _n_: new scratchpad
  _p_: pomodoro
  _q_: go away
  _s_: search org files
  _w_: windows + frames
"
  ("C" copilot-mode :color blue)
  ("e" eat :color blue)
  ("E" erc-switch-to-buffer :color blue)
  ("g" gptel-send :color blue)
  ("G" gptel-menu :color blue)
  ("k" save-buffers-kill-emacs :color blue)
  ("m" mu4e :color blue)
  ("n" scratchpad-new :color blue)
  ("p" org-pomodoro :color blue)
  ("q" nil :color blue)
  ("r" restart-emacs :color blue)
  ("s" my/org-search :color blue)
  ("w" hydra-windows/body :color blue)
  ("." nil :color blue)
  ("C-M-G" nil :color blue))

(global-set-key (kbd "C-M-G") 'hydra-colossa/body)

(defhydra hydra-windows (:color pink :hint nil)
  "
  _t_: transpose
  _s_: toggle vertical/horizontal split
  _q_: go away
"
  ("c" clone-frame :color blue)
  ("t" crux-transpose-windows :color blue)
  ("q" nil  :color blue)
  ("s" my/toggle-window-split :color blue)
  ("." nil :color blue))

(declare-function cherry-seoul256-brighten-background "cherry-seoul256")
(declare-function cherry-seoul256-darken-background "cherry-seoul256")

(pretty-hydra-define hydra-emacs-ui
  (:title "emacs ui" :quit-key "q")
  ("Visibility"
   (("+" cherry-seoul256-brighten-background "brighten background")
    ("-" cherry-seoul256-darken-background "darken background")
    ("<up>" my/increase-transparency "more transparency")
    ("<down>" my/decrease-transparency "less transparency"))

   "Font"
   (("f" my/cycle-font "cycle font")
    ("sf" my/select-font "select font"))

   "Theme"
   (("t" my/cycle-theme "cycle theme"))))

(global-set-key (kbd "C-M-] r") 'hydra-emacs-ui/body)

;; hydra for ibuffer
(require 'ibuffer)
(require 'ibuf-ext)

(defhydra hydra-ibuffer-main (:color pink :hint nil)
  "
 ^Navigation^ | ^Mark^        | ^Actions^        | ^View^
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
  _k_:    ʌ   | _m_: mark     | _D_: delete      | _g_: refresh
 _RET_: visit | _u_: unmark   | _S_: save        | _s_: sort
  _j_:    v   | _*_: specific | _a_: all actions | _/_: filter
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
"
  ("j" ibuffer-forward-line)
  ("RET" ibuffer-visit-buffer :color blue)
  ("k" ibuffer-backward-line)
  ("m" ibuffer-mark-forward)
  ("u" ibuffer-unmark-forward)
  ("*" hydra-ibuffer-mark/body :color blue)
  ("D" ibuffer-do-delete)
  ("S" ibuffer-do-save)
  ("a" hydra-ibuffer-action/body :color blue)
  ("g" ibuffer-update)
  ("s" hydra-ibuffer-sort/body :color blue)
  ("/" hydra-ibuffer-filter/body :color blue)
  ("o" ibuffer-visit-buffer-other-window "d" :color blue)
  ("q" quit-window "s" :color blue)
  ("." nil "s" :color blue))

(defhydra hydra-ibuffer-mark (:color teal :columns 5
			             :after-exit (hydra-ibuffer-main/body))
  "Mark"
  ("*" ibuffer-unmark-all "unmark all")
  ("M" ibuffer-mark-by-mode "mode")
  ("m" ibuffer-mark-modified-buffers "modified")
  ("u" ibuffer-mark-unsaved-buffers "unsaved")
  ("s" ibuffer-mark-special-buffers "special")
  ("r" ibuffer-mark-read-only-buffers "read-only")
  ("/" ibuffer-mark-dired-buffers "dired")
  ("e" ibuffer-mark-dissociated-buffers "dissociated")
  ("h" ibuffer-mark-help-buffers "help")
  ("z" ibuffer-mark-compressed-file-buffers "compressed")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-action (:color teal :columns 4
				       :after-exit
				       (if (eq major-mode 'ibuffer-mode)
				           (hydra-ibuffer-main/body)))
  "Action"
  ("A" ibuffer-do-view "view")
  ("E" ibuffer-do-eval "eval")
  ("F" ibuffer-do-shell-command-file "shell-command-file")
  ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
  ("H" ibuffer-do-view-other-frame "view-other-frame")
  ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
  ("M" ibuffer-do-toggle-modified "toggle-modified")
  ("O" ibuffer-do-occur "occur")
  ("P" ibuffer-do-print "print")
  ("Q" ibuffer-do-query-replace "query-replace")
  ("R" ibuffer-do-rename-uniquely "rename-uniquely")
  ("T" ibuffer-do-toggle-read-only "toggle-read-only")
  ("U" ibuffer-do-replace-regexp "replace-regexp")
  ("V" ibuffer-do-revert "revert")
  ("W" ibuffer-do-view-and-eval "view-and-eval")
  ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
  ("b" nil "back"))

(defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
  "Sort"
  ("i" ibuffer-invert-sorting "invert")
  ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
  ("v" ibuffer-do-sort-by-recency "recently used")
  ("s" ibuffer-do-sort-by-size "size")
  ("f" ibuffer-do-sort-by-filename/process "filename")
  ("m" ibuffer-do-sort-by-major-mode "mode")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
  "Filter"
  ("m" ibuffer-filter-by-used-mode "mode")
  ("M" ibuffer-filter-by-derived-mode "derived mode")
  ("n" ibuffer-filter-by-name "name")
  ("c" ibuffer-filter-by-content "content")
  ("e" ibuffer-filter-by-predicate "predicate")
  ("f" ibuffer-filter-by-filename "filename")
  (">" ibuffer-filter-by-size-gt "size")
  ("<" ibuffer-filter-by-size-lt "size")
  ("/" ibuffer-filter-disable "disable")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(with-eval-after-load 'ibuffer
  (define-key ibuffer-mode-map "." 'hydra-ibuffer-main/body))

;; hydra for dired
(require 'dired)
(require 'dired-x)
(require 'dired-aux)
(defhydra dired-hydra (:hint nil)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _w_ kill-subdir    C-x C-q: edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _?_ summary        C-c C-c: commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     ^ ^                C-c C-k: abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             
_S_ymlink          _A_ find regexp  _F_ind marked      _._ toggle hydra
_z_ compress       _Q_ repl regexp
^ ^

T - tag prefix
"
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("?" dired-summary)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(define-key dired-mode-map "." 'dired-hydra/body)

(with-eval-after-load 'dired
  (define-key dired-mode-map "." 'dired-hydra/body))

;; major-mode hydra
(use-package major-mode-hydra
  :ensure t
  :after (org mu4e)
  :bind
  ("C-M-] ." . major-mode-hydra)
  :config
  (major-mode-hydra-define org-mode nil
    ("TODO"
     (("t" my/to-do-complete "Cycle TODO")
      ("d" org-deadline "Deadline")
      ("s" org-schedule "Schedule")
      ("i" org-clock-in "Clock in")
      ("o" org-clock-out "Clock out")
      ("a" org-archive-subtree-default "Archive")
      ("x" org-cut-special "Cut/Delete"))
     "Org"
     (("h" consult-org-heading "Headings")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; logs, debugging, and history ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; minibuffer prompt history
(setq history-length 25)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; buffers / windows / frames  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; kill this frame
(defun my/kill-this-window ()
  (interactive)
  (unless (string= (buffer-name) "*scratch*")
    (if (> (count-windows) 1)
        (kill-buffer-and-window)
      (kill-this-buffer))))

(global-set-key (kbd "C-M-] k") 'my/kill-this-window)
(global-set-key (kbd "C-M-] <delete>") 'kill-current-buffer)

;; disable recursive minibuffers
(setq enable-recursive-minibuffers nil)

;; revert buffers after external file changes
(global-auto-revert-mode t)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)
(customize-set-variable 'global-auto-revert-ignore-modes
			'(Buffer-menu-mode)) ;; buffer menu loses state (cursor, marks) when reverting

;; winner mode (allows you to undo and redo window actions)
(winner-mode 1) ;; C-c left to undo; C-c right to redo

;; ace-window
(use-package ace-window
  :ensure t
  :bind (("M-o" . ace-window))
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f)))

;; toggle vertical/horizontal split
(defun my/toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

;;;;;;;;;;;;;;;;
;; minibuffer ;;
;;;;;;;;;;;;;;;;

(use-package minibuffer
  :hook (minibuffer-setup . cursor-intangible-mode)
  :custom
  (read-minibuffer-restore-windows t) ; restore window configurations on exit from minibuffer
  (read-answer-short t) ; accept single character answers
  (resize-mini-windows 'grow-only)
  :config
  (defun my/focus-minibuffer ()
    "Focus the active minibuffer."
    (interactive)
    (let ((minibuffer (active-minibuffer-window)))
      (when minibuffer
        (select-window minibuffer))))

  ;; prevent cursor from getting stuck in read-only prompt section of minibuffer
  (setq minibuffer-prompt-properties
      '(read-only t intangible t cursor-intangible t face minibuffer-prompt)))

;;;;;;;;;;;;;;;;;;;;
;; authentication ;;
;;;;;;;;;;;;;;;;;;;;

(setq auth-sources '("~/.authinfo"))

;; gpg
(let ((gpg-file (expand-file-name "private/gpg.el" user-emacs-directory)))
  (unless (file-exists-p gpg-file)
    (make-directory (file-name-directory gpg-file) t)
    (write-region "" nil gpg-file))
  (load gpg-file))

(use-package pinentry :ensure t)

(use-package epa
  :ensure nil
  :custom
  (epa-pinentry-mode 'loopback)
  (epa-file-cache-passphrase-for-symmetric-encryption t)
  :config
  (pinentry-start))

;; plist store
(require 'plstore)
(setq plstore-cache-passphrase-for-symmetric-encryption t)

;; tramp
(use-package tramp
  :ensure nil
  :custom
  (tramp-default-method "ssh"))

;;;;;;;;;;;;;
;; editing ;;
;;;;;;;;;;;;;

;; typing replaces selected field
(delete-selection-mode 1)

;; intellij-style backspace
(use-package smart-backspace
  :ensure t
  :bind ("M-<backspace>" . smart-backspace))

;; undo tree
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode)
  :custom
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (undo-tree-auto-save-history t)
  (undo-tree-visualizer-timestamps t)
  (undo-tree-visualizer-diff t))

;; move-text (use M-up / M-down to move lines up and down)
(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings))

;; electric pair
(electric-pair-mode 1)

(use-package puni
  :defer t
  :ensure t
  :bind (("C-c \\" . puni-mark-sexp-around-point)
         ("C-," . puni-expand-region))
  :hook (term-mode . puni-disable-puni-mode)
  :init (puni-global-mode)
  :config
  (define-key puni-mode-map (kbd "M-DEL") 'nil)
  (define-key puni-mode-map (kbd "C-M-a") 'nil)
  (define-key puni-mode-map (kbd "C-M-e") 'nil)
  (define-key puni-mode-map (kbd "C-c C-M-a") 'puni-beginning-of-sexp)
  (define-key puni-mode-map (kbd "C-c C-M-e") 'puni-end-of-sexp)
  (define-key puni-mode-map (kbd "C-c <delete>") 'puni-force-delete))

;;;;;;;;;;;;;;;;;;;;;;;
;; completion system ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; orderless
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vertico --------------------------------------------------------------------- ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  ;; add prompt indicator to `completing-read-multiple'.
  ;; display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
		  (replace-regexp-in-string
		   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		   crm-separator)
		  (car args))
	  (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; hide commands in m-x which do not work in the current mode
  ;; vertico commands are hidden in normal buffers.
  (setq read-extended-command-predicate
        #'command-completion-default-include-p)

  (setq completion-cycle-threshold 3)
  :custom
  (vertico-cycle t)
  (completion-in-region-function
        (lambda (&rest args)
	  (apply (if vertico-mode
		     #'consult-completion-in-region
		   #'completion--in-region)
	         args))))

;; marginalia
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; consult --------------------------------------------------------------------- ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package consult
  :ensure t
  :bind ((;; C-c bindings in `mode-specific-map'
	 ("C-c M-x" . consult-mode-command)
         ("C-x C-r" . consult-recent-file)
	 ("C-c h" . consult-history)
	 ("C-c m" . consult-man)
	 ("C-c i" . consult-info)
	 ([remap Info-search] . consult-info)
	 ;; C-x bindings in `ctl-x-map'
	 ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
	 ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
	 ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
	 ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
	 ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
	 ;; Custom M-# bindings for fast register
	 ("C-x r j" . consult-register-load)
	 ("C-x r s" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
	 ("C-M-#" . consult-register)
	 ;; Other custom bindings
	 ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("C-M-Y" . consult-org-agenda)
	 ;; M-g bindings in `goto-map'
	 ("M-g e" . consult-compile-error)
	 ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
	 ("M-g g" . consult-goto-line)             ;; orig. goto-line
	 ;; ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
	 ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
	 ("M-g m" . consult-mark)
	 ("M-g k" . consult-global-mark)
	 ("M-g i" . consult-imenu)
	 ("M-g I" . consult-imenu-multi)
	 ;; M-s bindings in `search-map'
	 ("M-s d" . consult-find)
	 ("M-s D" . consult-locate)
	 ("M-s g" . consult-grep)
	 ("M-s G" . consult-git-grep)
	 ("M-s r" . consult-ripgrep)
	 ("M-s l" . consult-line)
	 ("M-s L" . consult-line-multi)
	 ("M-s k" . consult-keep-lines)
	 ("M-s u" . consult-focus-lines)
	 ;; isearch integration - commented out because of ctrlf
	 ;; ("M-s e" . consult-isearch-history)
	 ;; :map isearch-mode-map
	 ;; ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
	 ;; ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
	 ;; ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
	 ;; ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
	 ;; minibuffer history
	 :map minibuffer-local-map
	 ("M-s" . consult-history)                 ;; orig. next-matching-history-element
	 ("M-r" . consult-history)))                ;; orig. previous-matching-history-element

  ;; enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; the :init configuration is always executed (Not lazy)
  :init

  ;; register preview delay and formatting
  (setq register-preview-delay 0.1
	register-preview-function #'consult-register-format)

  ;; adds thin lines + sorting, also hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; uses consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref)

  :custom
  (consult-buffer-sources '(consult--source-buffer
                            consult--source-recent-file
                            consult--source-file-register
                            consult--source-bookmark
                            consult--source-project-buffer-hidden
                            consult--source-project-recent-file-hidden
                            consult--source-project-root-hidden))
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.1 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."sq
   :preview-key '(:debounce 0.1 any))

  ;; configure narrowing key
  ;; both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; use projectile
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-function (lambda (_) (projectile-project-root))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; corfu ----------------------------------------------------------------------- ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package corfu 
  :ensure t
  :bind (:map corfu-map 
              ("M-TAB" . corfu-insert)
              ("C-g" . corfu-quit))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
  (corfu-history-mode 1)
  :custom
  (corfu-auto t)                    ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match 'separator)  ;; Never quit, even if there is no match
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))
  
  ;; recommended: enable Corfu globally.  recommended since dabbrev can
  ;; be used globally (M-/). see also the customization variable
  ;; `global-corfu-modes' to exclude certain modes
  :config
  (keymap-unset corfu-map "RET")          ;; prevent corfu from stealing RET or TAB
  (keymap-unset corfu-map "TAB")          ;; TAB too
  )

;; emacs configurations
(use-package emacs
  :init
  (setq read-extended-command-predicate
        #'command-completion-default-include-p))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cape------------------------------------------------------------------------- ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package cape
  :ensure t
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c P p" . completion-at-point) ;; capf
	 ("C-c P t" . complete-tag)        ;; etags
	 ("C-c P d" . cape-dabbrev)        ;; or dabbrev-completion
	 ("C-c P h" . cape-history)
	 ("C-c P f" . cape-file)
	 ("C-c P k" . cape-keyword)
	 ("C-c P s" . cape-elisp-symbol)
	 ("C-c P e" . cape-elisp-block)
	 ("C-c P a" . cape-abbrev)
	 ("C-c P l" . cape-line)
	 ("C-c P w" . cape-dict)
	 ("C-c P :" . cape-emoji)
	 ("C-c P \\" . cape-tex)
	 ("C-c P _" . cape-tex)
	 ("C-c P ^" . cape-tex)
	 ("C-c P &" . cape-sgml)
	 ("C-c P r" . cape-rfc1345))
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)`

  (add-hook 'emacs-lisp-mode-hook (lambda ()
                                    (add-to-list (make-local-variable 'completion-at-point-functions) 'cape-elisp-block)
                                    (add-to-list (make-local-variable 'completion-at-point-functions) 'cape-elisp-symbol))))

;; prescient
(use-package prescient
  :ensure t
  :functions (prescient-persist-mode)
  :config
  (prescient-persist-mode 1))

(use-package corfu-prescient
  :after (corfu prescient)
  :ensure t
  :config
  (corfu-prescient-mode 1))

(use-package vertico-prescient
  :after (vertico prescient)
  :ensure t
  :config
  (vertico-prescient-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; embark----------------------------------------------------------------------- ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
	       '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
		 nil
		 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;;;;;;;;;;;;;;;;;
;; key bindings ;;
;;;;;;;;;;;;;;;;;;

;; remap search to C-f
(global-set-key (kbd "C-f") 'consult-line)

;; crux keybinds (move to topic sections later)
(use-package crux
  :ensure t
  :bind (("C-a" . crux-move-beginning-of-line)
	 ("C-c r" . crux-recentf-find-file)
	 ("C-c D" . crux-duplicate-current-line-or-region)
	 ("C-c K" . crux-kill-other-buffers)
	 ("C-k" . crux-smart-kill-line)
	 ("C-S-k" . crux-kill-line-backwards)
	 ("C-<delete>" . crux-kill-whole-line)
	 ("C-S-<return>" . crux-smart-open-line-above)
	 ("C-<return>" . crux-smart-open-line)))

;; tempel
(use-package tempel
  :init

  ;; setup completion at point
  (defun tempel-setup-capf ()
    (setq-local corfu-auto-trigger "@"
                completion-at-point-functions
                (cons (cape-capf-trigger #'tempel-complete ?@)
                      completion-at-point-functions)))

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  :custom
  (tempel-path "/home/pol/.emacs.d/templates"))


;;;;;;;;;;;;;;;
;; utilities ;;
;;;;;;;;;;;;;;;

;; repeat mode
(use-package repeat
  :config
  (repeat-mode 1)
  (setq repeat-on-final-keystroke t)
  (setq set-mark-command-repeat-pop t))

(defun repeatize (keymap)
  "Add `repeat-mode' support to a KEYMAP."
  (map-keymap
   (lambda (_key cmd)
     (when (symbolp cmd)
       (put cmd 'repeat-map keymap)))
   (symbol-value keymap)))

(defvar structural-navigation-map
  (let ((map (make-sparse-keymap)))
    (pcase-dolist (`(,k . ,f)
                   '(("u" . backward-up-list)
                     ("f" . puni-forward-sexp)
                     ("b" . puni-backward-sexp)
                     ("d" . down-list)
                     ("k" . kill-sexp)
                     ("<backspace>" . backward-kill-sexp)
                     ("]" . puni-slurp-forward)
                     ("[" . puni-slurp-backward)
                     ("}" . puni-barf-forward)
                     ("{" . puni-barf-backward)
                     ("," . puni-expand-region)))
      (define-key map (kbd k) f))
    map))

(map-keymap
 (lambda (_ cmd)
   (put cmd 'repeat-map 'structural-navigation-map)) structural-navigation-map)

(defvar org-navigation-map
  (let ((map (make-sparse-keymap)))
    (pcase-dolist (`(,k . ,f)
                   '(("n" . org-next-visible-heading)
                     ("p" . org-previous-visible-heading)
                     ("f" . org-forward-heading-same-level)
                     ("b" . org-backward-heading-same-level)))
      (define-key map (kbd k) f))
    map))

(map-keymap
 (lambda (_ cmd)
   (put cmd 'repeat-map 'org-navigation-map)) org-navigation-map)

;; persistent scratch
;; (use-package persistent-scratch
;;   :ensure t
;;   :config
;;   (persistent-scratch-setup-default))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (when (equal (buffer-name) "*scratch*")
              (revert-buffer))))

;; which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode t)
  :custom
  (which-key-max-description-length 40))

;; restart-emacs
(use-package restart-emacs
  :ensure t)

;;;;;;;;;;;;;;
;; terminal ;;
;;;;;;;;;;;;;;

(defun my/toggle-eat ()
  "If eat is current buffer, use popper-toggle to dismiss.
Otherwise, call eat."
  (interactive)
  (if (string= (buffer-name) "*eat*")
      (popper-toggle)
    (eat)))

;; eat
(use-package eat
  :ensure t
  :bind (("C-M-<delete>" . my/toggle-eat)
         ("C-c e p" . eat-project))
  :custom 
  (eat-kill-buffer-on-exit t)
  (eat-term-name "xterm-256color"))

;;;;;;;;;;;;
;; coding ;;
;;;;;;;;;;;;

;; spaces over tabs
(setq-default indent-tabs-mode nil)

;; indent
(setq standard-indent 2)

;; ;; indent bars
;; (use-package indent-bars
;;   :ensure t
;;   :config
;;   (require 'indent-bars-ts)
;;   :custom
;;   ;; (indent-bars-no-descend-lists nil) ; no extra bars in continued func arg lists
;;   ;; (indent-bars-no-descend-string nil)

  
  
  
;;   :hook
;;   ((python-base-mode yaml-mode typescripts-) . indent-bars-mode))

(use-package indent-bars
  :config
  (require 'indent-bars-ts)
  :custom
  (indent-bars-no-descend-lists nil)
  (indent-bars-no-descend-string nil)
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  (indent-bars-treesit-wrap '((c argument_list parameter_list init_declarator))) 
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
	                               if_statement with_statement while_statement)))
  (indent-bars-treesit-wrap '((rust arguments parameters)))
  (indent-bars-treesit-scope '((rust trait_item impl_item 
                                     macro_definition macro_invocation 
                                     struct_item enum_item mod_item 
                                     const_item let_declaration 
                                     function_item for_expression 
                                     if_expression loop_expression 
                                     while_expression match_expression 
                                     match_arm call_expression 
                                     token_tree token_tree_pattern 
                                     token_repetition)))
    (indent-bars-pattern " . .")
    (indent-bars-width-frac 0.2)
    (indent-bars-pad-frac 0.1)
    (indent-bars-zigzag nil)
    (indent-bars-color-by-depth  '(:regexp "org-level-\\([1-8]+\\)" :blend 1))
    (indent-bars-highlight-current-depth '(:width 0.3 :pattern ".")) ; pump up the BG blend on current
    (indent-bars-display-on-blank-lines t)
    :hook ((python-base-mode yaml-mode typescript-ts-base-mode) . indent-bars-mode))


;; projectile
(use-package projectile
  :ensure t
  :bind-keymap ("C-x p" . projectile-command-map)
  :custom
  (projectile-indexing-method 'alien)
  (projectile-project-search-path '("~/projects/"))
  (projectile-sort-order 'recently-active)
  (projectile-run-use-comint-mode t) ;; this allows input in interactive run mode
  :config
  (define-key projectile-command-map (kbd "e") #'eat-project)
  (define-key projectile-command-map (kbd "b") #'consult-project-buffer)
  (projectile-mode 1))

;; lsp
(use-package lsp-mode
  :ensure t
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-completion-provider :none)
  (lsp-enable-snippet nil)
  (lsp-enable-symbol-highlighting 1)
  :init
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
	  '(orderless))) ;; Configure orderless
  :hook ((lsp-completion-mode . my/lsp-mode-setup-completion)
	 (typescript-ts-mode . lsp-deferred)
         (js-ts-mode . lsp-deferred)
         (c-ts-mode . lsp-deferred)
         (rust-ts-mode . lsp-deferred)
         (tsx-ts-mode . lsp-deferred)
         (css-ts-mode . lsp-deferred)
	 ;; (python-ts-mode . lsp-deferred)
	 (lua-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration)
         (lsp-mode . lsp-semantic-tokens-mode)))

(use-package lsp-ui
  :ensure t
  :hook
  (lsp-mode . lsp-ui-mode))

(use-package lsp-tailwindcss
  :ensure t
  :after lsp-mode
  :custom
  (lsp-tailwindcss-add-on-mode t)
  (lsp-tailwindcss-major-modes '(typescript-ts-mode js-ts-mode tsx-ts-mode typescript-ts-mode web-mode)))

;; flycheck
(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode))

;; (setq major-mode-remap-alist
;;       '((yaml-mode . yaml-ts-mode)
;;         (bash-mode . bash-ts-mode)
;;         (c-mode . c-ts-mode)
;;         (javascript-mode . tsx-ts-mode)
;;         (js-mode . tsx-ts-mode)
;;         (js2-mode . tsx-ts-mode)
;;         (js-jsx-mode . tsx-ts-mode)
;;         (rjsx-mode . tsx-ts-mode)
;;         ;; (rust-mode . rust-ts-mode)
;;         (typescript-mode . tsx-ts-mode)
;;         (json-mode . json-ts-mode)
;;         (shell-mode . bash-ts-mode)
;;         (css-mode . css-ts-mode)
;;         (python-mode . python-ts-mode)))


;; treesit-auto
(use-package treesit-auto
  :functions global-treesit-auto-mode
  :ensure t
  :custom
  (treesit-auto-add-to-auto-mode-alist 'all)
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

;; combobulate
(use-package combobulate
  :straight (combobulate :type git :host github :repo "mickeynp/combobulate" :nonrecursive t)
  :hook
  ((python-ts-mode . combobulate-mode)
   (js-ts-mode . combobulate-mode)
   (html-ts-mode . combobulate-mode)
   (css-ts-mode . combobulate-mode)
   (yaml-ts-mode . combobulate-mode)
   (typescript-ts-mode . combobulate-mode)
   (json-ts-mode . combobulate-mode)
   (tsx-ts-mode . combobulate-mode)))

;; emmet
(use-package emmet-mode
  :ensure t
  :bind (("C-j" . emmet-expand-line))
  :init
  (setq emmet-mode-keymap nil)
  :hook
  (css-ts-mode . emmet-mode)
  (html-mode . emmet-mode)
  (js-ts-mode . emmet-mode)
  (typescript-ts-mode . emmet-mode)
  (tsx-ts-mode . emmet-mode)
  :custom
  (emmet-indentation 0)
  (emmet-indent-after-insert nil))

;; cargo
(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

;; nix
(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")

;;;;;;;;;;;
;; latex ;;
;;;;;;;;;;;

(use-package tex
  :ensure auctex)

(use-package cdlatex
  :ensure t)

;; enables inline latex previews
(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

;;;;;;;;;;;
;; tools ;;
;;;;;;;;;;;

;; magit
(use-package magit
  :ensure t)

;; venv support
(use-package virtualenvwrapper
  :ensure t
  :config
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell)
  (setq venv-location "~/.venv/")

  ;; make this into a function?
  ;; (venv-with-virtualenv "org-babel" (org-babel-do-load-languages 
  ;;                                    'org-babel-load-languages
  ;;                                    ' ((jupyter . t))))
  )

;; jupyter
(use-package jupyter
  :ensure t
  :defer t)

;; slime (the superior lisp interaction mode for emacs)
;; installation instructions here 
;; (use-package slime
;;   :init
;;   (load (expand-file-name "~/.quicklisp/slime-helper.el"))
;;   :custom
;;   (setq inferior-lisp-program "sbcl"))

;; csv
(use-package csv-mode
  :ensure t)

;;;;;;;;;;;
;; email ;;
;;;;;;;;;;;

;; mu4e
(use-package  mu4e
  :ensure nil
  :load-path "/opt/homebrew/share/emacs/site-lisp/mu/mu4e/"
  :custom
  (mu4e-use-fancy-chars t)
  (mu4e-bookmarks
   '((:name "Unread messages"
            :query "flag:unread AND NOT flag:trashed AND NOT \"maildir:/Gmail/[Gmail]/All Mail\" AND NOT \"maildir:/Protonmail/All Mail\" AND NOT maildir:/Gmail/[Gmail]/Spam AND NOT maildir:/Gmail/[Gmail]/Trash"
            :key ?u)
     (:name "Today's messages"
            :query "date:today..now AND NOT \"maildir:/Gmail/[Gmail]/All Mail\" AND NOT \"maildir:/Protonmail/All Mail\" AND NOT maildir:/Gmail/[Gmail]/Spam AND NOT maildir:/Gmail/[Gmail]/Trash"
            :key ?t)
     (:name "Last 7 days"
            :query "date:7d..now AND NOT \"maildir:/Gmail/[Gmail]/All Mail\" AND NOT \"maildir:/Protonmail/All Mail\" AND NOT maildir:/Gmail/[Gmail]/Spam AND NOT maildir:/Gmail/[Gmail]/Trash"
            :hide-unread t
            :key ?w)
     (:name "Messages with images"
            :query "mime:image/* AND NOT \"maildir:/Gmail/[Gmail]/All Mail\" AND NOT \"maildir:/Protonmail/All Mail\" AND NOT maildir:/Gmail/[Gmail]/Spam AND NOT maildir:/Gmail/[Gmail]/Trash"
            :key ?p)))
  (mail-user-agent 'mu4e-user-agent)
  (mu4e-user-mail-address-list
      '("paulleehuang@proton.me"
        "paulleehuang@protonmail.com"
        "plh135464@protonmail.com"))
  (mu4e-update-interval (* 5 60))
  (mu4e-mu-version "1.12.13")
  (message-send-mail-function 'smtpmail-send-it)
  (smtpmail-smtp-server "127.0.0.1")
  (smtpmail-smtp-service 1025)
  (mu4e-get-mail-command "mbsync -a")
  (message-kill-buffer-on-exit t)
  (mu4e-context-policy 'pick-first)
  :config
  (set-face-attribute 'mu4e-highlight-face nil :inherit 'mu4e-title-face)

  ;; Fancy header marks
  (setq mu4e-headers-draft-mark     '("D" . "💈")
        mu4e-headers-flagged-mark   '("F" . "📍")
        mu4e-headers-new-mark       '("N" . "🔥")
        mu4e-headers-passed-mark    '("P" . "❯")
        mu4e-headers-replied-mark   '("R" . "❮")
        mu4e-headers-seen-mark      '("S" . "☑")
        mu4e-headers-trashed-mark   '("d" . "💀")
        mu4e-headers-attach-mark    '("a" . "📎")
        mu4e-headers-encrypted-mark '("x" . "🔒")
        mu4e-headers-signed-mark    '("s" . "🔑")
        mu4e-headers-unread-mark    '("u" . "⎕")
        mu4e-headers-list-mark      '("l" . "🔈")
        mu4e-headers-personal-mark  '("p" . "👨")
        mu4e-headers-calendar-mark  '("c" . "📅"))

  (setq mu4e-contexts
      `(,(make-mu4e-context
          :name "protonmail"
          :enter-func (lambda () (mu4e-message "Switch to Protonmail context"))
          ;; Match based on maildir instead of email address
          :match-func (lambda (msg)
                        (when msg
                          (string-prefix-p "/Protonmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "paulleehuang@protonmail.com")
                  (user-full-name    . "Paul Huang")
                  (mu4e-sent-folder  . "/Protonmail/Sent")
                  (mu4e-drafts-folder . "/Protonmail/Drafts")
                  (mu4e-trash-folder  . "/Protonmail/Trash")
                  (mu4e-refile-folder . "/Protonmail/All Mail")
                  (smtpmail-smtp-server . "127.0.0.1")
                  (smtpmail-smtp-service . 1025)
                  (smtpmail-stream-type . starttls)
                  (smtpmail-smtp-user . "paulleehuang@protonmail.com")
                  (mu4e-maildir-shortcuts . ((:maildir "/Protonmail/inbox" :key ?i :name "Proton - Inbox")
                                             (:maildir "/Protonmail/Sent" :key ?s :name "Sent")
                                             (:maildir "/Protonmail/Trash" :key ?t :name "Trash")
                                             (:maildir "/Protonmail/All Mail" :key ?a :name "All Mail")))))
        
        ,(make-mu4e-context
          :name "gmail"
          :enter-func (lambda () (mu4e-message "Switch to Gmail context"))
          :match-func (lambda (msg)
                        (when msg
                          (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "paulleehuang@gmail.com")
                  (user-full-name    . "Paul Huang")
                  (mu4e-sent-folder  . "/Gmail/[Gmail]/Sent Mail")
                  (mu4e-drafts-folder . "/Gmail/[Gmail]/Drafts")
                  (mu4e-trash-folder  . "/Gmail/[Gmail]/Trash")
                  (mu4e-refile-folder . "/Gmail/[Gmail]/All Mail")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-service . 587)
                  (smtpmail-stream-type . starttls)
                  (smtpmail-smtp-user . "paulleehuang@gmail.com")
                  (mu4e-maildir-shortcuts . ((:maildir "/Gmail/INBOX" :key ?i :name "Gmail - Inbox")
                                             (:maildir "/Gmail/[Gmail]/Sent Mail" :key ?s :name "Sent")
                                             (:maildir "/Gmail/[Gmail]/Drafts" :key ?d :name "Drafts")
                                             (:maildir "/Gmail/[Gmail]/All Mail" :key ?a :name "All Mail")
                                             (:maildir "/Gmail/[Gmail]/Trash" :key ?t :name "Trash")))))
        
        ,(make-mu4e-context
          :name "work"
          :enter-func (lambda () (mu4e-message "Switch to Work context"))
          :match-func (lambda (msg)
                        (when msg
                          (string-prefix-p "/Work" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "paul.huang@vercel.com")
                  (user-full-name    . "Paul Huang")
                  (mu4e-sent-folder  . "/Work/[Gmail]/Sent Mail")
                  (mu4e-drafts-folder . "/Work/[Gmail]/Drafts")
                  (mu4e-trash-folder  . "/Work/[Gmail]/Trash")
                  (mu4e-refile-folder . "/Work/[Gmail]/All Mail")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-service . 587)
                  (smtpmail-stream-type . starttls)
                  (smtpmail-smtp-user . "paul.huang@vercel.com")
                  (mu4e-maildir-shortcuts . ((:maildir "/Work/INBOX" :key ?i :name "Work - Inbox")
                                             (:maildir "/Work/[Gmail]/Sent Mail" :key ?s :name "Sent")
                                             (:maildir "/Work/[Gmail]/Drafts" :key ?d :name "Drafts")
                                             (:maildir "/Work/[Gmail]/All Mail" :key ?a :name "All Mail")
                                             (:maildir "/Work/[Gmail]/Trash" :key ?t :name "Trash")))))

        ))
  )

(use-package org-msg
  :ensure t
  :after mu4e
  :config
  (setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t"
        org-msg-startup "hidestars indent inlineimages"
        org-msg-greeting-fmt "\nHi%s,\n\n"
        org-msg-recipient-names '(("paulleehuang@gmail.com" . "Paul Huang"))
        org-msg-greeting-name-limit 3
        org-msg-default-alternatives '((new           . (text html))
                                       (reply-to-html . (text html))
                                       (reply-to-text . (text)))
        org-msg-convert-citation t
        ;; Your signature
        org-msg-signature "

#+begin_signature
--
*Paul Huang*

[[https://github.com/polhuang][Github]] | [[https://linkedin.com/in/paulleehuang][LinkedIn]]
#+end_signature")
  
  (org-msg-mode))

;; org-mime
(use-package org-mime
  :ensure t
  :custom
  (org-mime-export-options '(:section-numbers nil
				              :with-author nil
				              :with-toc nil
				              :preserve-breaks t)))

;;;;;;;;;;;;;;;;;;;
;; miscellaneous ;;
;;;;;;;;;;;;;;;;;;;

;; pdf-tools
(use-package pdf-tools
  :ensure t
  :hook (pdf-view-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  (setq auto-mode-alist
        (append '(("\\.pdf\\'" . pdf-view-mode))
                auto-mode-alist)))

;; perspective (commented out as it breaks erc)
;; (use-package persp-mode
;;   :ensure t
;;   :custom
;;   (persp-save-dir (expand-file-name "perspectives/" user-emacs-directory))
;;   :config
;;   (persp-mode))

;; nyan-mode
(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode 1))

;; zone-mode
(use-package zone
  :ensure nil
  :functions zone-when-idle
  :config
  (zone-when-idle 300))

;; dashboard
(use-package dashboard
  :ensure t
  :custom
  (dashboard-banner-logo-title "~~ HI POL ~~")
  (dashboard-startup-banner "~/.dotfiles/.emacs.d/dashboard-banner.txt")
  (dashboard-footer-messages '("Time saved by emacs: 5 days 11 hours 47 minutes \nTime spent editing emacs config: 615 days 11 hours 38 minutes"))
  (dashboard-agenda-prefix-format "%-15:c %-16s")
  (dashboard-agenda-time-string-format "%m-%d %H:%M")
  ;; (setq dashboard-agenda-prefix-format " %-10:c %-12s ")
  (dashboard-items '((recents  . 5)
			  (bookmarks . 5)
			  (projects . 5)
			  ;; (agenda . 15)
			  (registers . 5)))
  (dashboard-agenda-sort-strategy '(time-up))
  (dashboard-match-agenda-entry
      "TODO=\"TODO\"|TODO=\"IN PROGRESS\"|TODO=\"UPCOMING\"")
  (initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

;; refresh buffer after UI components load (necessary for emacs-daemon/czlient)
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (when (equal (buffer-name) "*dashboard*")
              (revert-buffer))))

;; helpful
(use-package helpful
  :ensure t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-command] . helpful-command)
  ([remap describe-mode] . helpful-mode))

(use-package elisp-demos
  :ensure t
  :config
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))


;; gptel
(use-package gptel
  :ensure t
  :functions gptel-end-of-response
  :custom
  (gptel-model 'gpt-5.1)
  (gptel-default-mode 'org-mode)
  :config
  (require 'gptel-integrations))

;; add text block markers around gptel responses with-editor
(add-hook 'gptel-post-response-functions
          (lambda (beg end)
            (goto-char beg)
            (save-excursion
              (backward-char)
              (insert "\n#+BEGIN_RESPONSE"))
            (gptel-end-of-response)
            (insert "\n#+END_RESPONSE")
            (insert "\n\n")))

(use-package gptel-agent
  :vc (:url "https://github.com/karthink/gptel-agent"
        :rev :newest)
  :config (gptel-agent-update))

;; install external dependencies enchant, pkgconf, and lang dict
;; pacman: enchant, pkgconf, hunspell-en_us
;; personal dictionary is located at =~/.config/enchant/en_US.dic=

;; (use-package jinx
;;   :ensure nil
;;   :hook (emacs-startup . global-jinx-mode)
;;   :bind (("M-$" . jinx-correct)
;;          ("C-M-$" . jinx-languages)))

;; parrot
(use-package parrot
  :ensure t
  :functions parrot-set-parrot-type
  :hook (emacs-startup . parrot-mode)
  :custom
  (parrot-num-rotations nil)
  :config
  (parrot-set-parrot-type 'emacs))

;; elcord
(use-package elcord
  :ensure t
  :hook (emacs-startup . elcord-mode)
  :custom (elcord-idle-message "call me maybe?"))

;; slack
(use-package slack
  :ensure t
  :vc (:url "https://github.com/emacs-slack/emacs-slack" :rev :newest)
  )

;; erc (irc)
(use-package erc
  :custom
  (erc-nick "polhuang")
  (erc-user-full-name "polhuang")
  (erc-autojoin-channels-alist '((Libera.Chat "#systemcrafters" "#emacsatx")))
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  :functions my/connect-to-erc
  :config
  (defun my/connect-to-erc ()
    (interactive)
    (erc :server "irc.libera.chat"
         :port "6667"
         :password (cadr (auth-source-user-and-password "irc.libera.chat")))))

(my/connect-to-erc)

;; org-gcal
(use-package org-gcal
  :ensure t
  :after org
  :functions (org-entry-get org-entry-put org-todo org-sort-entries org-gcal-sync org-back-to-heading org-end-of-)
  :custom
  (org-gcal-up-days 0)
  (org-gcal-down-days 30)
  ;; prevent org-id from scanning archive files (org-gcal uses org-id to find entries)
  (org-id-extra-files 'org-agenda-files)

  :init
  ;; load credentials
  (load (expand-file-name "private/gcal-credentials.el" user-emacs-directory))

  :config
  (defun my/clear-extra-gcal-timestamps ()
    "Remove all lines in the current buffer that start with '<'.
This clears timestamps org-gcal puts into the org-gcal drawer after sync."
    (interactive)
    (goto-char (point-min))
    (while (re-search-forward "^<.*$" nil t)
      (replace-match "")))

  (defun my/delete-unwanted-gcal-entries ()
    "Delete calendar entries with specific titles after org-gcal sync."
    (interactive)
    (let ((unwanted-titles '("Body Doubling: Working Session"
                            "▵ Global Startups Sales All Hands ▵"
                            "▲ Team Meditation with Jeremy"
                            "Demo Doys"
                            "Crossbeam Office Hours [Sales Team]: Accelerate Partner Pipeline & Deals"
                            "DD: Weekly Office Hours (Optional)"))
          (schedule-file (expand-file-name "~/org/agenda/schedule.org")))
      (when (file-exists-p schedule-file)
        (with-current-buffer (find-file-noselect schedule-file)
          (save-excursion
            (goto-char (point-min))
            (dolist (title unwanted-titles)
              (goto-char (point-min))
              (while (re-search-forward (concat "^\\* \\(UPCOMING\\|TODO\\|DONE\\) " (regexp-quote title) "$") nil t)
                (org-back-to-heading t)
                (delete-region (point) (progn (org-end-of-subtree t t) (point))))))
          (save-buffer))))
    (message "Deleted unwanted calendar entries"))

  (defun my/cleanup-schedule-after-sync ()
    "Clean up schedule.org: clear extra timestamps, sort entries, delete unwanted entries."
    (interactive)
    (let ((schedule-file (expand-file-name "~/org/agenda/schedule.org")))
      (when (file-exists-p schedule-file)
        (with-current-buffer (find-file-noselect schedule-file)
          (save-excursion
            (my/clear-extra-gcal-timestamps)
            (goto-char (point-min))
            (condition-case nil
                (org-sort-entries t ?s)
              (user-error nil)))
          (save-buffer))))
    (my/delete-unwanted-gcal-entries))

  (defun my/org-gcal-format (calendar-id event update-mode)
    "Format org-gcal events in the schedule.org buffer.
Add :notify: event on import."
    (if (eq update-mode 'newly-fetched)
        (progn
          ;; Timed events
          (when-let* ((stime (plist-get (plist-get event :start) :dateTime))
                      (etime (plist-get (plist-get event :end) :dateTime))
                      (start-time (date-to-time stime))
                      (end-time (date-to-time etime))
                      (formatted-stime (format-time-string "%Y-%m-%d %a %H:%M" start-time))
                      (formatted-etime (format-time-string "%H:%M" end-time)))
            (org-todo "UPCOMING")
            (org-schedule nil (format "<%s-%s>" formatted-stime formatted-etime)))

          ;; All-day events
          (when-let* ((stime (plist-get (plist-get event :start) :date)))
            (if (string= calendar-id "997d9ee06bb6de8790f30e0fe0e8a52e60a15bf1301173490f0e92247a2eb4ad@group.calendar.google.com") ;; TickTick tasks - import as tasks
                (org-todo "TODO")
              (org-todo "UPCOMING"))
            (org-schedule nil (format "<%s>" stime)))

          ;; Add :notify: event once on import
          (let ((cur (or (org-entry-get (point) "notify") "")))
            (unless (string= cur "event")
              (org-entry-put (point) "notify" "event"))))
      ;; On updates: keep sort behavior
      (org-sort-entries nil ?o)))

  ;; Hook to format entries as they're imported
  (add-hook 'org-gcal-after-update-entry-functions 'my/org-gcal-format)

  ;; Advice to run cleanup after any org-gcal-sync call (waits 5 seconds for sync to complete)
  (advice-add 'org-gcal-sync :after
              (lambda (&rest _)
                (run-with-timer 5 nil 'my/cleanup-schedule-after-sync)))

  ;; Auto-sync: 30 seconds after startup, then repeat every hour
  (run-with-timer 30 3600
                  (lambda ()
                    (org-gcal-sync)
                    (message "gcal synced at %s" (format-time-string "%Y-%m-%d %H:%M:%S")))))

(use-package scratchpad
  :if (file-exists-p "~/projects/scratchpad/scratchpad.el")
  :load-path "~/projects/scratchpad"
  :config
  (scratchpad-enable)
  (global-set-key (kbd "C-M-z") 'scratchpad-toggle)
  (setq scratchpad-save-directory "~/org/scratchpad"))

(use-package org-linear
  :if (file-exists-p "~/projects/org-linear/org-linear.el")
  :load-path "~/projects/org-linear")
;; (load "~/.emacs.d/private/org-linear-credentials.el")

(use-package ticktick
  :if (file-exists-p "~/projects/ticktick.el/ticktick.el")
  :load-path "~/projects/ticktick.el"
  :custom
  (ticktick-sync-file "~/org/ticktick.org")
  (ticktick-autosync nil)
  :config
  (let ((auth-info (auth-source-user-and-password "ticktick.com")))
    (when auth-info
      (setq ticktick-client-id (car auth-info))
      (setq ticktick-client-secret (cadr auth-info)))))

(use-package org-roam-obsidian-sync
  :if (file-exists-p "~/projects/org-roam-obsidian-sync/org-roam-obsidian-sync.el")
  :load-path "~/projects/org-roam-obsidian-sync"
  :config
  (setq org-roam-obsidian-sync-on-change 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-vc-selected-packages
   '((emacsslack :url "https://github.com/emacs-slack/emacs-slack"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; byte-compile-warnings: (not docstrings)
;; End:
