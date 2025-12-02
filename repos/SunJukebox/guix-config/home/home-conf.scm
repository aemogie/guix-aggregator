(define-module (anon home home-conf)
  #:use-module (guix gexp)
  #:use-module (guix channels)

  #:use-module (gnu)

  #:use-module (gnu packages)

  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  ;; #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services sound)

  #:use-module (nongnu packages)
  #:use-module (nongnu packages editors)

  ;; #:use-module (anon home services)
  #:use-module (anon home services dotfiles)
  #:use-module (anon home services texlive)
  ;; #:use-module (anon home services emacs)

  #:use-module (anon packages fonts)
  ;; #:use-module (anon packages neovim)
  #:use-module (anon packages texlab)
  #:use-module (anon packages textutils))
; #:use-module (anon packages tree-sitter))
; #:use-module (anon packages xdg-desktop-portal-gtk-sway))

; #:export (my-home-environment))

(use-package-modules admin
                     chromium
                     compression
                     cups
                     ebook
                     fcitx5
                     fonts
                     freedesktop
                     glib
                     gnome
                     gnupg
                     image
                     image-viewers
                     inkscape
                     kde-graphics
                     kde-multimedia
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
                     video
                     vim
                     web-browsers
                     wm
                     xdisorg
                     xorg)

(define my-home-environment
  (home-environment
    (packages (list
               ;; window manager
               sway
               swayidle
               swaylock
               foot
               fuzzel
               mako
               grimshot
               slurp
               waybar
               ;; wofi
               ;; bemenu

               unzip

               ;; text editor
               neovim
               tree-sitter-cli
               texlab

               ;; vscodium
               
               ;; media
               inkscape
               imv
               ffmpeg

               ;; flatpak
               flatpak
               xdg-desktop-portal
               ;; xdg-desktop-portal-gtk-sway
               xdg-desktop-portal-wlr
               xdg-utils ;For xdg-open, etc
               flatpak-xdg-utils
               xdg-dbus-proxy
               shared-mime-info
               (list glib "bin")

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
               ;; ungoogled-chromium
               librewolf
               qutebrowser

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
               fcitx5-qt

               ;; printers & scanners
               hplip))

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
                             ("XMODIFIERS" . "@im=fcitx")
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
                                                                            "~a/src/my-channel/anon/files"
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

           ;; (service home-emacs-config-service-type)

           ;; (service (service-type (name 'home-xdg-desktop-portal)
           ;; (extensions (list (service-extension
           ;; home-profile-service-type
           ;; (const (list
           ;; xdg-desktop-portal
           ;; xdg-desktop-portal-wlr)))
           ;; (service-extension
           ;; home-xdg-configuration-files-service-type
           ;; (const `(("xdg-desktop-portal/portals.conf" ,
           ;; (local-file
           ;; "../files/.config/xdg-desktop-portal/portals.conf")))))))
           ;; (default-value #f)
           ;; (description #f)))
           
           (simple-service 'additional-channels-service
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
