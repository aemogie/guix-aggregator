;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (guix gexp)
             (gnu services)
             (rosenthal services desktop)
             (gnu home)
             (gnu home services fontutils)
             (gnu home services shells)
             (gnu home services shepherd)
             (gnu packages)
             (gnu packages fcitx5)
             (gnu packages gnome-xyz)
             (gnu packages shells))


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

               "emacs-corfu"
               "emacs-doom-modeline"
               "emacs-edit-indirect"    ;for emacs-markdown-mode
               "emacs-envrc"
               "emacs-evil"
               "emacs-fish-mode"
               "emacs-flycheck"
               "emacs-flycheck-guile"
               "emacs-forge"
               "emacs-gcmh"
               "emacs-geiser"
               "emacs-geiser-guile"
               "emacs-helpful"
               "emacs-hl-todo"
               "emacs-json-mode"
               "emacs-macrostep"
               "emacs-macrostep-geiser"
               "emacs-magit"
               "emacs-markdown-mode"
               "emacs-mwim"
               "emacs-no-littering"
               "emacs-orderless"
               "emacs-puni"
               "emacs-rainbow-delimiters"
               "emacs-vertico"

               ;; Fonts.
               "font-adobe-source-serif"
               "font-google-noto"
               "font-google-noto-emoji"
               "font-nerd-symbols"
               "font-sarasa-gothic"
               "font-victor-mono")))
  (services
   (cons* (service home-fish-service-type)

          ;; XXX: Wait for proper WezTerm window size.
          ;; Load fish so that other terminals will start faster.
          (simple-service 'workaround home-shepherd-service-type
            (list (shepherd-service
                    (provision '(workaround))
                    (one-shot? #t)
                    (start
                     #~(make-forkexec-constructor
                        '("wezterm" "start" "--always-new-process" "--"
                          "fish" "--login" "-c"
                          "sleep 1 && herd start installer"))))))

          (simple-service 'installer home-shepherd-service-type
            (list (shepherd-service
                    (provision '(installer))
                    (auto-start? #f)
                    (one-shot? #t)
                    (start
                     #~(make-forkexec-constructor
                        '("wezterm" "start" "--always-new-process" "--"
                          "sudo" "guix-system-installer"))))))

          ;; Default cursor theme.
          (service home-theme-service-type
            (home-theme-configuration
              (packages (list qogir-icon-theme))
              (icon-theme "Qogir")
              (cursor-theme "Qogir")))

          ;; Input method.
          (service home-fcitx5-service-type
            (home-fcitx5-configuration
              (gtk-im-module? #t)
              (qt-im-module? #t)
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
