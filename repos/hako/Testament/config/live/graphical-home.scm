;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (guix gexp)
             (gnu services)
             (rosenthal services desktop)
             (gnu home)
             (gnu home services fontutils)
             (gnu home services shells)
             (gnu home services shepherd)
             (gnu packages fcitx5)
             (gnu packages gnome-xyz))


;;;
;;; Home environment
;;;

(home-environment
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

          ;; Font config.
          (simple-service 'extend-fontconfig home-fontconfig-service-type
            (let ((sans  "Noto Sans")
                  (serif "Noto Serif")
                  (mono  "Victor Mono")
                  (emoji "Noto Color Emoji"))
              `((alias
                 (family "sans-serif")
                 (prefer
                  (family ,sans)
                  (family ,emoji)))
                (alias
                 (family "serif")
                 (prefer
                  (family ,serif)
                  (family ,emoji)))
                (alias
                 (family "monospace")
                 (prefer
                  (family ,mono)
                  (family ,emoji)))

                ,@(map (lambda (name)
                         `(alias
                           (family ,name)
                           (prefer
                            (family ,sans)
                            (family "sans-serif"))))
                       '("BlinkMacSystemFont"
                         "-apple-system"
                         "system-ui"
                         "ui-sans-serif"))
                (alias
                 (family "ui-serif")
                 (prefer
                  (family ,serif)
                  (family "serif")))
                (alias
                 (family "ui-monospace")
                 (prefer
                  (family ,mono)
                  (family "monospace"))))))

          %rosenthal-desktop-home-services)))
