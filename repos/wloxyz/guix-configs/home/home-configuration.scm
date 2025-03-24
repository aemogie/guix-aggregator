(add-to-load-path (dirname (current-filename)))

;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(define-module (home-configuration))


(use-modules (gnu home)
             (guix gexp)
             (gnu packages)
             (gnu packages gnupg)
             (gnu packages mpd)
             (gnu packages shellutils)
             (wlo packages node-xyz)    ; for node-arrpc
             (gnu services)
             (gnu home services)
             (gnu home services shepherd)
             (gnu home services shells)
             (gnu home services desktop)
             (gnu home services sound)
             (gnu home services syncthing)
             (gnu home services ssh)
             (gnu home services mail)
             (gnu home services gnupg)
	     (gnu home services dotfiles)
             (lib emacs))

(home-environment
 (packages (append
	    ;; if there are any weird ambiguities, load them first here
            wlo-emacs-packages
            ;; Below is the list of packages that will show up in your
            ;; Home profile, under ~/.guix-home/profile.
            ;; you can provide a version number like so: "openssl@3.0.7"
	    (specifications->packages
	     (list
	      ;; ui
	      "swayidle"
	      "swaylock-effects"
	      "mako"
	      "libnotify"
	      "waybar"
	      "bibata-cursor-theme"
	      "glib:bin"                ; for gsettings
	      "qogir-icon-theme"
              "adwaita-icon-theme"
              "pcmanfm"  ; for anything that might need a file manager
	      ;; screensharing and other wlroots stuff
	      "xdg-desktop-portal"
	      "xdg-desktop-portal-wlr"
	      ;; "xdg-desktop-portal-gtk"
	      "slurp"
	      "grimshot"                ; for screenshots
	      "wl-clipboard"
	      ;; experimental
	      "nyxt"
              ;; essentials
	      "password-store"
	      "firefox"                 ; courtesy of nonguix
	      ;; "passff-host" ; - no worky
	      "htop"
	      "flatpak"
	      "isync"
	      "tmux"
	      ;; email
	      "isync"
	      "mu"
	      "emacs-mu4e-alert"
	      "emacs-message-view-patch"
	      ;; "emacs-org-msg" ; 2024-09-14 uncomment when latest version is merged in guix repos
              ;; caldav
              "vdirsyncer"
	      ;; social
	      "mumble"
	      "senpai"
	      ;; gaming
	      "steam"
	      ;; multimedia
	      "pipewire"
	      "easyeffects"
	      "qpwgraph"
	      "mpv"
	      "mpd-mpc"
	      "ncmpcpp"
	      "yt-dlp"
	      "obs"
	      "obs-wlrobs"
	      "obs-vkcapture"
	      "gimp"
	      "krita"
	      "blender"
	      "zathura"
	      "zathura-pdf-mupdf"
	      "imv"
	      ;; music
	      ;; "carla"
	      "reaper"                  ; nonguix
	      "lsp-plugins"
	      "lsp-plugins:lv2"
	      "calf"
	      "distrho-ports"
	      ;; "airwindows-lv2"          ; from nebula channel
              "x42-plugins"
              "zynaddsubfx"
              "lv2-speech-denoiser"
	      ;; fonts
	      "font-go"                 ; needed for my emacs config
	      "font-liberation"
	      "font-linuxlibertine"
	      "font-iosevka"
	      "font-iosevka-slab"
	      "font-iosevka-etoile"
	      "font-jigmo"              ; cjk
	      "font-sarasa-gothic"      ; cjk mono
              "font-new-heterodox-mono" ; in testing currently
	      ;; Dev tools
	      "guile-next"
	      "readline"
	      "guile-colorized"         ; for guix interactivity
	      "direnv"
	      "podman"
	      "fd"
	      "eza"
	      "foot"                    ; terminal
	      "git"
	      "git-lfs"
	      "git:send-email"          ; useful for contributing to guix itself
	      "zoxide"
	      "ripgrep"
	      "curl"
	      "wget"
	      "jq"
	      "bat"
	      ;; server management
	      "talosctl"
	      "kubectl"
	      "virt-manager"
	      ;; general utilities
	      "aspell"
	      "aspell-dict-en"
	      "xdg-utils"
	      "udiskie"
	      "p7zip"
	      "rsync"
	      "imagemagick"           ; needed for emacs-pdf-tools
              "bind:utils"
	      ;; documentation
	      "sicp"                  ; a fun lil textbook :)
	      "clhs"                  ; common lisp hyperspec, nonfree
	      ;; showoff tools
	      "hyfetch"))))

 ;; Below is the list of Home services.  To search for available
 ;; services, run 'guix home search KEYWORD' in a terminal.
 (services
  (list
   (simple-service 'wlo-home-env-vars-service
                   home-environment-variables-service-type
                   `(("WEBKIT_DISABLE_COMPOSITING_MODE" . "1") ; for nyxt
                     ("_JAVA_AWT_WM_NONREPARENTING" . "1")     ; for java programs under sway
                     ("EDITOR" . "emacsclient")
                     ("VISUAL" . "emacsclient")
		     ("XDG_CURRENT_DESKTOP" . "sway")
                     ;; make flatpak work regardless of shell
                     ("XDG_DATA_DIRS" . "${XDG_DATA_HOME}/flatpak/exports/share:${XDG_DATA_DIRS}")
                     ("XCURSOR_PATH" . "${XCURSOR_PATH}:~/.local/share/icons")))

   (service home-bash-service-type
            (home-bash-configuration
             (aliases '(("ls" . "eza --icons --color=always")
                        ("cat" . "bat")
                        ("hyfetch" . "hyfetch --args '--colors 5 7 0 5 7 7'")))
             (bashrc (list
                      (local-file "dot-bashrc.sh")
                      (mixed-text-file "liquidprompt"
                                       "[[ $- = *i* ]] && source "
                                       liquidprompt
                                       "/share/liquidprompt/liquidprompt")))
             (bash-profile  (list (local-file "dot-bash_profile.sh")))))

   (service home-msmtp-service-type
            (home-msmtp-configuration
             (default-account "willow")
             (accounts
              (list
               (msmtp-account
                (name "willow")
                (configuration
                 (msmtp-configuration
                  (host "phantoma.online")
                  (port 465)
                  (user "willow@phantoma.online")
                  (password-eval "pass email/willow@phantoma.online")
                  (auth? #t)
                  (tls? #t)
                  (tls-starttls? #f))))))))

   (service home-dbus-service-type)

   (service home-pipewire-service-type)

   (service home-openssh-service-type
            (home-openssh-configuration
             (authorized-keys (list (local-file "wlo-yubikey.pub")))
             (add-keys-to-agent "yes")))

   (service home-gpg-agent-service-type
            (home-gpg-agent-configuration
             (pinentry-program
              (file-append pinentry "/bin/pinentry"))
             (ssh-support? #t)
             (extra-content "allow-loopback-pinentry")))

   (service home-syncthing-service-type)

   (service home-dotfiles-service-type
	    (home-dotfiles-configuration
	     (directories '("./dotfiles"))
	     (layout 'stow)))
   
   (service home-shepherd-service-type
            (home-shepherd-configuration
             (services
              (list
               (shepherd-service
                (provision '(mpd))
                (start #~(make-system-constructor (string-append #$mpd "/bin/mpd")))
                (stop #~(make-system-destructor (string-append #$mpd "/bin/mpd") "--kill"))
                (documentation "The Music Player Daemon"))
               (shepherd-service
                (provision '(arrpc))
                (start #~(make-forkexec-constructor
                          ;; for some reason i can't just supply no args to the command
                          (list (string-append #$node-arrpc "/bin/arrpc") "")))
                (stop #~(make-kill-destructor))
                (documentation "Rich-presence for Discord")))))))))

