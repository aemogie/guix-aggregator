(define-module (misako home-environments look)
  #:use-module (ice-9 format)
  #|Misako|#
  #:use-module (misako utils)
  #:use-module ((misako channels) #:prefix channel:)
  #:use-module ((misako home-environments look mime-types)
                #:prefix mime-types:)
  #:use-module ((misako home-environments look sops)
                #:prefix sops-secrets:)
  #:use-module ((misako home-environments look ssh)
                #:prefix ssh-host:)
  #:use-module (misako home-environments look tokens)
  #|GNU Services|#
  #:use-module (gnu services)
  #|GNU Home Services|#
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services admin)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services fontutils)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services ssh)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services xdg)
  #|GNU Packages|#
  #:use-module ((gnu packages rust-apps) #:select (helvum))
  #:use-module (gnu packages admin)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages bittorrent)
  #:use-module (gnu packages browser-extensions)
  #:use-module (gnu packages chromium)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages image)
  #:use-module (gnu packages image-viewers)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages syndication)
  #:use-module (gnu packages telegram)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages web-browsers)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #|Guix|#
  #:use-module (guix channels)
  #:use-module (guix gexp)
  #:use-module (guix transformations)
  #|NonGNU|#
  #:use-module (nongnu packages game-client)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages video)
  #|Radix|#
  #:use-module (radix utils)
  #|Radix Home Services|#
  #:use-module (radix home services shells)
  #|Radix Packages|#
  #:use-module (radix packages fish-xyz)
  #:use-module (radix packages freedesktop)
  #:use-module (radix packages pulseaudio)
  #:use-module (radix packages toys)
  #:use-module (radix packages video)
  #:use-module (radix packages xdisorg)
  #|Saayix|#
  #:use-module (saayix utils)
  #|Saayix Home Services|#
  #:use-module (saayix services home wm)
  #:use-module (saayix services home dotfiles)
  #|Saayix Packages|#
  #:use-module (saayix packages binaries)
  #:use-module (saayix packages browser-extensions)
  #:use-module (saayix packages file-managers)
  #:use-module (saayix packages fonts)
  #:use-module (saayix packages lsp)
  #:use-module (saayix packages minecraft)
  #:use-module (saayix packages pdf)
  #:use-module (saayix packages productivity)
  #:use-module (saayix packages terminals)
  #:use-module (saayix packages text-editors)
  #:use-module (saayix packages wm)
  #|Misako Packages|#
  #:use-module (misako packages binaries)
  #|SOPS-Guix Secrets|#
  #:use-module (sops secrets)
  #|SOPS-Guix Packages|#
  #:use-module (sops packages sops)
  #|SOPS-Guix Home Services|#
  #:use-module (sops home services sops)
  #:export (look))

(define ghostty-tip
  ((options->transformation
     '((with-commit . "ghostty=9d9d781a0b7142ddc176167ef5e889618d295ef5")))
   ghostty))

(define look
  (nvidia-beta-home-environment
    (packages
      (plist
        #|Utils           |# hyfetch xdg-utils gnupg pinentry-bemenu aria2
        #|                |# light ncurses git sops kexec-tools pciutils
        #|                |# gtk gtk+ gsettings-desktop-schemas
        #|                |# p7zip
        #|Productivity    |# wayneko newsraft
        #|Shell           |# fish
        #|Terminal        |# foot ghostty-tip
        #|Guile           |# guile-next guile-readline guile-colorized guile-gcrypt
        #|Text Editor     |# helix #|optional|# guile-lsp-server parinfer-rust
        #|Emacs           |# emacs-next emacs-geiser emacs-geiser-guile emacs-magit
        #|                |# emacs-paredit emacs-yasnippet emacs-which-key
        #|                |# emacs-vertico emacs-modus-themes emacs-debbugs
        #|                |# emacs-meow
        #|                |# zen-browser-bin
        #|Games           |# (nvidia?* (steam-for nvdb)
                                       (heroic-for nvdb)
                                       mangohud
                                       prismlauncher
                                       path-of-building-bin
                                       mcpelauncher-ui
                                       osu-lazer-bin)
        #|File Manager    |# yazi
        #|Image Viewer    |# imv
        #|Sound           |# wireplumber-minimal ncpamixer helvum easyeffects
        #|Password Manager|# keepassxc password-store passff-host
        #|PDF             |# sioyek zaread
        #|Window Manager  |# hyprland hyprpaper hyprlock hypridle hyprcursor
        #|                |# hyprland-qtutils
        #|                |# mako waybar-sans-elogind grim slurp bemenu
        #|                |# wl-clipboard wlsunset dbus qtwayland cursor-mcmojave
        #|                |# hyprcursor-mcmojave
        #|Messaging       |# senpai vesktop telegram-desktop
        #|E-mail          |# aerc #|required|# sound-theme-freedesktop
        #|                |# libnotify
        #|SSH             |# openssh
        #|Video           |# mpv-minimal/wayland yt-dlp ffmpeg-nvenc obs
        #|Fonts           |# font-adobe-source-han-sans
        #|                |# font-adobe-source-sans-pro
        #|                |# font-adobe-source-serif-pro
        #|                |# font-ipa-mj-mincho
        #|                |# font-jetbrains-mono
        #|                |# font-nerd-symbols
        #|                |# font-google-noto-emoji
        #|XDG Portals     |# xdg-desktop-portal xdg-desktop-portal-hyprland
        #|                |# xdg-desktop-portal-termfilechooser
        #|                |# xdg-desktop-portal-gtk))

    (services
      (list
        (service home-channels-service-type
          (list channel:guix
                channel:saayix
                channel:nonguix
                channel:radix
                channel:sops-guix
                channel:rosenthal))
                ; channel:guixpkgs))

        (service home-dbus-service-type)

        (service home-openssh-service-type
          (home-openssh-configuration
            (authorized-keys #f)
            (hosts
              (list ssh-host:aur
                    ssh-host:github
                    ssh-host:codeberg
                    ssh-host:sourcehut
                    ssh-host:gitlab
                    ssh-host:forgejo
                    ssh-host:yumiko
                    ;; When reconfiguring for the first time, remember to
                    ;; remove all getters from sops-guix. Then, after the
                    ;; reconfigure, add it back and reconfigure again.
                    ;; HERE!
                    ssh-host:gimai))))

        (service home-gpg-agent-service-type
          (home-gpg-agent-configuration
            (pinentry-program
              (file-append pinentry-bemenu "/bin/pinentry-bemenu"))
            (ssh-support? #f)))

        (service home-pipewire-service-type
          (home-pipewire-configuration
            (wireplumber wireplumber-minimal)))

        (service home-shepherd-service-type)
        (service home-shepherd-transient-service-type)

        (service home-log-rotation-service-type)

        (service home-dotfiles-service-type
          (home-dotfiles-configuration
            (layout 'plain)
            (directories (list dotfiles-dir))
            (tokens
              (list (token
                      (link-to-store? #f)
                      (start "{{{ #")
                      (substitutes theme:modus-operandi))
                    ;; HERE!
                    (token
                      (link-to-store? #f)
                      (substitutes secrets:all))))))

        (service home-syncthing-service-type)

        (simple-service 'default-fonts home-fontconfig-service-type
          (list '(alias
                   (family "monospace")
                   (prefer
                     (family "Symbols Nerd Font")
                     (family "Noto Color Emoji")
                     (family "JetBrains Mono NL")))
                '(alias
                   (family "serif")
                   (prefer
                     (family "Symbols Nerd Font")
                     (family "Noto Color Emoji")
                     (family "Source Serif Pro")
                     (family "IPAmjMincho")))
                '(alias
                   (family "sans-serif")
                   (prefer
                     (family "Symbols Nerd Font")
                     (family "Noto Color Emoji")
                     (family "Source Sans Pro")
                     (family "Source Han Sans")))))

        (service home-sops-secrets-service-type
          (home-sops-service-configuration
            (gnupg-home
              (string-append (getenv "HOME") "/.gnupg"))
            (config
              (local-file
                (string-append secrets-dir "/.sops.yaml")
                "sops.yaml"))
            (secrets
              (append sops-secrets:gimai
                      sops-secrets:aerc
                      sops-secrets:senpai))))

        (service home-xdg-user-directories-service-type
          (home-xdg-user-directories-configuration
            (desktop     "$HOME/desktop/")
            (documents   "$HOME/documents/")
            (download    "$HOME/downloads/")
            (music       "$HOME/music/")
            (pictures    "$HOME/images/")
            (videos      "$HOME/videos/")
            (templates   "")
            (publicshare "")))

        (simple-service 'xdg-base-directories-config-service
                        home-xdg-base-directories-service-type
          (home-xdg-base-directories-configuration
            (cache-home  "$HOME/.cache")
            (config-home "$HOME/.config")
            (data-home   "$HOME/.local/share")
            (runtime-dir "/run/user/$(id -u)")
            (log-home    "$HOME/.local/var/log")
            (state-home  "$HOME/.local/state")))

        (service home-xdg-mime-applications-service-type
          (home-xdg-mime-applications-configuration
            (default
              (associate-right
                ('zen.desktop mime-types:browser)
                ('Helix.desktop mime-types:editor)
                ('yazi.desktop mime-types:file-manager)
                ('mpv.desktop mime-types:audio-video)
                ('imv.desktop mime-types:image)
                ('sioyek.desktop mime-types:pdf)))))

        (simple-service 'environment-variables
                        home-environment-variables-service-type
          `(#|Guix|#
            ("GUILE_LOAD_PATH"
             . ,(string-join '("$HOME/projects/guile/misako"
                               "$XDG_CONFIG_HOME/guix/current/share/guile/site/3.0"
                               "$HOME/.guix-home/profile/share/guile/site/3.0")
                             ":"))
            ("GUILE_LOAD_COMPILED_PATH"
             . ,(string-join '("$HOME/.guix-home/profile/lib/guile/3.0/site-ccache"
                               "$XDG_CONFIG_HOME/guix/current/lib/guile/3.0/site-ccache")
                             ":"))
            ; ("GUILE_AUTO_COMPILE"  . "0")
            #|General|#
            ("TMPDIR"              . "/tmp")
            #|Shell|#
            ("HISTFILE"            . "$XDG_CACHE_HOME/shell_history")
            ("HISTSIZE"            . "-1")
            ("HISTFILESIZE"        . "-1")
            ("PATH"                . "$HOME/.local/bin:$PATH")
            #|Language|#
            ("LANG"                . "en_US.UTF-8")
            ("LANGUAGE"            . "en_US.UTF-8")
            #|Python|#
            ("PYTHONPYCACHEPREFIX" . "$XDG_CACHE_HOME/python")
            ("PYTHONUSERBASE"      . "$XDG_DATA_HOME/python")
            #|coreutils|#
            ("LC_COLLATE"          . "C")
            #|QT|#
            ("QT_QPA_PLATFORM"     . "wayland")
            #|NVIDIA|#
            ,@(if (not nvidia?) '()
                '(("QT_X11_NO_MITSHM"                    . "1")
                  ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
                  ; ("QT_OPENGL_NO_SANITY_CHECK"           . "1") ;; Bad flag
                  ("__GLX_VENDOR_LIBRARY_NAME"           . "nvidia")
                  ; ("__NV_PRIME_RENDER_OFFLOAD"           . "1")
                  ("__GL_GSYNC_ALLOWED"                  . "1")
                  ("__GL_VRR_ALLOWED"                    . "1")
                  ;; This flag below solves prismlauncher problems
                  ; ("__GL_THREADED_OPTIMIZATIONS"         . "0")
                  ("GBM_BACKEND"                         . "nvidia-drm")
                  ("XDG_SESSION_TYPE"                    . "wayland")
                  ("GUIX_SANDBOX_EXTRA_SHARES"           . "/home/look/games")
                  ("LIBVA_DRIVER_NAME"                   . "nvidia")))
            #|Guile|#
            ("GUILE_HISTORY" . "$XDG_CACHE_HOME/guile/history")
            #|User variables|#
            ("EDITOR"   . "hx")
            ("READER"   . "sioyek")
            ("VISUAL"   . "hx")
            ("TERMINAL" . "ghostty")
            ("BROWSER"  . "zen")
            ("PAGER"    . "less")
            ("WM"       . "hyprland")))

        (service home-fish-service-type
          (home-fish-configuration
            (environment-variables
              `(("GPG_TTY" . "$(tty)")
                #|Fish|#
                ("__done_allow_nongraphical" . "1")
                ("__done_exclude" . ,(format #f "~{'^~a' ~}"
                                       (list #|G|# "git (?!push|pull|fetch)"
                                                   "guix (edit|repl|shell)"
                                             #|K|# "hx"
                                             #|L|# "yazi"
                                             #|M|# "mpv"
                                             #|N|# "aerc")))
                ("__done_notification_command" . "notify-send '$title' '$message'")))
            (aliases
              '(#|Useful aliases|#
                ("ls"            . "ls -lhFv --group-directories-first --color=auto")
                ("reboot"        . "doas reboot")
                ("halt"          . "doas halt")
                #|User aliases|#
                ("disk-space"    . "du -h | grep '^\\s*[0-9\\.]\\+G' | sort -rn")
                ("set-codeberg"  . "git config user.name 'look' && git config user.email 'look@noreply.codeberg.org'")))
            ;;TODO: create some good abbreviations using more abbr command features
            ;;TODO: make abbreviations serializer feature complete to better handle flags and complex abbreviations
            (abbreviations
              (let* ((system "/etc/system.scm")
                     (home "~/.config/guix/home.scm"))
                (cons*
                  (abbreviation
                    (name '!system)
                    (expansion (reconfigure system)))
                  (abbreviation
                    (name '!home)
                    (expansion (reconfigure home)))
                  (abbreviation
                    (name '!fast-home)
                    (expansion
                      (string-join
                        (list (reconfigure home) "--no-substitutes"))))
                  (abbreviation
                    (name ':system)
                    (expansion (edit system)))
                  (abbreviation
                    (name ':home)
                    (expansion (edit home)))
                  (abbreviation
                    (name 'z)
                    (expansion
                      "curl -F file=% https://0x0.st | wl-copy"))
                  (map (lambda (channel)
                         (abbreviation
                           (name (symbol-append '@ channel))
                           (position 'anywhere)
                           (expansion
                             (symbol-append '~/projects/guile/ channel))))
                       '(guix nonguix saayix misako radix)))))
            (plugins (list fish-autopair fish-done))))))))

look
