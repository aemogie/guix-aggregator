;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (gnu)
             (rosenthal services desktop)
             (gnu home)
             (gnu home services shells)
             (gnu home services shepherd)
             (gnu packages fcitx5)
             (gnu packages gnome-xyz))


;;;
;;; Home environment
;;;

(home-environment
  (packages (specifications->packages
             '(;; Web browser.
               "librewolf"
               "ublock-origin-icecat"

               ;; Text editors, see also `%rosenthal-skeletons'.
               "emacs-pgtk"
               "neovim"

               "emacs-no-littering"
               ;; Guile & Guix hacking.
               "emacs-flycheck"
               "emacs-flycheck-guile"
               "emacs-geiser"
               "emacs-geiser-guile"
               "emacs-guix"
               "emacs-macrostep"
               "emacs-macrostep-geiser"
               "emacs-parinfer-rust-mode"
               ;; Completion.
               "emacs-corfu"
               "emacs-orderless"
               "emacs-vertico"
               ;; Vim-like editing experience.
               "emacs-evil"
               "emacs-evil-collection"
               "emacs-goto-chg"           ;dependency of emacs-evil
               ;; Enhancements to the default interface.
               "emacs-eldoc-box"
               "emacs-helpful"
               "emacs-mwim"
               ;; Theming.
               "emacs-doom-modeline"
               ;; Other useful packages.
               "emacs-magit"

               ;; Fonts.
               "font-adobe-source-serif"
               "font-google-noto"
               "font-google-noto-emoji"
               "font-nerd-symbols"
               "font-sarasa-gothic"
               "font-victor-mono")))
  (services
   (cons* (service home-fish-service-type)

          (service home-graphical-session-service-type
            (home-graphical-session-configuration
             (timeout 600)
             (wayland? #t)
             (x11? #t)))

          ;; XXX: Wait for proper WezTerm window size.
          ;; Load fish so that other terminals will start faster.
          (simple-service 'workaround home-shepherd-service-type
            (list (shepherd-service
                    (provision '(workaround))
                    (requirement '(graphical-session x11-display))
                    (one-shot? #t)
                    (start
                     #~(lambda args
                         ((make-forkexec-constructor
                           '("wezterm" "start" "--always-new-process" "--"
                             "fish" "--login" "-c"
                             "sleep 1 && herd start installer")
                           #:environment-variables (environ))
                          args))))))
          (simple-service 'installer home-shepherd-service-type
            (list (shepherd-service
                    (provision '(installer))
                    (auto-start? #f)
                    (one-shot? #t)
                    (start
                     #~(lambda args
                         ((make-forkexec-constructor
                           '("wezterm" "start" "--always-new-process" "--"
                             "sudo" "guix-system-installer")
                           #:environment-variables (environ))
                          args))))))
          ;; Default cursor theme.
          (service home-theme-service-type
            (home-theme-configuration
              (packages (list qogir-icon-theme))
              (icon-theme "Qogir")
              (cursor-theme "Qogir")))

          ;; Input method.
          (service home-fcitx5-service-type
            (home-fcitx5-configuration
              (wayland-frontend? #t)
              (themes (list fcitx5-material-color-theme))
              (input-method-editors
               (list fcitx5-anthy
                     fcitx5-chewing
                     fcitx5-chinese-addons
                     fcitx5-hangul
                     fcitx5-rime
                     fcitx5-skk
                     fcitx5-unikey))))

          %rosenthal-desktop-home-services)))
