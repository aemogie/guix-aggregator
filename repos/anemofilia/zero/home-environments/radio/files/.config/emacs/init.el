;;; -*- lexical-binding: t; origami-mode: t -*-

(use-package emacs
  :custom ((indent-tabs-mode nil))
  :config
  ;; who am I?
  (setq user-full-name         "Luis Guilherme Coelho"
        user-email-address     "lgcoelho@disroot.org"
        copyright-names-regexp (format "%s <%s>"
                                       user-full-name
                                       user-mail-address))

  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))

  ;; load-path
  (add-to-list 'load-path
               "~/.guix-home/profile/share/emacs/site-lisp")

  ;; display-line-numbers variables
  (setq display-line-numbers-current-absolute t
        display-line-numbers-grow-only        t
        display-line-numbers-type             'relative
        display-line-numbers-width            4
        display-line-numbers-width-start      t)

  ;; guix stuff
  (load-file "~/projects/code/scm/guix/etc/copyright.el")

  ;; keep ~/.config/emacs/ clean
  (setq user-emacs-directory (expand-file-name "~/.cache/emacs/"))
  (setq url-history-file (expand-file-name "url/history"
                                           user-emacs-directory))

  ;; keep customization settings in a temporary file
  (setq custom-file
        (if (boundp 'server-socket-dir)
            (expand-file-name "custom.el" server-socket-dir)
          (expand-file-name (format "emacs-custom-%s.el" (user-uid))
                            temporary-file-directory)))
  (load custom-file t)

  ;; backups
  (setq backup-directory-alist
        `((".*" . ,(expand-file-name "backups" user-emacs-directory)))
        auto-save-file-name-transforms
        `((".*" ,(expand-file-name "autosave/"  user-emacs-directory) t)))
  (setq create-lockfiles nil
        backup-by-copying t
        version-control t
        delete-old-versions t
        vc-make-backup-files t
        kept-old-versions 10
        kept-new-versions 10)

  ;; dialog box
  (setq use-dialog-box nil)

  ;; scrolling
  (setq scroll-conservatively 101
        scroll-margin 2)

  ;; lmao?
  (setq enable-recursive-minibuffers t)

  ;; radix
  (defun radix (dir)
    (lambda ()
      (let* ((radix "~/areas/code/scm/radix")
             (default-directory (concat radix "/radix/" dir "/")))
        (call-interactively 'find-file))))

  (defun radix-packages ()
    (interactive)
    (funcall (radix "packages")))

  (defun radix-services ()
    (interactive)
    (funcall (radix "services")))

  (defun radix-home-services ()
    (interactive)
    (funcall (radix "home/services")))

  (defun radix-system ()
    (interactive)
    (funcall (radix "system")))

  ;; zero
  (defun zero (dir)
    (lambda ()
      (interactive)
      (let* ((zero "~/areas/code/scm/zero")
             (default-directory (concat zero "/" dir "/")))
        (call-interactively 'find-file))))

  (defun home ()
    (interactive)
    (funcall (zero "home-environments")))

  (defun system ()
    (interactive)
    (funcall (zero "operating-systems")))

  (defun files ()
    (interactive)
    (funcall (zero "home-environments/radio/files")))

  (defun config ()
    (interactive)
    (let* ((default-directory "~/.config/emacs/"))
      (call-interactively 'find-file)))

  (defun radio-manifests ()
    (interactive)
    (funcall (zero "home-environments/radio/manifests")))

  (defun radio-packages ()
    (interactive)
   (funcall (zero "home-environments/radio/packages")))

  ;; misc
  (setq-default buffer-file-coding-system 'utf-8-unix)

  :bind ();; unset some keys
         ;;("C-x C-b" . nil))

  :hook (;; globally enabled modes
         (after-init . column-number-mode)
         (after-init . prettify-symbols-mode)
         (after-init . save-place-mode)
         (after-init . savehist-mode)

         ((text-mode prog-mode conf-mode) . display-line-numbers-mode)
         ((text-mode prog-mode conf-mode) . electric-pair-local-mode)
         ((text-mode prog-mode conf-mode) . whitespace-mode)))

;; server
(use-package server
  :config (unless (server-running-p)
            (server-start)))

;; diminish
(use-package diminish)

;; auto-revert
(use-package autorevert
  :diminish auto-revert-mode
  :hook ((text-mode prog-mode conf-mode) . auto-revert-mode))

;; rainbow-delimiters
(use-package rainbow-delimiters
  :hook ((text-mode prog-mode conf-mode) . rainbow-delimiters-mode))

;; helpful
(use-package helpful
  :custom (help-select-window t)
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h C-." . helpful-at-point)))

;; anzu-mode
(use-package anzu
  :diminish anzu-mode
  :bind
  (([remap query-replace] . anzu-query-replace)
   ([remap query-replace-regexp] . anzu-query-replace-regexp)
   :map isearch-mode-map
   ([remap isearch-query-replace] . anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :init (global-anzu-mode))

;; dirvish
(use-package dirvish
  :config
  (defun dirvish-dotfiles-toggle ()
    (interactive)
    (setq-default dired-listing-switches
                  (let ((switches (split-string dired-listing-switches)))
                    (string-join (if (member "--almost-all" switches)
                                     (remove "--almost-all" switches)
                                   (cons "--almost-all" switches))
                                 " ")))
    (revert-buffer-quick))
  :custom
  ((dired-recursive-deletes 'always)
   (dired-recursive-copies 'always)
   (dired-listing-switches
    "-l --human-readable --group-directories-first --no-group")
   (dirvish-quick-access-entries
    '(("h" "~/"                          "~")
      ("c" "~/.config/"                  "~/.config")
      ("d" "~/media/downloads/"          "~/media/downloads")
      ("m" "~/media/music/"              "~/media/music")
      ("p" "~/media/pictures/"           "~/media/pictures")
      ("v" "~/media/videos/"             "~/media/videos")
      ("z" "~/areas/code/scm/zero/"      "~/areas/code/scm/zero")))
   (dirvish-header-line-format
    '(:left (path) :right (free-space)))
   (dirvish-mode-line-format
    '(:left
      (sort file-time " " file-size symlink)
      :right
      (omit yank index)))
   (dirvish-attributes
    '(all-the-icons git-msg file-size)))
  :bind (("C-x d" . dirvish)
         :map dirvish-mode-map
         ("h" . dired-up-directory)
         ("l" . dired-view-file)
         ("RET" . dired-view-file)
         ("C-z h" . dirvish-dotfiles-toggle))
  :init (dirvish-override-dired-mode))

;; whitespace
(use-package whitespace
  :diminish whitespace-mode
  :custom ((whitespace-display-mappings
            '((space-mark    ?\   [?⋅])
              ;; fix strange behaviour with hl-fill-column-mode
              ;;(newline-mark  ?\n  [?↩ ?\n])
              (tab-mark      ?\t  [?→ ?\t])))))

;; hl-fill-column
(use-package hl-fill-column
  :config
  (set-face-attribute
   'hl-fill-column-face nil
   :background (face-attribute 'fill-column-indicator :background)
   :inverse-video nil)
  (defun hl-fill-column ()
    "Highlight all spaces in fill-column."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (let ((line-end (line-end-position)))
          (when (>= line-end)
            (goto-char (+ (line-beginning-position)
                          (- fill-column 1)))
            (overlay-put (make-overlay (- (point) 1) (point))
                         'font-lock-face
                         '(face :backgound "blue"))))
        (forward-line 1)))
    (font-lock-fontify-buffer))
  :hook
  ;;((text-mode prog-mode conf-mode) . hl-fill-column-mode)
  ((text-mode prog-mode conf-mode) . hl-fill-column)
  ((text-mode prog-mode conf-mode) . display-fill-column-indicator-mode))

;; org
(use-package org
  :custom ((org-hide-emphasis-markers t))
  :hook (org-mode . (lambda ()
                      (interactive)
                      (whitespace-mode 0)
                      (display-fill-column-indicator-mode 0)
                      (add-hook 'completion-at-point-functions #'cape-tex))))

;; irc
(use-package circe
  :custom
  (circe-nick "anemofilia")
  (circe-channels '("#emacs" "#gnu" "#guile" "#guix" "#spritely"))
  :hook (circe-mode . circe-server-mode))

;; haskell
(use-package haskell
  :hook (haskell-mode . haskell-doc-mode))

;; mastodon
(use-package mastodon
  :custom
  (mastodon-instance-url "https://mathstodon.xyz")
  (mastodon-active-user  "anemofilia")
  :hook (mastodon-mode . mastodon-async-mode))

;; no-littering
(use-package no-littering)

;; origami
(use-package origami)

;; eat
(use-package eat
  :hook (eat-mode . meow-insert-mode))

;; keys
(use-package which-key
  :diminish which-key-mode
  :custom ((which-key-idle-delay 0.3)
           (which-key-enable-extended-define-key nil))
  :init (which-key-mode))

;; pdf-view
(use-package pdf-tools
  :custom
  (pdf-outline-imenu-use-flat-menus t)
  (pdf-view-display-size 1.5)
  :bind (:map pdf-view-mode-map
              ("r" . pdf-view-rotate)
              ("R" . pdf-view-themed-minor-mode)
              ("J" . pdf-view-next-page)
              ("K" . pdf-view-previous-page)
              ("<tab>" . imenu))
  :hook
  (doc-view-mode . pdf-view-mode)
  (pdf-view-mode . pdf-outline-imenu-enable))

;; indent s-expr as you type
(use-package isayt
  :diminish isayt
  :hook ((lisp-mode
          emacs-lisp-mode
          ielm-mode
          scheme-mode
          racket-mode
          hy-mode
          lfe-mode
          dune-mode
          clojure-mode
          fennel-mode)
         . isayt-mode)
  :commands (isayt-mode))

;; lispyville
(use-package lispyville
  :diminish lispyville-mode
  :custom (lispyville-key-theme
           '(operators
             slurp/barf-lispy
             c-w
             additional
             text-objects
             commentary))
  :hook ((lisp-mode
          emacs-lisp-mode
          ielm-mode
          scheme-mode
          racket-mode
          hy-mode
          lfe-mode
          dune-mode
          clojure-mode
          fennel-mode)
         . lispyville-mode))

;; scheme
(use-package geiser
  :hook ((scheme-mode . geiser-mode)
         (geiser-mode . geiser)))

;; consult
(use-package consult
  :bind (("C-x b" . consult-buffer)))

;; marginalia
(use-package marginalia
  :init (marginalia-mode))

;; orderless
(use-package orderless
  :custom
  (orderless-matching-styles '(orderless-initialism orderless-flex))
  (completion-styles '(orderless basic))
  :config
  (defun orderless-fast-dispatch (word index total)
    (and (= index 0) (= total 1) (length< word 4)
         (cons 'orderless-literal-prefix word)))

  (orderless-define-completion-style orderless-fast
    (orderless-style-dispatchers '())
    (orderless-matching-styles '(orderless-flexg orderless-regexp))))

;; vertico
(use-package vertico
  :custom
  (vertico-multiform-commands
   '((imenu buffer)))
  (vertico-buffer-display-action
   '(display-buffer-in-direction
     (direction . left)
     (window-width . 0.3)))
  (vertico-buffer-hide-prompt t)
  (vertico-cycle nil)
  (vertico-scroll-margin 1)
  (minibuffer-prompt-properties
   (apply #'append '((read-only t)
                     (cursor-intangible t)
                     (face minibuffer-prompt))))
  :preface
  (defun my-minibuffer-backward-kill (arg)
    "When minibuffer is completing a file name delete up to parent
    folder, otherwise delete a word"
    (interactive "p")
    (if minibuffer-completing-file-name
        (if (string-match-p "/." (minibuffer-contents))
            (zap-up-to-char (- arg) ?/)
          (delete-minibuffer-contents))
      (kill-word (- arg))))
  :hook
  (after-init . vertico-multiform-mode)
  (minibuffer-setup . cursor-intangible-mode)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit))
  :bind (:map minibuffer-local-map
              ("C-<backspace>" . my-minibuffer-backward-kill))

  :init
  (vertico-mode))

;; corfu
(use-package corfu
  :preface
  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer if `completion-at-point' is bound."
    (when (where-is-internal #'completion-at-point
                             (list (current-local-map)))
      (corfu-mode 1)))
  :hook (((conf-mode text-mode prog-mode eshell-mode) . corfu-mode)
         (corfu-mode . corfu-popupinfo-mode)
         (minibuffer-setup . corfu-enable-in-minibuffer))
  :custom
  (corfu-cycle nil)
  (corfu-auto t)
  (corfu-popupinfo-delay '(1.0 . 0.5))
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'valid)
  (corfu-preview-current 'insert)
  :bind (:map corfu-map
              ("C-s" . corfu-quit)
              ("<tab>" . corfu-next)
              ("<backtab>" . corfu-previous)))

;; cape
(use-package cape
  :init
  (dolist (mode '(text-mode-hook prog-mode-hook conf-mode-hook))
          (add-hook mode
                    (lambda ()
                      (add-to-list 'completion-at-point-functions #'cape-file)
                      (add-to-list 'completion-at-point-functions #'cape-tex)
                      (add-to-list 'completion-at-point-functions #'cape-dabbrev)
                      (add-to-list 'completion-at-point-functions #'cape-keyword)
                      (add-to-list 'completion-at-point-functions #'cape-elisp-block)
                      (add-to-list 'completion-at-point-functions #'cape-elisp-symbol)))))

;; (use-package kakoune
;;   ;; Having a non-chord way to escape is important, since key-chords don't work in macros
;;   :bind ("C-z" . ryo-modal-mode)
;;   :hook (after-init . my/kakoune-setup)
;;   :config
;;   (defun ryo-enter () "Enter normal mode" (interactive) (ryo-modal-mode 1))
;;   (defun my/kakoune-setup ()
;;     "Call kakoune-setup-keybinds and then add some personal config."
;;     (kakoune-setup-keybinds)
;;     (setq ryo-modal-cursor-type 'box)
;;     (add-hook 'prog-mode-hook #'ryo-enter)
;;     (define-key ryo-modal-mode-map (kbd "SPC h") 'help-command)
;;     ;; Access all C-x bindings easily
;;     (define-key ryo-modal-mode-map (kbd "z") ctl-x-map)
;;     (ryo-modal-keys
;;      ("," save-buffer)
;;      ("P" counsel-yank-pop)
;;      ("m" mc/mark-next-like-this)
;;      ("M" mc/skip-to-next-like-this)
;;      ("n" mc/mark-previous-like-this)
;;      ("N" mc/skip-to-previous-like-this)
;;      ("M-m" mc/edit-lines)
;;      ("*" mc/mark-all-like-this)
;;      ("v" er/expand-region)
;;      ("C-v" set-rectangular-region-anchor)
;;      ("M-s" mc/split-region)
;;      (";" (("q" delete-window)
;;            ("v" split-window-horizontally)
;;            ("s" split-window-vertically)))
;;      ("C-h" windmove-left)
;;      ("C-j" windmove-down)
;;      ("C-k" windmove-up)
;;      ("C-l" windmove-right)
;;      ("C-u" scroll-down-command :first '(deactivate-mark))
;;      ("C-d" scroll-up-command :first '(deactivate-mark)))))

(load-file "~/.config/emacs/meow.el")
;;(use-package ryo-modal
;;  :custom (ryo-modal-cursor-color "#9688d9"))

;; This overrides the default mark-in-region with a prettier-looking one,
;; and provides a couple extra commands
;;(use-package visual-regexp
;;  :ryo (("s" vr/mc-mark)
;;        ("?" vr/replace)
;;        ("M-/" vr/query-replace)))
;;
;; Emacs incremental search doesn't work with multiple cursors, but this fixes that
;;(use-package phi-search
;;  :bind (("C-s" . phi-search)
;;         ("C-r" . phi-search-backward)))

;; Probably the first thing you'd miss is undo and redo, which requires an extra package
;; to work like it does in kakoune (and almost every other editor).
;;(use-package undo-tree
;;  :config
;;  (global-undo-tree-mode)
;;  :ryo (("u" undo-tree-undo)
;;        ("U" undo-tree-redo)
;;        ("SPC u" undo-tree-visualize))
;;  :bind (:map undo-tree-visualizer-mode-map
;;              ("h" . undo-tree-visualize-switch-branch-left)
;;              ("j" . undo-tree-visualize-redo)
;;              ("k" . undo-tree-visualize-undo)
;;              ("l" . undo-tree-visualize-switch-branch-right)))
