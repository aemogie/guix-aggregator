(define-module (yggdrasil modules emacs)
  #:use-module (gnu home services)
  #:use-module ((gnu packages compression) #:select (unzip))
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module ((gnu packages mail) #:select (emacs-notmuch msmtp))
  #:use-module ((gnu packages rust-apps) #:select (ripgrep))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((rde home services emacs)
                #:select (home-emacs-service-type
                          home-emacs-configuration))
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(use-modules (gnu packages tree-sitter)
             (guix utils)
             (guix packages))

(use-modules (guix build-system emacs)
             (guix git-download)
             ((guix licenses) #:prefix license:))

(define emacs-yaml-pro
  (let ((commit "9961335fd1b32ec1684a4d4c46b47785aa7e50f7")
        (revision "0"))
    (package
      (name "emacs-yaml-pro")
      (version (git-version "1.1.0" revision commit))
      (home-page "https://github.com/zkry/yaml-pro")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "07gp6zi19kvfvpgpv9qz0da2rs7hnc6p0q7kngxa5v0iv888r69x"))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-yaml))
      (synopsis "")
      (description "")
      (license license:gpl3+))))

(define tree-sitter-yaml
  (let ((ts-yaml
         ((@@ (gnu packages tree-sitter) tree-sitter-grammar)
          "yaml" "YAML"
          "1bimf5fq85wn8dwlk665w15n2bj37fma5rsfxrph3i9yb0lvzi3q"
          "0.5.0"
          #:repository-url "https://github.com/ikatyang/tree-sitter-yaml")))
    (package/inherit ts-yaml
      (arguments
       (substitute-keyword-arguments (package-arguments ts-yaml)
         ((#:tests? _ #f) #f))))))

(define emacs-git-email-fork
  (let ((commit "c0211fa61289fe799cb9c83a8478736fd977793f")
        (revision "0"))
    (package/inherit emacs-git-email
      (name "emacs-git-email")
      (version (git-version "0.2.0" revision commit))
      (home-page "https://codeberg.org/mekeor/git-email")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1czrcyqpdmgmz5mzsjrxg81gz278kglkq0f32l19g1gnrivc490w")))))))

(define packages
  (list emacs-gcmh
        emacs-orderless
        emacs-eros
        emacs-minions
        emacs-async
        emacs-marginalia
        emacs-nov-el
        emacs-pdf-tools
        #;emacs-eglot
        emacs-restclient
        emacs-macrostep
        emacs-consult
        emacs-corfu
        emacs-project
        emacs-clojure-mode
        emacs-cider
        emacs-jarchive
        emacs-forge
        emacs-magit
        emacs-magit-todos
        emacs-envrc
        emacs-inheritenv
        emacs-embark
        emacs-sly
        emacs-paredit
        emacs-notmuch
        emacs-vertico
        emacs-org-modern
        emacs-git-email-fork
        emacs-org-roam
        emacs-avy
        emacs-link-hint
        emacs-telega
        emacs-pcmpl-args
        emacs-cape
        emacs-ef-themes
        emacs-arei
        emacs-eat
        emacs-jsonnet-mode
        emacs-docker
        emacs-yaml-pro
        emacs-transmission
        emacs-rg
        emacs-dart-mode
        (@ (gnu packages ocaml) emacs-tuareg)))

(define (home-services)
  (list
   (simple-service
    'tree-sitter-grammars
    home-profile-service-type
    (list tree-sitter-html
          tree-sitter-css
          tree-sitter-bash
          tree-sitter-dockerfile
          tree-sitter-json
          tree-sitter-yaml
          tree-sitter-java
          tree-sitter-javascript
          tree-sitter-go
          tree-sitter-gomod))
   (simple-service
    'sway-emacs-config
    home-sway-service-type
    `((assign "[app_id=\"emacs\"]" EMACS)))
   ;; TODO: move to ripgrep module
   (simple-service
    'ripgrep-packages
    home-profile-service-type
    (list ripgrep))
   (service
    home-emacs-service-type
    (home-emacs-configuration
     (emacs-servers '())
     (emacs emacs-pgtk)
     (elisp-packages packages)
     (early-init-el
      `( ,#~";; -*- lexical-binding: t; -*-"
         (let ((old-threshold gc-cons-threshold))
           (add-hook 'emacs-startup-hook
                     (lambda ()
                       (setq gc-cons-threshold old-threshold)))
           (setq gc-cons-threshold most-positive-fixnum))
         (setq native-comp-jit-compilation t
               package-enable-at-startup nil
               warning-minimum-level :emergency
               warning-suppress-types '((comp))
               native-comp-async-report-warnings-errors nil)
         (add-hook 'emacs-startup-hook
                   (lambda ()
                     (message "Emacs ready in %s with %d garbage collections."
                              (emacs-init-time)
                              gcs-done)))))
     (init-el
      `( ,#~";; -*- lexical-binding: t; -*-"
         #;(let ((context (lambda () (format "\nload-file-name: %s" load-file-name))))
         (trace-function 'load nil context)
         (trace-function 'require nil context))
         (require 'map)
         (eval-when-compile (require 'pcase))

         (gcmh-mode 1)

         (setopt custom-file (expand-file-name "custom.el" user-emacs-directory))
         (load-file custom-file)

         (setopt user-full-name "Nikita Domnitskii")
         (setopt user-mail-address "nikita@domnitskii.me")
         (setopt save-interprogram-paste-before-kill t)

         (setopt backup-by-copying t)
         (setopt version-control t)
         (setopt vc-make-backup-files t)
         (setopt delete-old-versions t)
         (setopt backup-directory-alist
                 (list
                  (cons "." (concat (getenv "XDG_CACHE_HOME") "/emacs/backup"))))

         (set-face-attribute 'default nil :family "Iosevka" :weight 'light :height 200)
         (set-face-attribute 'variable-pitch nil :family "Iosevka Etoile")
         (set-fontset-font t 'emoji (font-spec :family "Noto Color Emoji" :size 15.0))

         (keymap-global-unset "C-z")
         (keymap-set ctl-x-map "s" search-map)
         (keymap-set ctl-x-map "S" 'save-some-buffers)
         (keymap-set ctl-x-map "k" 'kill-current-buffer)
         (keymap-set ctl-x-map "C-b" 'switch-to-buffer)
         (keymap-global-set "M-j" 'avy-goto-char-timer)
         (keymap-global-set "<remap> <upcase-word>" 'upcase-dwim)
         (keymap-global-set "<remap> <downcase-word>" 'downcase-dwim)
         (keymap-global-set "<remap> <capitalize-word>" 'capitalize-dwim)

         (setopt link-hint-message nil)
         (keymap-global-set "M-z" 'link-hint-open-link)

         (setopt inhibit-startup-screen t)
         (setopt inhibit-startup-echo-area-message t)
         (setopt initial-scratch-message nil)

         (setopt reb-re-syntax 'rx)
         (setopt calendar-week-start-day 1)
         (setopt dabbrev-case-replace nil)

         (setopt mode-line-compact t)

         (add-hook 'prog-mode-hook 'flymake-mode)

         (setopt minions-prominent-modes '(flymake-mode
                                           arei-mode))
         (add-hook 'after-init-hook 'minions-mode)

         (setopt history-delete-duplicates t)
         (setopt history-length t)
         (setopt savehist-file (concat (getenv "XDG_CACHE_HOME") "/emacs/savehist"))
         (setopt savehist-additional-variables '(kill-ring))
         (add-hook 'after-init-hook 'savehist-mode)

         (setopt kill-whole-line t)
         (setopt eval-expression-print-level nil)
         (setopt eval-expression-print-length nil)
         (setopt indent-tabs-mode nil)

         (add-hook 'after-init-hook 'delete-selection-mode)

         (setopt minibuffer-prompt-properties
                 '( read-only t
                    cursor-intangible t
                    face minibuffer-prompt))
         (add-hook 'minibuffer-setup-hook 'cursor-intangible-mode)

         (setopt enable-recursive-minibuffers t)
         (setopt read-file-name-completion-ignore-case t)
         (setopt read-buffer-completion-ignore-case t)
         (setq completion-ignore-case t)

         (eval-when-compile (require 'orderless))
         (orderless-define-completion-style kreved--orderless
           (orderless-matching-styles '(orderless-initialism
                                        orderless-literal
                                        orderless-regexp)))
         (setopt completion-styles '(orderless basic))
         (setq completion-category-defaults nil)
         (setopt completion-category-overrides
                 '((file (styles partial-completion))
                   (command (styles kreved--orderless))
                   (variable (styles kreved--orderless))
                   (symbol (styles kreved--orderless))))

         (keymap-global-set "C-'" 'vertico-repeat)
         (setopt vertico-cycle t)
         (setopt vertico-multiform-commands '((telega-msg-add-reaction flat)))
         (setopt vertico-multiform-categories '((embark-keybinding grid)))
         (add-hook 'after-init-hook 'vertico-mode)
         (add-hook 'minibuffer-setup-hook 'vertico-repeat-save)
         (add-hook 'rfn-eshadow-update-overlay-hook 'vertico-directory-tidy)
         (with-eval-after-load 'vertico
           (run-with-idle-timer 0.1 nil 'vertico-multiform-mode t))

         (with-eval-after-load 'vertico
           (keymap-set vertico-map "RET" 'vertico-directory-enter)
           (keymap-set vertico-map "DEL" 'vertico-directory-delete-char)
           (keymap-set vertico-map "M-DEL" 'vertico-directory-delete-word))

         #;(add-hook 'after-init-hook 'marginalia-mode)

         (setopt tab-always-indent 'complete)
         (setopt corfu-preselect 'first)
         (setopt corfu-cycle t)
         (setopt corfu-preview-current nil)
         (setopt corfu-echo-delay 0)
         (setopt corfu-count 5)
         (setopt corfu-min-width 70)
         (setopt corfu-max-width 70)
         (setopt corfu-popupinfo-delay 0)
         (setopt corfu-popupinfo-direction '(vertical))
         (setopt corfu-popupinfo-min-width 70)
         (setopt corfu-popupinfo-max-width 70)
         (with-eval-after-load 'corfu (run-with-idle-timer 0.1 nil 'corfu-echo-mode t))
         (with-eval-after-load 'corfu (run-with-idle-timer 0.1 nil 'corfu-popupinfo-mode t))
         (defun kreved--corfu-enable-in-minibuffer ()
           (when (local-variable-p 'completion-at-point-functions)
             (setq-local corfu-echo-delay nil
                         corfu-popupinfo-delay nil)
             (corfu-mode 1)))
         (add-hook 'minibuffer-setup-hook 'kreved--corfu-enable-in-minibuffer)
         (add-hook 'after-init-hook 'global-corfu-mode)

         (keymap-global-set "M-y" 'consult-yank-pop)

         (keymap-global-set "<remap> <switch-to-buffer>" 'consult-buffer)
         (keymap-global-set "<remap> <switch-to-buffer-other-window>" 'consult-buffer-other-window)

         (keymap-global-set "<remap> <Info-search>" 'consult-info)

         (keymap-set goto-map "i" 'consult-imenu)
         (keymap-set goto-map "o" 'consult-outline)
         (keymap-set goto-map "e" 'consult-flymake)
         (keymap-set goto-map "l" 'consult-line)

         (keymap-set help-map "M" 'consult-man)

         (with-eval-after-load 'em-hist
           (keymap-set eshell-hist-mode-map "<remap> <eshell-previous-matching-input>" 'consult-history))
         (with-eval-after-load 'vertico
           (keymap-set vertico-map "<remap> <previous-matching-history-element>" 'consult-history))

         (with-eval-after-load 'paredit
           (keymap-unset paredit-mode-map "\\")
           (keymap-unset paredit-mode-map ";")
           (keymap-unset paredit-mode-map "M-q")
           (keymap-set paredit-mode-map "M-[" 'paredit-wrap-square)
           (keymap-set paredit-mode-map "M-]" 'paredit-wrap-curly))
         (dolist (hook '(emacs-lisp-mode-hook
                         scheme-mode-hook
                         clojure-mode-hook))
           (add-hook hook 'paredit-mode))

         (setopt xref-show-definitions-function 'consult-xref)
         (setopt xref-show-xrefs-function 'consult-xref)
         (add-hook 'xref-after-return-hook 'recenter)

         (setopt embark-help-key "?")
         (setopt prefix-help-command 'embark-prefix-help-command)
         (setopt embark-indicators '(embark-highlight-indicator
                                     embark-minimal-indicator))
         (setopt embark-quit-after-action '((kill-buffer . nil)
                                            (t . t)))
         (keymap-global-set "C-." 'embark-act)
         (keymap-global-set "M-." 'embark-dwim)
         (keymap-global-set "<remap> <describe-bindings>" 'embark-bindings)
         (with-eval-after-load 'embark
           (keymap-set embark-expression-map "RET" 'eval-expression)
           (keymap-set embark-expression-map "e" 'eval-expression)
           (keymap-set embark-flymake-map "RET" 'eldoc-print-current-symbol-info))

         (setopt cursor-type 'bar)
         (blink-cursor-mode 0)
         (menu-bar-mode 0)
         (tool-bar-mode 0)
         (scroll-bar-mode 0)
         (fringe-mode 16)

         (show-paren-mode 0)
         (dolist (hook '(conf-mode-hook prog-mode-hook))
           (add-hook hook 'show-paren-local-mode))

         (setopt fill-column 72)
         (dolist (hook '(conf-mode-hook prog-mode-hook text-mode-hook))
           (add-hook hook 'display-fill-column-indicator-mode))

         (setopt ef-themes-variable-pitch-ui t)
         (setopt ef-themes-to-toggle '(ef-deuteranopia-light
                                       ef-deuteranopia-dark))
         (defun kreved--customize-theme ()
           (ef-themes-with-colors
            (custom-set-faces
             `(vertical-border ((,c :foreground ,bg-main)))
             `(mode-line ((,c :box (:line-width 4
                                    :color ,bg-mode-line))))
             `(mode-line-inactive ((,c :box (:line-width 4
                                             :color ,bg-alt)))))))
         (add-hook 'ef-themes-post-load-hook 'kreved--customize-theme)
         (ef-themes-select 'ef-deuteranopia-light)

         (setopt use-short-answers t)
         (setopt use-dialog-box nil)
         (setopt use-file-dialog nil)
         (setopt use-system-tooltips t)

         (setopt require-final-newline t)
         (setopt confirm-kill-emacs 'yes-or-no-p)
         (setopt confirm-nonexistent-file-or-buffer nil)
         (add-hook 'before-save-hook 'delete-trailing-whitespace)

         (dolist (hook '(conf-mode-hook prog-mode-hook))
           (add-hook hook 'hs-minor-mode))

         (setopt telega-completing-read-function 'completing-read)
         (setopt telega-symbol-reply "↩️")
         (setopt telega-symbol-pin "📍")
         (setopt telega-chat-show-deleted-messages-for '(not saved-messages))
         (setopt telega-directory (concat (getenv "XDG_CACHE_HOME") "/telega"))
         (setopt telega-webpage-preview-description-limit 0)
         (setopt telega-chat-send-link-preview-options '(:is_disabled t))
         (setopt telega-emoji-use-images nil)
         (setopt telega-msg-rainbow-title nil)
         (add-hook 'telega-ready-hook 'telega-notifications-mode)
         (add-hook 'telega-root-mode-hook 'hl-line-mode)
         (add-hook 'telega-chat-update-hook
                   (lambda (_)
                     (with-telega-root-buffer (hl-line-highlight))))

         (add-hook 'emacs-lisp-mode-hook 'eros-mode)
         (with-eval-after-load 'elisp-mode
           (keymap-set emacs-lisp-mode-map "C-c C-c" 'eval-defun)
           (keymap-set emacs-lisp-mode-map "C-c C-e" 'eval-last-sexp)
           (keymap-set emacs-lisp-mode-map "C-c e" 'eval-last-sexp)
           (keymap-set emacs-lisp-mode-map "C-c C-b" 'eval-buffer)
           (keymap-set emacs-lisp-mode-map "C-c b" 'eval-buffer)
           (keymap-set emacs-lisp-mode-map "C-c RET" 'macrostep-expand))

         (dolist (capf-fn '(cape-file cape-dabbrev))
           (add-to-list 'completion-at-point-functions capf-fn))

         (setopt eglot-sync-connect nil)
         (setopt eglot-connect-timeout nil)
         (setopt eglot-extend-to-xref t)
         (setopt eglot-confirm-server-initiated-edits nil)
         (setopt eglot-events-buffer-config '(:size 0 :format full))
         (dolist (hook '(clojure-mode-hook))
           (add-hook hook 'eglot-ensure))

         (setopt max-mini-window-height 1)
         (setopt eldoc-echo-area-use-multiline-p nil)
         (setopt eldoc-idle-delay 0.5)
         (setopt eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
         (setopt eldoc-echo-area-display-truncation-message nil)
         (with-eval-after-load 'paredit
           (eldoc-add-command-completions "paredit-"))
         (with-eval-after-load 'avy
           (eldoc-add-command-completions "avy-"))

         (setopt cider-prompt-for-symbol nil)
         (setopt cider-use-overlays t)
         (setopt cider-save-file-on-load nil)
         (setopt cider-eval-spinner-type 'half-circle)
         (setopt cider-merge-sessions 'project)
         (setopt cider-repl-pop-to-buffer-on-connect nil)
         (setopt cider-repl-display-in-current-window nil)
         (setopt cider-font-lock-dynamically nil)
         (setopt cider-font-lock-reader-conditionals nil)
         (setopt cider-use-xref t)
         (setopt cider-eldoc-display-context-dependent-info t)
         (setopt cider-test-fail-fast nil)
         (setopt cider-print-fn 'pprint)
         (setopt cider-print-options '(("right-margin" 10) ("pretty" "true")))
         (with-eval-after-load 'cider
           (remove-hook 'cider-connected-hook 'cider--maybe-inspire-on-connect))
         (with-eval-after-load 'cider-repl
           (keymap-unset cider-repl-mode-map "C-c C-b")
           (keymap-set cider-repl-mode-map "C-c C-k" 'cider-interrupt)
           (advice-add 'cider-repl--insert-banner :override 'ignore))
         (with-eval-after-load 'cider-mode
           (keymap-set cider-mode-map "C-c e" 'cider-eval-last-sexp)
           (keymap-set cider-mode-map "C-c b" 'cider-eval-buffer)
           (keymap-set cider-mode-map "C-c C-b" 'cider-eval-buffer)
           (keymap-set cider-mode-map "C-c k" 'cider-interrupt)
           (keymap-set cider-mode-map "C-c p" 'cider-pprint-eval-last-sexp))

         (setopt archive-zip-extract
                 (list ,(file-append unzip "/bin/unzip") "-qq" "-c"))
         (add-hook 'after-init-hook 'jarchive-setup)

         (with-eval-after-load 'clojure-mode
           (keymap-set clojure-refactor-map "u" 'clojure-unwind-all)
           (keymap-set clojure-refactor-map "U" 'clojure-unwind))

         (with-eval-after-load 'arei
           (keymap-set arei-mode-map "C-c e" 'arei-evaluate-last-sexp)
           (keymap-set arei-mode-map "C-c C-b" 'arei-evaluate-buffer)
           (keymap-set arei-mode-map "C-c b" 'arei-evaluate-buffer)
           (keymap-set arei-mode-map "C-c k" 'arei-interrupt-evaluation))

         (add-hook 'after-init-hook 'envrc-global-mode)

         (keymap-global-set "C-z" 'window-toggle-side-windows)
         (setopt switch-to-buffer-obey-display-actions t)
         (setopt switch-to-buffer-in-dedicated-window 'pop)
         (setopt split-height-threshold 80)
         (setopt split-width-threshold 125)
         (setopt window-sides-slots '(0 0 2 2))
         (setopt display-buffer-alist
                 `(((or ,(rx ?* "Async Shell Command" ?*
                             (opt ?< (+ digit) ?>)))
                    display-buffer-no-window)

                   ((derived-mode . image-mode)
                    display-buffer-same-window)

                   ((or (major-mode . occur-mode)
                        (major-mode . rg-mode))
                    (display-buffer-reuse-window
                     display-buffer-at-bottom)
                    (inhibit-same-window . t)
                    (window-height . fit-window-to-buffer))

                   ((or ,(rx ?*
                             (opt (+ (not space)))
                             "eshell"
                             ?*
                             (opt ?< (+ digit) ?>)))
                    (display-buffer-reuse-mode-window
                     display-buffer-in-side-window)
                    (side . bottom)
                    (slot . -1)
                    (window-height . 0.6))

                   ((or (major-mode . compilation-mode))
                    (display-buffer-reuse-mode-window
                     display-buffer-in-side-window)
                    (side . bottom)
                    (slot . 1)
                    (window-height . 0.6))

                   ((or (major-mode . telega-chat-mode))
                    (display-buffer-reuse-mode-window
                     display-buffer-in-side-window)
                    (dedicated . nil)
                    (side . right)
                    (slot . -1)
                    (window-width . 0.6))

                   ((or ,(rx ?* "Telegram Sticker Set" ?*))
                    (display-buffer-reuse-mode-window
                     display-buffer-in-side-window)
                    (side . right)
                    (slot . 1)
                    (window-width . 0.6))

                   ((or (major-mode . cider-repl-mode)
                        (major-mode . arei-connection-mode))
                    (display-buffer-reuse-mode-window
                     display-buffer-in-side-window)
                    (side . right)
                    (slot . -1)
                    (window-width . 0.5))

                   ((or (derived-mode . help-mode)
                        (major-mode . cider-stacktrace-mode)
                        ,(rx ?* "cider-test-report" ?*))
                    (display-buffer-reuse-mode-window
                     display-buffer-in-side-window)
                    (side . right)
                    (slot . 1)
                    (window-width . 0.5))))

         (setopt compilation-scroll-output t)
         (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

         (with-eval-after-load 'repeat
           (defvar-keymap kreved--other-window-map "o" 'other-window)
           (put 'other-window 'repeat-map 'kreved--other-window-map))
         (add-hook 'after-init-hook 'repeat-mode)

         (setopt magit-diff-refine-hunk 'all)
         (setopt magit-module-sections-nested nil)
         (setopt magit-save-repository-buffers nil)
         (with-eval-after-load 'magit-mode
           (setopt magit-display-buffer-function
                   'magit-display-buffer-fullframe-status-v1))

         (setopt forge-database-file
                 (concat (getenv "XDG_CACHE_HOME") "/emacs/forge.sqlite"))
         (setopt forge-add-default-sections nil)

         (setopt wdired-allow-to-change-permissions t)
         (setopt dired-omit-files (rx line-start ?. (* nonl)))
         (setopt dired-recursive-copies 'always)
         (setopt dired-recursive-deletes 'always)
         (setopt dired-dwim-target t)
         (setopt dired-auto-revert-buffer t)
         (setopt dired-create-destination-dirs 'ask)
         (setopt dired-vc-rename-file t)
         (add-hook 'dired-mode-hook 'dired-omit-mode)
         (add-hook 'dired-mode-hook 'dired-async-mode)
         (add-hook 'dired-mode-hook 'hl-line-mode)
         (with-eval-after-load 'dired
           (setopt dired-listing-switches "-alh --group-directories-first")
           (keymap-set dired-mode-map "e" 'wdired-change-to-wdired-mode))

         (setopt project-vc-extra-root-markers '("deps.edn"
                                                 "bb.edn"
                                                 "pubspec.yaml"
                                                 "go.mod"
                                                 "dune-project"))
         (with-eval-after-load 'project
           (keymap-substitute project-prefix-map 'project-find-regexp 'consult-ripgrep)
           (keymap-set project-prefix-map "m" 'magit-project-status)
           (map-delete project-switch-commands 'project-find-regexp)
           (setf (map-elt project-switch-commands 'consult-ripgrep) '("Find regexp"))
           (map-delete project-switch-commands 'project-vc-dir)
           (setf (map-elt project-switch-commands 'magit-project-status) '("Magit")))

         (setopt org-roam-directory (expand-file-name "~/docs/roam"))
         (setopt org-roam-db-location (concat (getenv "XDG_CACHE_HOME") "/emacs/roam.db"))
         (setopt org-edit-src-content-indentation 0)
         (setopt org-src-tab-acts-natively t)
         (setopt org-adapt-indentation nil)
         (setopt org-directory (expand-file-name "~/docs/org"))
         (setopt org-confirm-babel-evaluate nil)
         (setopt org-modern-star nil)
         (setopt org-modern-list nil)
         (setopt org-modern-table nil)
         (add-hook 'org-mode-hook 'org-roam-db-autosync-mode)
         (add-hook 'org-mode-hook 'auto-fill-mode)
         (add-hook 'org-mode-hook 'org-modern-mode)
         (with-eval-after-load 'org
           (dolist (lang '(dot sql shell clojure scheme))
             (setf (map-elt org-babel-load-languages lang) t)))

         ;; TODO: move to (yggdrasil modules msmtp) maybe
         (setopt sendmail-program ,(file-append msmtp "/bin/msmtp"))
         (setopt message-send-mail-function 'message-send-mail-with-sendmail)
         (setopt message-signature "Best Regards,\nNikita Domnitskii")
         (setopt message-sendmail-f-is-evil t)
         (setopt message-sendmail-extra-arguments '("--read-envelope-from"))
         (setopt message-kill-buffer-on-exit t)
         ;; (setopt mml-secure-openpgp-sign-with-sender t)

         (with-eval-after-load 'notmuch
           (setf (map-elt notmuch-show-stash-mlarchive-link-alist "yhetil") "https://yhetil.org/"))

         (setopt auth-sources '())
         (add-hook 'after-init-hook 'auth-source-pass-enable)

         (setopt pdf-view-display-size 'fit-page)

         (run-with-idle-timer 0.1 nil (lambda ()
                                        (require 'pdf-tools)
                                        (pdf-tools-install-noverify)))

         (setopt nov-text-width fill-column)
         (setf (map-elt auto-mode-alist "\\.epub\\'") 'nov-mode)

         (add-hook 'eshell-load-hook 'eat-eshell-mode)
         (add-hook 'eshell-load-hook 'eat-eshell-visual-command-mode)
         (setopt eshell-visual-commands nil)
         (setopt eshell-smart-space-goes-to-end nil)
         (setopt eshell-modules-list
                 '( eshell-alias eshell-basic eshell-cmpl eshell-dirs
                    eshell-extpipe eshell-glob eshell-hist eshell-ls
                    eshell-pred eshell-prompt eshell-script eshell-unix
                    eshell-tramp))

         (with-eval-after-load 'tramp
           (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

         (setopt docker-show-messages nil)
         (keymap-set ctl-x-map "d" 'docker)
         (setopt docker-compose-command "docker compose")

         (setopt major-mode-remap-alist
                 `((js-json-mode      . json-ts-mode)
                   (css-mode          . css-ts-mode)
                   (shell-script-mode . bash-ts-mode)
                   (java-mode         . java-ts-mode)
                   (js-mode           . js-ts-mode)))

         (setopt js-indent-level 2)

         (setf (map-elt auto-mode-alist "\\.ya?ml\\'") 'yaml-ts-mode)
         (setf (map-elt auto-mode-alist (concat "[/\\]"
                                                "\\(?:Containerfile\\|Dockerfile\\)"
                                                "\\(?:\\.[^/\\]*\\)?\\'"))
               'dockerfile-ts-mode)
         (add-hook 'yaml-ts-mode-hook 'yaml-pro-ts-mode)

         (with-eval-after-load 'yaml-pro
           (keymap-set yaml-pro-ts-mode-map "C-M-n" 'yaml-pro-ts-next-subtree)
           (keymap-set yaml-pro-ts-mode-map "C-M-p" 'yaml-pro-ts-prev-subtree)
           (keymap-set yaml-pro-ts-mode-map "C-M-u" 'yaml-pro-ts-up-level)
           (keymap-set yaml-pro-ts-mode-map "C-M-d" 'yaml-pro-ts-down-level)
           (keymap-set yaml-pro-ts-mode-map "C-M-k" 'yaml-pro-ts-kill-subtree)
           (keymap-set yaml-pro-ts-mode-map "C-M-a" 'yaml-pro-ts-first-sibling)
           (keymap-set yaml-pro-ts-mode-map "C-M-e" 'yaml-pro-ts-last-sibling))

         (setf (map-elt auto-mode-alist "\\.go\\'") 'go-ts-mode)
         (setf (map-elt auto-mode-alist "/go\\.mod\\'") 'go-mod-ts-mode)

         (setf (map-elt auto-mode-alist "\\.ml\\'") 'tuareg-mode)))))))

;; https://karthinks.com/software/avy-can-do-anything/
;; https://karthinks.com/software/bridging-islands-in-emacs-1/
;; https://karthinks.com/software/fifteen-ways-to-use-embark/

;; Local Variables:
;; eval: (put 'with-eval-after-load 'scheme-indent-function 'defun)
;; eval: (put 'dolist 'scheme-indent-function 'defun)
;; eval: (put 'orderless-define-completion-style 'scheme-indent-function 'defun)
;; End:
