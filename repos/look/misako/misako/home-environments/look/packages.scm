(define-module (misako home-environments look packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages bittorrent)
  #:use-module (gnu packages browser-extensions)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages image)
  #:use-module (gnu packages image-viewers)
  #:use-module (gnu packages irc)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages music)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages python)
  #:use-module (gnu packages qt)
  #:use-module ((gnu packages rust-apps)
                #:select (helvum
                          typst))
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages syndication)
  #:use-module (gnu packages telegram)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix transformations)
  #:use-module (guix utils)
  #:use-module (misako packages binaries)
  #:use-module (misako utils)
  #:use-module (nongnu packages fonts)
  #:use-module (nongnu packages compression)
  #:use-module (nongnu packages game-client)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages video)
  #:use-module (radix packages freedesktop)
  #:use-module (radix packages music)
  #:use-module (radix packages pulseaudio)
  #:use-module (radix packages video)
  #:use-module (saayix packages binaries)
  #:use-module (saayix packages emacs-xyz)
  #:use-module (saayix packages file-managers)
  #:use-module (saayix packages fonts)
  #:use-module (saayix packages lsp)
  #:use-module (saayix packages minecraft)
  #:use-module (saayix packages pdf)
  #:use-module (saayix packages productivity)
  #:use-module (saayix packages terminals)
  #:use-module (saayix packages wm)
  #:use-module (saayix-nonfree packages binaries)
  #:use-module (sops packages sops)
  #:export (bar
            browser
            clipboard
            compression
            cursor
            desktop
            downloads
            emacs
            file-management
            fonts
            games
            guile
            hypr*
            image
            mail
            messaging
            music
            news
            notifications
            password
            pdf
            portals
            presentation
            python
            screenshot
            selectors
            sound
            terminals
            text-editor
            typst
            video
            virtual-keyboard

            ghostty-tip
            hyprland-latest))

(define mpvpaper-minimal
  (let* ((commit "01b2b92a989e57001947945fa21c31dce3e51c9b")
         (revision "1"))
    (package/inherit mpvpaper
      (name "mpvpaper-minimal")
      (version (git-version (package-version mpvpaper) revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/GhostNaN/mpvpaper")
                      (commit commit)))
                (sha256
                 (base32 "1d6sc89v6z798rbmf54j2rv3jcmkfbrhym5lj3xy5ybyww72gw73"))
                (file-name (git-file-name name version))))
      (inputs
        (modify-inputs (package-inputs mpvpaper)
          (replace "mpv" mpv-minimal/wayland))))))

(define bar
  (list eww/wayland waybar))

(define browser
  (list zen-browser-bin))

(define clipboard
  (list wl-clipboard))

(define compression
  (list 7zip))

(define cursor
  (list cursor-mcmojave hyprcursor-mcmojave))

(define desktop
  (list git
        gnupg
        gsettings-desktop-schemas
        hyfetch
        light
        ncurses
        openssh
        pciutils
        qtwayland
        sops
        xdg-utils))

(define downloads
  (list aria2
        qbittorrent))

(define emacs
  (list emacs-activities
        emacs-arei
        emacs-catppuccin-theme
        emacs-debbugs
        emacs-eat
        emacs-expand-region
        emacs-magit
        emacs-mc-extras
        emacs-meow
        emacs-modalka
        emacs-modus-themes
        emacs-move-text
        emacs-multiple-cursors
        emacs-paredit
        emacs-parinfer-rust-mode
        emacs-pgtk
        emacs-tabspaces
        emacs-vertico
        emacs-which-key
        emacs-yasnippet
        guile-ares-rs))

(define file-management
  (list yazi))

(define fonts
  (list font-adobe-source-han-sans
        font-adobe-source-sans
        font-adobe-source-serif
        font-google-noto-emoji
        font-ipa-mj-mincho
        font-jetbrains-mono
        font-microsoft-arial
        font-microsoft-times-new-roman
        font-nerd-symbols))

(define games
  (yumiko?* (steam-for nvdb)
            (heroic-for nvdb)
            mangohud
            mcpelauncher-client
            osu-lazer-bin
            prismlauncher))

(define guile
  (list guile-next guile-colorized guile-gcrypt guile-readline
        guile-lsp-server
        parinfer-rust))

(define hypr*
  (list hyprcursor
        hypridle
        hyprland dbus
        hyprland-qtutils
        hyprlock
        hyprpaper
        hyprsunset))

(define image
  (list imv))

(define mail
  (list aerc))

(define messaging
  (list senpai
        catgirl
        vesktop
        telegram-desktop))

(define music
  (list kew
        spotify))

(define news
  (list newsraft))
        ; helix-pdf))

(define notifications
  (list ;libnotify
        mako
        sound-theme-freedesktop))

(define password
  (list password-store passff-host))

(define pdf
  (list sioyek
        zaread zathura zathura-pdf-poppler))

(define portals
  (list xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-termfilechooser))

(define presentation
  (list wl-mirror pipectl))

(define python
  (list python-wrapper))

(define screenshot
  (list grim slurp))

(define selectors
  (list bemenu fuzzel))

(define sound
  (list wireplumber-minimal
        ncpamixer
        helvum
        playerctl
        easyeffects))

(define terminals
  (list ghostty-latest foot))

(define text-editor
  (list helix))

(define video
  (list mpv-minimal/wayland
        yt-dlp
        obs-pipewire-audio-capture
        (yumiko?* ffmpeg/nvidia obs-nvidia nvidia-vaapi-driver)
        (yuria?* ffmpeg obs)))

(define virtual-keyboard
  (list xdotool ydotool))

(define typst
  (list (@ (gnu packages rust-apps) typst)
        tinymist))

(define ghostty-tip
  ((options->transformation
     '((with-commit . "ghostty=9d9d781a0b7142ddc176167ef5e889618d295ef5")))
   ghostty))

(define hyprland-latest
  (let* ((commit "8e9add2afda58d233a75e4c5ce8503b24fa59ceb")
         (revision "1"))
    (package/inherit hyprland
      (name (package-name hyprland))
      (version (git-version "0.51.1" revision commit))
      (source
        (origin
          (method git-fetch)
          (uri
            (git-reference
              (url "https://github.com/hyprwm/Hyprland")
              (commit commit)))
          (file-name (git-file-name name version))
          (sha256
           (base32 "0hnq8vwr31scpf20qnv17zc0fn7llf0wlhym0a8p39n6ag1g1dwc")))))))
