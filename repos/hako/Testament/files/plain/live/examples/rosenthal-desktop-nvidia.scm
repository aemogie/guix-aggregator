;; This is an operating system configuration template for a lightweight
;; "desktop" setup using niri window manager, with driver set up for NVIDIA
;; graphics card and applications configured.

;; Note where the `replace-mesa' procedure is used.

(use-modules (nonguix transformations)
             (rosenthal)
             (gnu home services fontutils)
             (gnu home services shells)
             (rosenthal services keyboard)
             (rosenthal services shellutils))

;; #f for QWERTY.
(define %my-keyboard-layout #f)

(define %my-user
  (user-account
    (name "alice")
    ;; Initial password: test
    ;; Generated using:
    ;; echo "test" | guix shell openssl -- openssl passwd -6 -stdin
    (password "$6$/KCO8Hq.mcvOg5IW$1r4sExgrmhKulz.0fhWGn3CYtLFYvcDPw8rJSxXET3O1uwuEZTcILcTQJ2eE8kDiBw/30.C7H3.xHISQo5CWj0")
    (comment "Bob's sister")
    (group "users")
    (supplementary-groups '("wheel" "audio" "video"))
    (shell (file-append (specification->package "fish") "/bin/fish"))))

(define %my-os
  (operating-system
    (host-name "antelope")
    (timezone "Asia/Hong_Kong")
    (locale "en_US.utf8")

    (keyboard-layout %my-keyboard-layout)

    ;; Use the UEFI variant of GRUB with the EFI System
    ;; Partition mounted on /boot/efi.
    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))
        (keyboard-layout %my-keyboard-layout)))

    ;; Assume the target root file system is labelled "my-root",
    ;; and the EFI System Partition has UUID 1234-ABCD.
    (file-systems
     (cons* (file-system
              (device (file-system-label "my-root"))
              (mount-point "/")
              (type "ext4"))
            (file-system
              (device (uuid "1234-ABCD" 'fat))
              (mount-point "/boot/efi")
              (type "vfat"))
            %base-file-systems))

    (users
     (cons* %my-user
            (user-account
              (inherit %root-account)
              ;; Don't initialize password for root.
              (password #f))
            %base-user-accounts))

    (skeletons %rosenthal-skeletons)

    (packages
     (replace-mesa
      (append (specifications->packages
               '("niri"
                 "wl-clipboard"

                 "foot"               ;terminal emulator
                 "imv"                ;image viewer
                 "light"              ;brightness control
                 "pavucontrol"        ;sound settings
                 "rofi"               ;application launcher
                 "wireplumber"        ;PipeWire session manager
                 "xwayland-satellite" ;rootless XWayland integration

                 ;; File manager.
                 "exo"
                 "file-roller"
                 "thunar"
                 "thunar-archive-plugin"
                 "thunar-media-tags-plugin"
                 "thunar-vcs-plugin"
                 "thunar-volman"
                 "unzip"

                 ;; Web browser.
                 "librewolf"
                 "adaptive-tab-bar-colour-icecat"
                 "ohmyech-icecat"
                 "ublock-origin-icecat"

                 ;; XDG Desktop Portal packages for niri.
                 "xdg-desktop-portal"
                 "xdg-desktop-portal-gtk"
                 "xdg-desktop-portal-gnome"

                 ;; Fonts
                 "font-adobe-source-serif"
                 "font-awesome"
                 "font-google-noto"
                 "font-google-noto-emoji"
                 "font-google-noto-sans-cjk"
                 "font-google-noto-serif-cjk"
                 "font-victor-mono"

                 ;; Text editors
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
                 "emacs-magit"
                 "emacs-mwim"
                 "emacs-no-littering"
                 "emacs-orderless"
                 "emacs-puni"
                 "emacs-rainbow-delimiters"
                 "emacs-vertico"

                 ;; Commonly-used utilities.
                 "curl"
                 "git"
                 "rsync"))
              %base-packages)))

    (services
     (cons* (service guix-home-service-type
              `((,(user-account-name %my-user)
                 ,(home-environment
                    (services
                     (cons* (service home-keyboard-service-type %my-keyboard-layout)

                            (service home-fish-service-type)
                            (service home-fish-plugin-atuin-service-type)
                            (service home-fish-plugin-direnv-service-type)
                            (service home-fish-plugin-zoxide-service-type)

                            ;; Disable fish greeting.
                            (simple-service 'fish-greeting
                                home-xdg-configuration-files-service-type
                              `(("fish/functions/fish_greeting.fish"
                                 ,(plain-file "fish_greeting.fish" ""))))

                            (service home-swaybg-service-type)
                            (service home-waybar-service-type)
                            (service home-mako-service-type)

                            ;; Default cursor theme.
                            (service home-theme-service-type
                              (home-theme-configuration
                                (packages
                                 (map specification->package
                                      '("qogir-icon-theme")))
                                (icon-theme "Qogir")
                                (cursor-theme "Qogir")))

                            ;; Input method.
                            (service home-fcitx5-service-type
                              (home-fcitx5-configuration
                                (themes
                                 (map specification->package
                                      '("fcitx5-material-color-theme")))
                                (input-method-editors
                                 (map specification->package
                                      '("fcitx5-chinese-addons" "fcitx5-rime")))))

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
                                    (family "Noto Sans CJK CN")
                                    (family ,emoji)))
                                  (alias
                                   (family "serif")
                                   (prefer
                                    (family ,serif)
                                    (family "Noto Serif CJK CN")
                                    (family ,emoji)))
                                  (alias
                                   (family "monospace")
                                   (prefer
                                    (family ,mono)
                                    (family "Noto Serif CJK CN")
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
                            %rosenthal-desktop-home-services))))))
            %rosenthal-desktop-services))))

((compose (nonguix-transformation-nvidia)
          (nonguix-transformation-linux)
          (nonguix-transformation-guix)
          (rosenthal-transformation-guix))
 %my-os)
