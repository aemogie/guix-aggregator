;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(define-module (home home-conf)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu packages)

  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  ;; #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services sound)

  #:use-module (guix gexp)
  #:use-module (guix channels)

  #:use-module (home services dotfiles)
  #:use-module (home services texlive)
  #:use-module (packages fonts)
  #:use-module (packages texlab))

(use-package-modules admin
                     chromium
                     ebook
                     fcitx5
                     fonts
                     freedesktop
                     gnome
                     gnupg
                     inkscape
                     kde
                     librewolf
                     linux
                     node
                     package-management
                     password-utils
                     pdf
                     pulseaudio
                     qt
                     shells
                     shellutils
                     sync
                     terminals
                     tree-sitter
                     vim
                     wm
                     xdisorg
                     xorg)

;; (define packages:desktop
;;   (list #|freedesktop|# xdg-utils xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr))

(define-public my-home-environment
  (home-environment
    ;; Below is the list of packages that will show up in your
    ;; Home profile, under ~/.guix-home/profile.
    ;; (packages (list ))
    
    (packages (list
               ;; window manager
               sway
               swayidle
               swaylock
               foot
               fuzzel
               mako
               grimshot

               ;; text editor
               neovim
               tree-sitter-cli
               texlab

               inkscape

               ;; flatpak
               flatpak
               flatpak-xdg-utils

               ;; xwayland
               xorg-server-xwayland

               ;; password manager
               gnupg
               ;; pinentry-emacs
               password-store

               ;; zsh
               zsh
               zsh-autosuggestions
               zsh-completions
               zsh-syntax-highlighting

               ;; font
               font-jetbrains-mono-nf
               font-adobe-source-han-sans
               font-google-noto-emoji

               ;; books, pdf & djvu
               zathura
               zathura-djvu
               zathura-pdf-mupdf
               okular
               calibre

               qtwayland

               ;; browsers
               ungoogled-chromium
               librewolf

               ;; clipboard
               ;; xclip
               wl-clipboard

               ;; sync
               rclone

               ;; sound
               pipewire
               wireplumber-minimal
               pulsemixer

               ;; appearance
               gnome-themes-extra
               adwaita-icon-theme

               ;; chinese language input
               fcitx5
               fcitx5-chinese-addons
               fcitx5-configtool
               fcitx5-gtk
               fcitx5-qt))

    ;; Below is the list of Home services.  To search for available
    ;; services, run 'guix home search KEYWORD' in a terminal.
    (services
     (list (simple-service 'my-env-vars-service
                           home-environment-variables-service-type
                           `(("SHELL" unquote
                              (file-append zsh "/bin/zsh"))
                             ("PATH" . "$HOME/.local/bin:$PATH")
                             ("GUIX_PROFILE" . "$HOME/.guix-profile")

                             ;; Configure pinentry to use correct TTY
                             ("GPG_TTY" . "$(tty)")

                             ;; Use XDG Specification
                             ("PASSWORD_STORE_DIR" . "$XDG_DATA_HOME/pass")

                             ;; Fcitx5
                             ;; ("XMODIFIERS" . "@im" . "fcitx")
                             ("GTK_IM_MODULE" . "fcitx")
                             ("QT_IM_MODULE" . "fcitx")

                             ;; Wayland-specific environment variables
                             ("XDG_CURRENT_DESKTOP" . "sway")
                             ("XDG_SESSION_TYPE" . "wayland")
                             ("RTC_USE_PIPEWIRE" . "true")
                             ("SDL_VIDEODRIVER" . "wayland")
                             ("MOZ_ENABLE_WAYLAND" . "1")
                             ("CLUTTER_BACKEND" . "wayland")
                             ("ELM_ENGINE" . "wayland_egl")
                             ("ECORE_EVAS_ENGINE" . "wayland-egl")
                             ("QT_QPA_PLATFORM" . "wayland-egl")))

           (service home-zsh-service-type)

           (service home-dotfiles-service-type
                    (home-dotfiles-configuration (directories (list (format #f
                                                                            "~a/anon/files"
                                                                            (getenv
                                                                             "HOME"))))))
           ;; (excluded '(".*~" ".*\\.swp" "\\.git/.*" ".*/\\.git/.*" "\\.gitignore"))))
           
           (service home-dbus-service-type)

           (service home-pipewire-service-type)

           (service home-gpg-agent-service-type
                    (home-gpg-agent-configuration (pinentry-program (file-append
                                                                     pinentry
                                                                     "/bin/pinentry-gtk-2"))
                                                  (ssh-support? #t)
                                                  (extra-content
                                                   "enable-ssh-support")))

           (service home-texlive-service-type)

           (simple-service 'nonguix-channel-service
                           home-channels-service-type
                           (list (channel
                                   (name 'nonguix)
                                   (url "https://gitlab.com/nonguix/nonguix")
                                   ;; Enable signature verification
                                   (introduction
                                    (make-channel-introduction
                                     "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                     (openpgp-fingerprint
                                      "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))))))))

my-home-environment
