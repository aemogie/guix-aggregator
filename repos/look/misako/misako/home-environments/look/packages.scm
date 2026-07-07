(define-module (misako home-environments look packages)
  #:use-module ((gnu packages rust-apps) #:select (helvum typst jujutsu))
  #:use-module (gnu packages admin)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bittorrent)
  #:use-module (gnu packages browser-extensions)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
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
  #:use-module (gnu packages license)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages music)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages syndication)
  #:use-module (gnu packages telegram)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages tor-browsers)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix transformations)
  #:use-module (guix utils)
  #:use-module (misako packages binaries)
  #:use-module (misako utils)
  #:use-module (nongnu packages compression)
  #:use-module (nongnu packages fonts)
  #:use-module (nongnu packages game-client)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages video)
  #:use-module (radix packages freedesktop)
  #:use-module (radix packages image-viewers)
  #:use-module (radix packages music)
  #:use-module (radix packages pulseaudio)
  #:use-module (radix packages video)
  #:use-module (saayix packages binaries)
  #:use-module (saayix packages emacs-xyz)
  #:use-module (saayix packages file-managers)
  #:use-module (saayix packages fonts)
  #:use-module (saayix packages games)
  #:use-module (saayix packages minecraft)
  #:use-module (saayix packages pdf)
  #:use-module (saayix packages productivity)
  #:use-module (saayix packages terminals)
  #:use-module (saayix packages wm)
  #:use-module (saayix-nonfree packages binaries)
  #:use-module (sops packages sops))

(define-public ghostty-tip
  ((options->transformation
     '((with-commit . "ghostty=9d9d781a0b7142ddc176167ef5e889618d295ef5")))
   ghostty))

(define-public hyprland-latest
  (let* ((commit "70fd412d95b082e3c9a2a2e2597a9e467947d320")
         (revision "1"))
    (package/inherit hyprland
      (name (string-append (package-name hyprland) "-latest"))
      (version (git-version (package-version hyprland) revision commit))
      (source
        (origin
          (method git-fetch)
          (uri
            (git-reference
              (url "https://github.com/hyprwm/Hyprland")
              (commit commit)))
          (file-name (git-file-name name version))
          (sha256
            (base32 "1770zwx6qsza4ymrdmm3wyyv89b197scw1a0jfm4rlcvya7p9nyw")))))))

(define-public bar
  (list morewaita-icon-theme
        quickshell-latest/ctm
        qtgraphicaleffects
        qt5compat))

(define-public browser
  (list zen-browser-bin
        mullvadbrowser))

(define-public clipboard
  (list wl-clipboard))

(define-public compression
  (list 7zip))

(define-public cursor
  (list cursor-mcmojave hyprcursor-mcmojave))

(define-public desktop
  (list git
        jujutsu
        reuse
        gnupg
        gsettings-desktop-schemas
        hyfetch
        light
        ncurses
        openssh
        pciutils
        qtwayland
        sops
        sed
        grep
        vulkan-tools
        mesa-utils
        xdg-utils))

(define-public downloads
  (list aria2
        qbittorrent))

(define-public emacs
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

(define-public file-management
  (list yazi))

(define-public fonts
  (list font-adobe-source-han-sans
        font-adobe-source-sans
        font-adobe-source-serif
        font-google-noto-emoji
        font-google-noto
        font-ipa-mj-mincho
        font-jetbrains-mono
        font-microsoft-arial
        font-inter
        font-google-material-design-icons
        font-material-design-symbols
        font-microsoft-times-new-roman
        font-nerd-symbols))

(define-public games
  (yumiko?* steam-nvidia-595
            heroic-nvidia-595
            mangohud
            rusty-path-of-building
            ;; mcpelauncher-client
            osu-lazer-bin))
            ;; prismlauncher))

(define-public guile
  (list guile-next guile-colorized guile-gcrypt guile-readline
        guile-lsp-server
        parinfer-rust))

(define-public hypr*
  (list hyprcursor
        hypridle
        hyprland dbus
        hyprland-qtutils
        hyprlock
        hyprpaper
        hyprsunset))

(define-public image
  (list imv))
        ;; oculante))

(define-public mail
  (list aerc))

(define-public messaging
  (list senpai
        catgirl
        ;; cinny-desktop-bin
        fluxer-canary))
        ;; vesktop))
        ;; telegram-desktop))

(define-public music
  (list kew))

(define-public news
  (list newsraft))
        ; helix-pdf))

(define-public notifications
  (list libnotify
        sound-theme-freedesktop))

(define-public password
  (list password-store passff-host))

(define-public pdf
  (list sioyek
        zaread zathura zathura-pdf-mupdf))

(define-public portals
  (list xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-termfilechooser))

(define-public presentation
  (list wl-mirror pipectl))

(define-public python
  (list python-wrapper))

(define-public screenshot
  (list grim slurp))

(define-public selectors
  (list bemenu fuzzel))

(define-public sound
  (list wireplumber-minimal
        ncpamixer
        helvum
        playerctl
        easyeffects))

(define-public terminals
  (list ghostty
        foot))

(define-public text-editor
  (list helix))

(define-public video
  (list yt-dlp
        obs-pipewire-audio-capture
        (yumiko?* obs-nvidia mpv-nvidia)
        (yuria?* ffmpeg obs mpv)))

(define-public virtual-keyboard
  (list xdotool ydotool))

(define-public typst
  (list (@ (gnu packages rust-apps) typst)
        tinymist-bin))

(define-public nix
  (nix->guix
    '(prismlauncher)))
