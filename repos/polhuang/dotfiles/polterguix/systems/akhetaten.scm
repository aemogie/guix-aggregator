(define-module (polterguix systems akhetaten)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services ssh)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages hunspell)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages librewolf)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages web-browsers)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu system)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages mozilla)
  #:use-module (polterguix packages cli)
  #:use-module (polterguix packages desktop)
  #:use-module (polterguix packages fonts-extra)
  #:use-module (polterguix systems core-system)
  #:use-module (rosenthal services desktop)
  #:use-module (rosenthal services networking)
  #:use-module (rosenthal utils packages))

(define system
  (operating-system
   (inherit core-operating-system)
   (host-name "akhetaten")

   (kernel-arguments
    '("amd_pstate=active"              ; modern amd cpu scaling
      "nvme.noacpi=1"                  ; sometimes helps resume on some nvme's
      "mem_sleep_default=deep"         ; try deeper suspend; revert if issues
      "modprobe.blacklist=pcspkr"))
   (firmware (list linux-firmware amdgpu-firmware))
   (mapped-devices (list (mapped-device
                          (source (uuid
                                   "ce94eff8-f142-403f-96e0-208784bb7892"))
                          (target "cryptakhetaten")
                          (type luks-device-mapping))))

   (swap-devices (list (swap-space (target "/swap/swapfile")
                                   (dependencies mapped-devices))))
   
   ;; placeholder file system
   (file-systems (cons* (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptakhetaten")
                         (type "ext4")
                         (dependencies mapped-devices))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "A1B9-69BE"
                                       'fat32))
                         (type "vfat")) %base-file-systems))
   

   ))
   
(define home
  (home-environment
   (packages (list asciiquarium
                   binutils
                   blueman
                   btop
                   cliphist
                   emacs-next-pgtk
                   emacs-guix
                   emacs-jinx
                   firefox
                   font-awesome
                   font-fira-code
                   font-google-material-design-icons
                   font-google-noto
                   font-google-noto-emoji
                   font-google-noto-sans-cjk
                   font-google-noto-serif-cjk
                   font-jetbrains-mono
                   font-jetbrains-mono-nerd
		   flatpak
		   font-dejavu
		   font-fira-code
		   font-ghostscript
		   font-gnu-freefont
                   fzf
                   hunspell
                   hyprpaper
                   kanshi
                   kitty
                   libreoffice
		   librewolf
                   mu
                   neofetch
                   neovim
                   obs
                   qutebrowser
		   password-store
                   powertop
                   ripgrep
                   rofi-wayland
                   rust
                   rust-analyzer
                   seatd
                   sh-z
                   starship-bin
                   swaynotificationcenter
                   waybar
                   wl-clipboard
                   zsh-autosuggestions
                   zsh-completions
                   zsh-syntax-highlighting
		   ))
   (services
    (list (service home-zsh-service-type
                   (home-zsh-configuration
                    (zshrc (list 
                            (mixed-text-file "zsh-autosuggestions"
                                             "source $HOME/.guix-home/profile/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh")
                            (mixed-text-file "zsh-syntax-highlighting"
                                             "source $HOME/.guix-home/profile/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh")
                            (mixed-text-file "zsh-completions"
                                             "fpath=($HOME/.guix-home/share/zsh/site-functions $fpath)")
                            (local-file
                             "../files/.zshrc" "zshrc")
                            ))
                    (zprofile (list (local-file
                                     "../files/.zprofile"
                                     "zprofile")))))
          (service home-gpg-agent-service-type
                   (home-gpg-agent-configuration
                    (pinentry-program
                     (file-append (spec->pkg "pinentry-emacs") "/bin/pinentry-emacs"))
                    (ssh-support? #f)
                    (extra-content "allow-loopback-pinentry")))
          
          (service home-openssh-service-type   ;; move identity-files to polterguix/
                   (home-openssh-configuration
                    (hosts
                     (list (openssh-host (name "babylon")
                                         (host-name "192.168.0.111")
                                         (user "pol")
                                         (identity-file "/home/pol/.ssh/babylon")
                                         (port 39902))
                           (openssh-host (name "github")
                                         (host-name "github.com")
                                         (user "git")
                                         (identity-file "/home/pol/.ssh/github_ed25519"))))
                    (add-keys-to-agent "confirm")))
          
          (simple-service 'dotfiles
                          home-xdg-configuration-files-service-type
                          `(("hypr/hyprland.conf"  ,(local-file "../files/hypr/hyprland-akhetaten.conf"))
                            ("hypr/hyprland-base.conf"  ,(local-file "../files/hypr/hyprland-base.conf"))))

          (simple-service 'dotfiles
                          home-xdg-configuration-files-service-type
                          `(("waybar/style.css"  ,(local-file "../files/waybar/style-akhetaten.css"))
                            ("waybar/theme.css"  ,(local-file "../files/waybar/theme.css"))
                            ("waybar/config"  ,(local-file "../files/waybar/config"))))

          (service home-dbus-service-type)
          (service home-pipewire-service-type)
          (service home-network-manager-applet-service-type)
          (service power-profiles-daemon-service-type)
          (service tlp-service-type
                   (tlp-configuration
                    (cpu-scaling-governor-on-ac "schedutil")
                    (cpu-scaling-governor-on-bat "powersave")
                    (pcie-aspm-on-bat "powersupersave")
                    (radeon-dpm-state "battery")
                    (start-charge-thresh-bat0 40)
                    (stop-charge-thresh-bat0 80)))
          (service alsa-service-type)
          (service home-fcitx5-service-type
                   (home-fcitx5-configuration
                    (themes (map specification->package '("fcitx5-material-color-theme")))
                    (input-method-editors (map specification->package '("fcitx5-chinese-addons" "fcitx5-rime")))))
                           
                    ;; trackpoint tuning
          (set-xorg-configuration
           (xorg-configuration
            (keyboard-layout keyboard-layout)
            (extra-config
             '((Section "InputClass"
                        Identifier "Trackpoint"
                        MatchProduct "TPPS/2 IBM TrackPoint"
                        Option "AccelProfile" "flat"
                        Option "Sensitivity" "200"
                        Option "Speed" "1.0"
                        EndSection)))))


          ))))



(if (equal? (getenv "GUIX_TARGET") "home")
    home
    system)





