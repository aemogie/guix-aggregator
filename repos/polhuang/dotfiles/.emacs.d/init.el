;;;;;;;;;;;;;;;;;;;;
;; emacs settings ;;
;;;;;;;;;;;;;;;;;;;;
(defvar is-guix nil
  "Variable indicating whether system is managed by guix.")

(setq is-guix (not (string-equal (system-name) "nineveh")))
(setq package-enable-at-startup nil)

;; set gc threshold for startup performance
(setq gc-cons-threshold (* 50 1000 1000))

;; define personal keybinding prefix (an unpragmatic keybinding repurposed for reprogrammed keyboard)
(defvar my-map (make-sparse-keymap))
(define-key global-map (kbd "C-M-]") my-map)

;; remap keyboard-quit for qmk keyboards
(global-set-key (kbd "C-M-s-]") 'keyboard-quit)

;; an all-purpose emacs alarm
(defun my/alarm (&optional length &rest _)
  (interactive)
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

;; enable packages from quelpa
(use-package quelpa
  :ensure t)

;; refresh package lists
;; (unless package-archive-contents
;;   (package-refresh-contents))

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

;; upgrade all packages
;; (package-upgrade-all)

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
(setq recentf-exclude '("schedule.org" "tasks.org" "init.el" "COMMIT_EDITMSG" "oauth2-auto.plist"))

;;;;;;;;;;;;;;;;;
;; ui settings ;;
;;;;;;;;;;;;;;;;;

;; everforest
(use-package everforest-theme
  :straight (everforest :type git :host github :repo "Theory-of-Everything/everforest-emacs")
  :config
  (load-theme 'everforest-hard-dark t t)
  (load-theme 'everforest-hard-light t t)
  (load-theme 'everforest-hard-olddark t t)
  (load-theme 'everforest-hard-oldlight t t))
;; (use-package everforest-hard-dark-theme
;;   :load-path "~/.emacs.d/everforest-emacs/"
;;   :config
;;   (set-face-attribute 'line-number nil :foreground "#7e968d")
;;   (set-face-attribute 'line-number-current-line nil :weight 'bold)
;;   (with-eval-after-load 'org
;;     (set-face-attribute 'org-priority nil :weight 'bold)
;;     (set-face-attribute 'org-agenda-structure nil :weight 'bold)))

;; (use-package everforest-hard-light-theme
;;   :load-path "~/.emacs.d/everforest-emacs/")

(use-package cherry-seoul256-theme
  :load-path "~/projects/cherry-seoul256/"
  :custom
  (cherry-seoul256-background 233)
  :config
  (load-theme 'cherry-seoul256 t))

;; (defvar current-theme 'everforest-hard-dark
;;   "Stores the currently active theme name.")

;; (defun my/cycle-theme ()
;;   "Cycle between everforest-hard-dark, everforest-hard-light, and cherry-seoul256 themes."
;;   (interactive)
;;   (cond
;;    ((eq current-theme 'everforest-hard-dark)
;;     (disable-theme 'everforest-hard-dark)
;;     (load-theme 'everforest-hard-light t)
;;     (setq current-theme 'everforest-hard-light))

;;    ((eq current-theme 'everforest-hard-light)
;;     (disable-theme 'everforest-hard-light)
;;     (load-theme 'cherry-seoul256 t)
;;     (setq current-theme 'cherry-seoul256))

;;    ((eq current-theme 'cherry-seoul256)
;;     (disable-theme 'cherry-seoul256)
;;     (load-theme 'everforest-hard-dark t)
;;     (setq current-theme 'everforest-hard-dark))))

;; ;; Initially load the first theme
;; (load-theme current-theme t)

;; (global-set-key (kbd "C-M-] r t") 'my/cycle-theme)
;; (global-set-key (kbd "C-M-] r T") 'my/toggle-frametransparency)
;; (global-set-key (kbd "C-M-] r +") 'cherry-seoul256-brighten-background)
;; (global-set-key (kbd "C-M-] r -") 'cherry-seoul256-darken-background)


;; ansi colors
(require 'ansi-color)
(set-face-attribute 'ansi-color-black nil :foreground "#1b1b23" :background (face-attribute 'default :background))
(set-face-attribute 'ansi-color-red nil :foreground "#ebb9b9" :background "#ebb9b9")
(set-face-attribute 'ansi-color-green nil :foreground "#caf6bb" :background "#caf6bb")
(set-face-attribute 'ansi-color-yellow nil :foreground "#e6dfb8" :background "#e6dfb8")
(set-face-attribute 'ansi-color-blue nil :foreground "#cddbf9" :background "#cddbf9")
(set-face-attribute 'ansi-color-magenta nil :foreground "#f6bbe7" :background "#f6bbe7")
(set-face-attribute 'ansi-color-cyan nil :foreground "#b8dceb" :background "#b8dceb")
(set-face-attribute 'ansi-color-white nil :foreground "#c8cedc" :background "#c8cedc")

(set-face-attribute 'ansi-color-bright-black nil :foreground "#1b1b23" :background (face-attribute 'default :background))
(set-face-attribute 'ansi-color-bright-red nil :foreground "#d95e59" :background "#d95e59")
(set-face-attribute 'ansi-color-bright-green nil :foreground "#8fc587" :background "#8fc587")
(set-face-attribute 'ansi-color-bright-yellow nil :foreground "#ffcf85" :background "#ffcf85")
(set-face-attribute 'ansi-color-bright-blue nil :foreground "#4a83c3" :background "#4a83c3")
(set-face-attribute 'ansi-color-bright-magenta nil :foreground "#f6bbe7" :background "#f6bbe7")
(set-face-attribute 'ansi-color-bright-cyan nil :foreground "#4eb3cd" :background "#4eb3cd")

(use-package autothemer
  :defer t)

(with-eval-after-load 'marginalia
  (set-face-attribute 'marginalia-documentation nil :inherit 'doom-mode-line :slant 'italic))

;; misc ui settingsq
(menu-bar-mode -1)
(global-hl-line-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
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

;; transparency
(add-to-list 'default-frame-alist '(alpha-background . 65))

(defun my/toggle-frametransparency ()
  "Toggle frame transparency."
  (interactive)
  (let ((current-alpha (frame-parameter nil 'alpha-background)))
    (if (or (not current-alpha) (= current-alpha 100))
        (progn
          (set-frame-parameter nil 'alpha-background 60)
          (cherry-seoul256-create 'cherry-seoul256 233))
      (progn
        (set-frame-parameter nil 'alpha-background 100)
        (cherry-seoul256-create 'cherry-seoul256 235)))))

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
  (let* ((font (if (string= font-name "Random")
                   (nth (random (length (remove (assoc "Random" my/font-options) my/font-options))) my/font-options)
                 (assoc font-name my/font-options)))
         (font-name (car font))
         (height (cdr font)))
    (when font
      (set-face-attribute 'default nil :family font-name :height (or height 120))
      (message "Font set to: %s with height %d" font-name (or height 120)))))

(defun my/select-font ()
  (interactive)
  (let* ((font-names (mapcar #'car my/font-options))
         (selected-font (completing-read "Select font: " font-names nil t)))
    (my/set-font selected-font)))

(defun my/cycle-fonts ()
  "Cycle through the fonts in `my/font-options` and set the next one."
  (interactive)
  (let* ((num-fonts (length my/font-options))
         (new-index (mod (1+ my/current-font-index) num-fonts))
         (font (nth new-index my/font-options))
         (font-name (car font)))
    (setq my/current-font-index new-index)
    (my/set-font font-name)))

(my/set-font "Fira Code") ;; default

(global-set-key (kbd "C-M-] r F") 'my/select-font)
(global-set-key (kbd "C-M-] r f") 'my/cycle-fonts)

;; fontify-face
(use-package fontify-face
  :ensure t)

;; define non-breaking space
(defface my/non-breaking-space
  '((t :inherit default))
  "My non-breaking space face.")
(font-lock-add-keywords 'org-mode '(("\u00a0" . 'my/non-breaking-space)))

;; rainbow mode
(use-package rainbow-mode
  :ensure t)

;; chinese font
(defface my/chinese-face
  '((t :family "Noto Sans CJK TC"))
  "Face for Chinese characters.")

;; add the new face to the `face-font-family-alternatives` variable
(setq face-font-family-alternatives
      '(("Noto Sans CJK TC" "han" "cjk")
        ("my-chinese-face" "cjk")
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
    (outline-minor-mode . " ֍" ;; " [o]"
                        )
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
;; (require 'alert)
(setq alert-default-style "notifications")

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
(defvar my/default-scroll-lines 60)
(setq scroll-conservatively 5)

;; custom scrolling keybinds
(defvar my/scroll-unit 20)
(global-set-key (kbd "C-M-s-3") (lambda () (interactive) (forward-line (* my/scroll-unit -1))))
(global-set-key (kbd "C-M-s-4") (lambda () (interactive) (forward-line (* my/scroll-unit -2))))
(global-set-key (kbd "C-M-s-0") (lambda () (interactive) (forward-line (* my/scroll-unit -4))))
(global-set-key (kbd "C-M-s-1") (lambda () (interactive) (forward-line (* my/scroll-unit -8))))
(global-set-key (kbd "C-M-s-2") (lambda () (interactive) (forward-line (* my/scroll-unit -16))))


(global-set-key (kbd "C-M-s-5") (lambda () (interactive) (forward-line my/scroll-unit)))
(global-set-key (kbd "C-M-s-6") (lambda () (interactive) (forward-line (* my/scroll-unit 2))))
(global-set-key (kbd "C-M-s-8") (lambda () (interactive) (forward-line (* my/scroll-unit 8))))
(global-set-key (kbd "C-M-s-7") (lambda () (interactive) (forward-line (* my/scroll-unit 4))))
(global-set-key (kbd "C-M-s-9") (lambda () (interactive) (forward-line (* my/scroll-unit 16))))

;; keep cursor in same position
(setq scroll-preserve-screen-position t)

(defun my/scroll (orig-func direction &optional arg)
  "Redefine upward scroll distance.
ORIG-FUNC is the original function passed by `advice-add`.
DIRECTION IS \\='up or \\='down.
Use prefix argument ARG for number of lines, otherwise use default."
  ;; (apply orig-func (list (or arg my/default-scroll-lines)))
  (funcall orig-func (or arg my/default-scroll-lines)))

(advice-add 'scroll-up :around (lambda (orig-func &optional arg)
                                 (my/scroll orig-func 'up arg)))
(advice-add 'scroll-down :around (lambda (orig-func &optional arg)
                                   (my/scroll orig-func 'down arg)))

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
(set-register ?d (cons 'file "~/org/dictionary"))
(set-register ?e (cons 'file "~/.dotfiles/.emacs.d/init.el"))
(set-register ?h (cons 'file "~/polterguix/files/hypr/hyprland-base.conf"))
(set-register ?s (cons 'file "~/org/schedule.org"))
(set-register ?S (cons 'file "~/projects/cherry-seoul256/cherry-seoul256-theme.el"))
(set-register ?t (cons 'file "~/org/tasks.org"))
(set-register ?z (cons 'file "~/.dotfiles/.zshrc"))

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
  :commands org-capture-finalize
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
  (org-mode . turn-on-org-cdlatex)
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

  ;; Kill the frame if one was created for the capture
  (defvar my/delete-frame-after-capture 0 "Whether to delete the last frame after the current capture")

  ;; delete pop-up capture frames after finalize/kill/refile. at popup, set `my/delete-frame-after-capture' to 1
  (defun my/delete-frame-if-necessary (&rest r)
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

  (org-agenda-start-with-archives-mode t)
  (org-agenda-files '("~/org/tasks.org" "~/org/projects.org" "~/org/schedule.org"))
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
         ((org-agenda-span 'day)
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
  
  (org-todo-keyword-faces
        '(("IN PROGRESS" . (:foreground "#F1C40F" :distant-foreground "e6dfb8" :weight bold))
          ("UPCOMING" . (:foreground "#cddbf9" :weight bold))
          ("HABIT" . (:foreground "#f6bbe7" :weight bold))
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
	  ("L" "Protocol Link" entry (file+headline ,(concat org-directory "notes.org") "Inbox")
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

  (defun my/org-add-electric-pairs ()
    (setq-local electric-pair-pairs (append electric-pair-pairs org-electric-pairs))
    (setq-local electric-pair-text-pairs electric-pair-pairs))

  (defun my/org-capture-and-kill ()
    "Finalize the current Org capture and then kill the buffer."
    (interactive)
    (org-capture-finalize)
    (delete-frame)))

(use-package org-protocol
  :ensure nil)

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
   '(("d" "default" entry "* %<%I:%M %p> \n%?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :config
  (require 'org-roam-dailies)
  (org-roam-db-autosync-mode)
  
  (defun org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
	  (org-roam-capture-templates (list (append (car org-roam-capture-templates)
						    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))

  ;; update org roam ids
  (org-roam-update-org-id-locations)

  (advice-add #'corfu-insert
              :after (lambda ()
                       (when
                           (eq major-mode 'org-mode)
                         (org-roam-link-replace-all)))))

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
  :custom
  (org-notify-timestamp-types '(:deadline :scheduled))
  :config
  (defun my/alarm-long (&rest _)
    "Wrapper function for alarm to fit :actions list below"
    (my/alarm "long"))
  (org-notify-start)
  (org-notify-add 'default
                  '(:time "5s" :duration 50 :urgency critical
                          :actions (my/alarm-long -notify))
        	  '(:time "1m" :duration 55
                          :actions (my/alarm -notify))
                  '(:time "5m" :duration 60
                          :actions (-notify))
                  '(:time "15m" :duration 60
                          :actions -notify)
                  '(:time "30m" :duration 1200 :actions -notify)))

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
  :commands org-clock-reminder-mode
  :init (org-clock-reminder-mode)
  :custom
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
  (org-clock-reminder-interval (cons 10 30))
  (org-clock-reminder-inactive-notifications-p nil)
  :config
  ;; replace function to configure urgency, timeout
  (defun org-clock-reminder-notify (title message)
    (let ((icon-path (org-clock-reminder--icon)))
      (notifications-notify :title title
                            :body message
                            :timeout 54000)))

  ;; define duration based on time since latest clock-in, not total clocked time
  ;; add current
  (org-clock-reminder-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hydra ----------------------------------------------------------------------- ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package hydra
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
"
  ("c" clone-frame :color blue)
  ("t" crux-transpose-windows :color blue)
  ("s" my/toggle-window-split :color blue)
  ("." nil :color blue))

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
  (define-key dired-mode-map "." 'hydra-dired/body))

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
  :ensure t
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
(defvar org-electric-pairs '((?$ . ?$))) ; add custom pairs

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

(use-package tempel
  :ensure t
  :bind (("C-c t t" . tempel-complete)
         ("C-c t i" . tempel-insert))
  :hook
  (prog-mode . tempel-setup-capf)
  (text-mode . tempel-setup-capf)
  (org-mode-hook . tempel-setup-capf)
  :custom
  (tempel-path (expand-file-name "templates" user-emacs-directory))
  (tempel-trigger-prefix "<")
  :init
  (defun tempel-setup-capf ()
    "Adds the tempel capf to completion-at-point-functions"
    (setq-local completion-at-point-functions
                (cons #'tempel-complete
                      completion-at-point-functions)))
  
  (global-tempel-abbrev-mode))

;;;;;;;;;;;;;;;;;;;;;;;
;; completion system ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; orderless
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)
                     'completion-category-defaults nil
                     completion-category-overrides '((file (styles partial-completion)))))

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
	 ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
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
  :custom
  (corfu-auto t)                    ;; Enable auto completion
  (corfu-history-mode)
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
  :commands (prescient-persist-mode)
  :config
  (prescient-persist-mode))

(use-package corfu-prescient
  :ensure t
  :config
  (corfu-prescient-mode))

(use-package vertico-prescient
  :ensure t
  :config
  (vertico-prescient-mode))

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

(defvar emacs-styling-map
  (let ((map (make-sparse-keymap)))
    (pcase-dolist (`(,k . ,f)
                   '(("f" . my/cycle-fonts)
                     ("t" . my/cycle-theme)
                     ("+" . cherry-seoul256-brighten-background)
                     ("-" . cherry-seoul256-darken-background)))
      (define-key map (kbd k) f))
    map))

(map-keymap
 (lambda (_ cmd)
   (put cmd 'repeat-map 'emacs-styling-map)) emacs-styling-map)

;; persistent scratch
(use-package persistent-scratch
  :ensure t
  :config
  (persistent-scratch-setup-default))

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
  :commands (lsp lsp-deferred)
  :bind (:map lsp-key-)
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
  (lsp-mode . lsp-ui-mode)
  :bind (("C-c l d" . lsp-ui-doc-show))
  :custom
  (lsp-ui-sidebar-enable nil)
  (lsp-ui-doc-position 'at-point)
  :commands lsp-ui-mode)

(use-package lsp-tailwindcss
  :ensure t
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
  :commands (treesit-auto-add-to-auto-mode-alist global-treesit-auto-mode)
  :ensure t
  :init
  (treesit-auto-add-to-auto-mode-alist 'all)
  :custom
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
(use-package mu4e
  :ensure nil
  :load-path "/usr/share/emacs/site-lisp/mu4e/"
  :custom
  (mu4e-use-fancy-chars t)
  (mu4e-bookmarks
   '((:name "Unread messages"
            :query "flag:unread AND NOT flag:trashed AND NOT \"maildir:/All Mail\""
            :key ?u)
     (:name "Today's messages"
            :query "date:today..now"
            :key ?t)
     (:name "Last 7 days"
            :query "date:7d..now"
            :hide-unread t
            :key ?w)
     (:name "Messages with images"
            :query "mime:image/*"
            :key ?p)))
  (mail-user-agent 'mu4e-user-agent)
  (mu4e-update-interval (* 5 60))
  (mu4e-mu-version "1.12.8")
  (message-send-mail-function 'smtpmail-send-it)
  (smtpmail-smtp-server "127.0.0.1")
  (smtpmail-smtp-service 1025)
  (mu4e-get-mail-command "mbsync -a & offlineimap")
  (message-kill-buffer-on-exit t)
  (mu4e-context-policy 'pick-first)
  :config
  (setq message-signature
        "Paul Huang\n[[https://github.com/polhuang][Github]] | [[https://linkedin.com/in/paulleehuang][LinkedIn]]\n")
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
            :name "Personal"
            :enter-func (lambda () (mu4e-message "Switch to the Personal context"))
            :match-func (lambda (msg)
                          (when msg
                            (mu4e-message-contact-field-matches msg
                                                                 :to "paulleehuang@proton.me")))
            :vars '((user-mail-address . "paulleehuang@proton.me")
                    (user-full-name    . "Paul Huang")
                    (mu4e-sent-folder  . "/Protonmail/Sent")
                    (mu4e-drafts-folder . "/Protonmail/Drafts")
                    (mu4e-trash-folder  . "/Protonmail/Trash")
                    (mu4e-refile-folder . "/Protonmail/All Mail")
                    (mu4e-maildir-shortcuts . ((:maildir "/Protonmail/inbox" :key ?i :name "Inbox")
                                               (:maildir "/Protonmail/Sent" :key ?s :name "Sent")
                                               (:maildir "/Protonmail/Trash" :key ?t :name "Trash")
                                               (:maildir "/Protonmail/All Mail" :key ?a :name "All Mail")))))

          ,(make-mu4e-context
            :name "Work"
            :enter-func (lambda () (mu4e-message "Switch to the Work context"))
            :match-func (lambda (msg)
                          (when msg
                            (mu4e-message-contact-field-matches msg
                                                                 :to "phuang@missioncloud.com")))
            :vars '((user-mail-address . "phuang@missioncloud.com")
                    (user-full-name    . "Paul Huang")
                    (mu4e-sent-folder  . "/Gmail/[Gmail].Sent Mail")
                    (mu4e-drafts-folder . "/Gmail/[Gmail].Drafts")
                    (mu4e-trash-folder  . "/Gmail/[Gmail].Trash")
                    (mu4e-refile-folder . "/Gmail/[Gmail].All Mail")
                    (mu4e-maildir-shortcuts . (("/Gmail/INBOX"      . ?i)
                                               ("/Gmail/[Gmail].Sent Mail" . ?s)
                                               ("/Gmail/[Gmail].Trash" . ?t)
                                               ("/Gmail/[Gmail].All Mail" . ?a))))))))

;; org-mime
(use-package org-mime
  :ensure t
  :custom
  (setq org-mime-mail-signature-separator "a string preventing separating signature from email body")
  :config
  (setq org-mime-export-options '(:section-numbers nil
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

;; perspective
(use-package perspective
  :ensure t
  :commands persp-mode
  :custom
  (consult-customize consult--source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source)
  (persp-mode-prefix-key (kbd "C-c M-p"))
  (persp-state-default-file (expand-file-name "perspectives/default" user-emacs-directory))
  :init
  (persp-mode))

;; nyan-mode
(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode 1))

;; zone-mode
(use-package zone
  :commands zone-when-idle
  :config
  (zone-when-idle 600))

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
			  (agenda . 15)
			  (registers . 5)))
  (dashboard-agenda-sort-strategy '(time-up))
  (dashboard-match-agenda-entry
      "TODO=\"TODO\"|TODO=\"IN PROGRESS\"|TODO=\"UPCOMING\"")
  (initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

;; refresh buffer after UI components load (necessary for emacs-daemon/client)
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
  :commands gptel-end-of-response
  :custom
  (gptel-model "gpt-4o")
  (gptel-default-mode 'org-mode))

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

(use-package elysium
  :ensure t
  :custom
  (elysium-window-size 0.33) 
  (elysium-window-style 'vertical))

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
  :commands parrot-set-parrot-type
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

;; erc (irc)
(use-package erc
  :custom
  (erc-nick "polhuang")
  (erc-user-full-name "polhuang")
  (erc-autojoin-channels-alist '((".*" "#systemcrafters" "#emacsatx")))
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  :functions my/connect-to-erc
  :config
  (defun my/connect-to-erc ()
    (interactive)
    (erc :server "irc.libera.chat"
         :port "6667"
         :password (cadr (auth-source-user-and-password "irc.libera.chat"))))
  (my/connect-to-erc))

;; org-gcal
(use-package org-gcal
  :commands (org-todo org-sort-entries org-gcal-sync org-gcal--sync-unlock)
  :custom
  (org-gcal-up-days 0)
  (org-gcal-down-days 30)
  :init
  ;; format gcal property hook
  (add-hook 'org-gcal-after-update-entry-functions 'my/org-gcal-format)
  (load (expand-file-name "private/gcal-credentials.el" user-emacs-directory))
  
  ;; set delay time in seconds (30 seconds in this case) before running (due to emacs-daemon startup time).
  ;; run once an hour
  (run-with-timer 30 3600
                  (lambda ()
                    (org-gcal-sync)
                    (message "GCal synced at %s" (format-time-string "%Y-%m-%d %H:%M:%S"))))

  ;; this function is used as a local variable in schedule.org to remove the
  ;; timestamps org-gcal puts into the org-gcal drawer after sync
  (defun my/clear-extra-gcal-timestamps ()
    "Remove all lines in the current buffer that start with the character '<'."
    (interactive)
    (goto-char (point-min))
    (while (re-search-forward "^<.*$" nil t)
      (replace-match "")))

  :config
  (defun my/org-gcal-format (_calendar-id event _update-mode)
      "Format org-gcal events in the schedule.org buffer."
      (if (eq _update-mode 'newly-fetched)
          (progn
            (when-let* ((stime (plist-get (plist-get event :start) :dateTime))
                        (etime (plist-get (plist-get event :end) :dateTime))
                        (start-time (date-to-time stime))
                        (end-time (date-to-time etime))
                        (formatted-stime (format-time-string "%Y-%m-%d %a %H:%M" start-time))
                        (formatted-etime (format-time-string "%H:%M" end-time)))
              (org-todo "UPCOMING")
              (org-schedule nil (format "<%s-%s>" formatted-stime formatted-etime)))
            (when-let* ((stime (plist-get (plist-get event :start) :date)))
              (if (string= _calendar-id "997d9ee06bb6de8790f30e0fe0e8a52e60a15bf1301173490f0e92247a2eb4ad@group.calendar.google.com")
                  (org-todo "TODO")
                (org-todo "UPCOMING"))
              (org-schedule nil (format "<%s>" stime))))
        (org-sort-entries nil ?o)))

  (defun my/delete-specified-org-headings-in-file (file headings-to-delete)
  "Delete all occurrences of specified headings in FILE given
in HEADINGS-TO-DELETE."
  (when (file-exists-p file)
    (with-current-buffer (find-file-noselect file)
      (org-mode)
      (goto-char (point-min))
      (org-map-entries
       (lambda ()
         (let ((heading (nth 4 (org-heading-components))))
           (when (and heading (member (string-trim heading) headings-to-delete))
             (org-cut-subtree))))
       t)  ;; Use 't' to process all headings in the buffer
      (save-buffer)
      ;; (kill-buffer)
      )))
  
  (my/delete-specified-org-headings-in-file
   "~/org/schedule.org"
   '(
   "AWS (Office)"
   "Channels & Alliances Office Hours"
   "Daily Guilt Free Break"
   "Dream Team Weekly Pipeline Review"
   "Dream Team Weekly Sync"
   "Focus"
   "Large Deal Review"
   "Midweek Meditation"
   "Mission - Office Hour with Paul"
   "Product Marketing Office Hours"
   "Salesforce Office Hours"))

  (my/delete-specified-org-headings-in-file
   "~/org/schedule.org_archive"
   '(
     "All Hands | Department Updates"
     "Bobby, Paul, Jake Mission, AWS, CDW Bi-weekly Cadence"
     "Channels & Alliances Office Hours"
     "Daily Guilt Free Break"
     "Do BoostUp"
     "Dr. Abbott"
     "Dream Team Weekly Pipeline Review"
     "Dream Team Weekly Sync"
     "Focus"
     "Emacs ATX Meetup"
     "GTM Standup"
     "Joshua / Paul"
     "Kyle / Paul"
     "Large Deal Review"
     "Mission - Office Hour with Paul"
     "New(ish) Crew | Weekly Sync"
     "Resale Operations Office Hours")))

;; scratchpad in scratch buffers
(load "~/projects/scratchpad/scratchpad.el")
(global-set-key (kbd "C-M-z") 'scratchpad-toggle)
(setq scratchpad-save-directory "~/org/scratchpad")

(use-package org-jira
  :ensure t
  :custom
  (jiralib-update-issue-fields-exclude-list '(priority components))
  :config
  (setq jiralib-url "https://polhuang.atlassian.net")
  (setq org-jira-working-dir "~/jira"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("9f1c593abc996917c24f563e68f44bb4175d4419925577014757f6ba2dfe2850"
     "ed70dedb2c45f8b698c1f7ab04b6a0d8678f6d49cd977e01b35f8546dcbb4aa8"
     "d585421c2f1917400daaac0b628ee74e0c2d2960b99680cc75b393601adef535"
     "a53c7ff4570e23d7c5833cd342c461684aa55ddba09b7788d6ae70e7645c12b4"
     "67f6b0de6f60890db4c799b50c0670545c4234f179f03e757db5d95e99bac332"
     "7142a20d65513972790584a98dcfa2925126383817399438dcf133cb4eea96e3"
     "477715cf84159782e44bcea3c90697e4c64896b5af42d0466b2dd44ece279505"
     "b4c6b60bf5cf727ca62651c0a0147e0e6ba63564215bd3fd9bab771e7914bea8"
     "c9dba7f4b46497b5bddfab834603fc1748d50f6ea027c347561bb3d81a9c6a32"
     "57763ac4917fe06157c891fd73fd9a9db340bfe3a04392bb68b2df9032ce14a5"
     "e9aa348abd3713a75f2c5ba279aa581b1c6ec187ebefbfa33373083ff8004c7c"
     "7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98"
     default))
 '(epg-pinentry-mode 'loopback nil nil "Customized with use-package epa")
 '(safe-local-variable-values
   '((eval progn (my/clear-extra-gcal-timestamps) (goto-char (point-min))
           (org-sort-entries t 115))
     (eval save-excursion (goto-char (point-min))
           (while (re-search-forward "^\\(<\\([^>]+\\)>\\)" nil t)
             (replace-match "SCHEDULED: \\1")))
     (eval org-columns) (eval outline-next-heading)
     (eval goto-char (point-min))))
 '(warning-suppress-types '((comp))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; byte-compile-warnings: (not docstrings)
;; End:
