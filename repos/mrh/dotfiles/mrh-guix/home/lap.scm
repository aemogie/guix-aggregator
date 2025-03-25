(define-module (mrh-guix home lap)
  #:use-module (gnu)

  #:use-module (gnu home)

  #:use-module (gnu home services)

  #:use-module (gnu home services desktop)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services syncthing)

  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages mozilla))

(use-package-modules admin
                     aspell
                     compression
                     cups
                     emacs
                     emacs-xyz
                     finance
                     fonts
                     freedesktop
                     glib
                     gnome
                     gnupg
                     gtk
                     guile-xyz
                     imagemagick
                     image-viewers
                     libreoffice
                     librewolf
                     linux
                     mp3
                     networking
                     password-utils
                     pdf
                     rsync
                     sdl
                     statistics
                     terminals
                     texlive
                     version-control
                     video
                     wm
                     xdisorg)

(define-public lap-home-config
  (home-environment
   (packages (list
              ;; graphical env
              alacritty
              brightnessctl
              fnott
              fuzzel
              gtk+
              libnotify
              libreoffice
              librewolf
              sway
              swaybg
              swayidle
              swaylock
              waybar
              wf-recorder
              wl-clipboard
              xdg-utils
              zathura
              zathura-pdf-mupdf
              zathura-ps
              zathura-djvu
              zoom

              ;; fonts
              ;; might need to  run "fc-cache -vfr" to reubild font cache
              ;; emacs try (font-family-list)
              font-awesome
              font-google-noto
              font-google-noto-emoji
              font-google-noto-sans-cjk
              font-google-noto-serif-cjk
              font-hack

              ;; media
              ffmpeg
              grimshot
              imagemagick
              imv
              mpv
              taglib
              yt-dlp

              ;; emacs
              emacs-pgtk
              emacs-aggressive-indent
              emacs-auctex
              emacs-bluetooth
              emacs-consult
              emacs-corfu
              emacs-diredfl
              emacs-doom-modeline
              emacs-eat
              emacs-ess
              emacs-expand-region
              emacs-geiser-guile
              emacs-gruvbox-theme
              emacs-magit
              emacs-marginalia
              emacs-markdown-mode
              emacs-orderless
              emacs-org-bullets
              emacs-ox-haunt
              emacs-paredit
              emacs-pinentry
              emacs-rainbow-delimiters
              emacs-sly
              emacs-tldr
              emacs-vertico
              emacs-wgrep

              ;; programming
              (list git "send-email")
              sdl2

              ;; communication
              signal-desktop

              ;; misc
              cups
              fastfetch
              (list glib "bin")
              gnupg
              haunt
              ispell
              keepassxc
              monero
              pinentry
			  rsync
              socat
              texlive
              unzip))

   (services
    (list (service home-dbus-service-type)
          (service home-pipewire-service-type)
          (service home-syncthing-service-type)

	      (service home-dotfiles-service-type
                   (home-dotfiles-configuration
                    (directories (list (format #f "~a/dotfiles" (getenv "HOME"))))
                    (excluded '(".*~"
                                "\\.git"
                                "\\.gitignore"
                                "LICENSE.*"
                                "README.*"
                                "screenshot.png"))))

          (simple-service 'environment-variables-service
                          home-environment-variables-service-type
                          '(("PATH" . "$HOME/.local/bin:$PATH")
                            ("GNUPGHOME" . "$XDG_DATA_HOME/gnupg")
                            ("BROWSER" . "librewolf")
                            ("EDITOR" . "emacs")
                            ("GIT_SSL_CAINFO" . "/etc/ssl/certs/ca-certificates.crt")
                            ("XDG_SCREENSHOTS_DIR" . "$HOME/media/pictures/screenshots")
                            ("TERM" . "xterm-color")))

          (service home-bash-service-type
                   (home-bash-configuration
                    (guix-defaults? #f)
                    (aliases
                     '(("grep" . "grep --color=auto")
                       ("ip" . "ip -color=auto")
                       ("ls" . "ls -halp --color=auto")))
                    (bashrc
                     (list (local-file ".bashrc" "bashrc")))))))))

lap-home-config
