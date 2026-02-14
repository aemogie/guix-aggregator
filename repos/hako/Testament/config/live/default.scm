;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (guix gexp)
             (guix utils)
             (gnu system)
             (gnu system install)
             (gnu system privilege)
             (gnu system shadow)
             (gnu services)
             (gnu services base)
             (gnu services dbus)
             (gnu services desktop)
             (gnu services guix)
             (gnu services networking)
             (gnu services pm)
             (rosenthal services base)
             (rosenthal services desktop)
             (rosenthal services shellutils)
             (gnu home)
             (gnu home services fontutils)
             (gnu home services shells)
             (gnu home services shepherd)
             (gnu packages)
             (gnu packages fcitx5)
             (gnu packages gnome-xyz)
             (gnu packages libusb)
             (gnu packages linux)
             (gnu packages nfs)
             (gnu packages shells))

(define %installation-os
  (make-installation-os
   #:efi-only?
   (string=? (or (getenv "SYSTEM")
                 (%current-system))
             "aarch64-linux")))

(define %minimal-os
  (load "minimal.scm"))


;;;
;;; Home environment
;;;

(define %home
  (home-environment
    (services
     (cons* (service home-fish-service-type)
            (service home-fish-plugin-atuin-service-type)
            (service home-fish-plugin-direnv-service-type)
            (service home-fish-plugin-zoxide-service-type)

            ;; XXX: Wait for proper WezTerm window size.
            ;; Load fish so that other terminals will start faster.
            (simple-service 'installation home-shepherd-service-type
              (list (shepherd-service
                      (provision '(installation))
                      (one-shot? #t)
                      (start
                       #~(make-forkexec-constructor
                          '("wezterm" "start" "--"
                            "fish" "--login" "-c"
                            "sleep 1 && sudo guix-system-installer"))))))

            (simple-service 'installation-docs-local home-shepherd-service-type
              (list (shepherd-service
                      (provision '(installation-docs-local))
                      (one-shot? #t)
                      (start
                       #~(make-forkexec-constructor
                          '("emacs" "--load" "info"
                            "--eval" "(info \"(guix) System Installation\")"))))))

            (simple-service 'installation-docs-online home-shepherd-service-type
              (list (shepherd-service
                      (provision '(installation-docs-online))
                      (one-shot? #t)
                      (start
                       #~(make-forkexec-constructor
                          '("librewolf" "https://guix.gnu.org/manual/devel/"))))))

            (service home-noctalia-shell-service-type)
            (service home-polkit-gnome-service-type)
            (service home-swaybg-service-type)

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
            (simple-service 'extra-fontconfig
                home-fontconfig-service-type
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

            %rosenthal-desktop-home-services))))


;;;
;;; Operating system
;;;

(operating-system
  (inherit %minimal-os)
  (users
   (cons* (user-account
            (name "live")
            (password (crypt "live" "$6$abc"))
            (group "users")
            (supplementary-groups '("audio" "video" "wheel"))
            (shell (file-append fish "/bin/fish")))
          (operating-system-users %minimal-os)))

  (skeletons %rosenthal-skeletons)

  (packages
   (append (specifications->packages
            '(;; CLI utilities.
              "curl"
              "fd"
              "git"
              "gnupg"
              "mosh"
              "ncurses"
              "ripgrep"
              "rsync"
              "unzip"

              ;; Desktop, see also `%rosenthal-skeletons'.
              "niri"
              "wl-clipboard"
              "xdg-desktop-portal-gnome"
              "xdg-desktop-portal-gtk"
              "xdg-utils"
              "imv"                ;image viewer
              "light"              ;backlight control
              "mesa"               ;search paths for graphics driver
              "pavucontrol"        ;sound control
              "playerctl"          ;media control
              "wezterm"            ;terminal emulator
              "wireplumber"        ;PipeWire session manager
              "xwayland-satellite" ;rootless XWayland support

              ;; File manager.
              "exo"
              "file-roller"
              "thunar"
              "thunar-archive-plugin"
              "thunar-media-tags-plugin"
              "thunar-volman"
              "tumbler"

              ;; Web browser.
              "librewolf"
              "ublock-origin-icecat"

              ;; Text editors, see also `%rosenthal-skeletons'.
              "emacs-pgtk"
              "neovim"

              "emacs-corfu"
              "emacs-daemons"
              "emacs-doom-modeline"
              "emacs-envrc"
              "emacs-flycheck"
              "emacs-flycheck-guile"
              "emacs-forge"
              "emacs-gcmh"
              "emacs-geiser"
              "emacs-geiser-guile"
              "emacs-helpful"
              "emacs-hl-todo"
              "emacs-macrostep"
              "emacs-macrostep-geiser"
              "emacs-magit"
              "emacs-mwim"
              "emacs-no-littering"
              "emacs-orderless"
              "emacs-puni"
              "emacs-rainbow-delimiters"
              "emacs-vertico"

              ;; Fonts, see also `home-fontconfig-service-type'.
              "font-adobe-source-serif"
              "font-google-noto"
              "font-google-noto-emoji"
              "font-nerd-symbols"
              "font-sarasa-gothic"
              "font-victor-mono"
              ))
           (load "scripts.scm")
           (operating-system-packages %installation-os)))

  (services
   (cons* (service guix-home-service-type
            `(("live" ,%home)))

          ;; tty1: installer, tty2: documentation, tty3~6: shell
          ;; tty7: tuigreet -> niri
          (service greetd-service-type
            (greetd-configuration
              (greeter-supplementary-groups '("video" "input"))
              (terminals
               (list (greetd-terminal-configuration
                       (terminal-vt "7")
                       (terminal-switch #f)
                       (initial-session-user "live")
                       (initial-session-command "dbus-run-session niri --session")
                       (default-session-command (greetd-tuigreet-session)))))))

          ;; From `%rosenthal-desktop-services/base'.
          (service bluetooth-service-type
            (bluetooth-configuration
              (auto-enable? #t)))
          (service gvfs-service-type)
          (service power-profiles-daemon-service-type)
          (simple-service 'backlight udev-service-type (list light))

          ;; From `%desktop-services'.
          (simple-service 'mtp udev-service-type (list libmtp))
          polkit-wheel-service
          (simple-service 'mount-setuid-helpers privileged-program-service-type
            (map file-like->setuid-program
                 (list (file-append nfs-utils "/sbin/mount.nfs")
                       (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))
          (service udisks-service-type)
          (service polkit-service-type)
          (service elogind-service-type)
          (service ntp-service-type)
          (service x11-socket-directory-service-type)

          (operating-system-user-services %minimal-os)))

  (sudoers-file
   (plain-file "sudoers"
     (string-append
      (plain-file-content (operating-system-sudoers-file %installation-os))
      "live ALL = NOPASSWD: ALL\n"))))
