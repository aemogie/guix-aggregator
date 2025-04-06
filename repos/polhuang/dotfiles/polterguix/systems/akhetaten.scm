(define-module (polterguix systems akhetaten)
  #:use-module (gnu)
  #:use-module (gnu home)
  ;;  #:use-module (gnu packages)
  ;;  #:use-module (gnu packages autotools)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  ;;  #:use-module (gnu packages librewolf)
  #:use-module (gnu packages fonts)
  ;;  #:use-module (gnu packages base)
  ;;  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages hunspell)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages librewolf)
  #:use-module (gnu packages mail)
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
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages mozilla)
  #:use-module (polterguix packages cli)
  #:use-module (polterguix packages desktop)
  #:use-module (polterguix packages fonts-extra)
  ;;  #:use-module (gnu services)
  ;;  #:use-module (gnu services networking)
   
  ;;  #:use-module (gnu services ssh)
  
  ;; #:use-module (gnu services xorg)

   
  ;;  #:use-module (guix gexp)
  ;;  #:use-module (polterguix packages desktop)
  ;;  #:use-module (polterguix packages security)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services ssh)
  
  #:use-module (polterguix systems core-system))

(define system
  (operating-system
   (inherit core-operating-system)
   (host-name "akhetaten"
              )

   ;; (firmware (list linux-firmware radeon-firmware))

   (mapped-devices (list (mapped-device
                          (source (uuid
                                   "6d1b69cb-10b9-43a0-8eee-6a186c73bb5b"))
                          (target "cryptakhetaten")
                          (type luks-device-mapping))))

   (swap-devices (list (swap-space (target "/swap/swapfile")
                                   (dependencies mapped-devices))))

   (kernel-arguments
    (cons* "resume=/dev/mapper/cryptakhetaten"
           "resume_offset=4385429"
           %default-kernel-arguments))
   
   ;; placeholder file system
   (file-systems (cons* (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptakhetaten")
                         (type "btrfs")
                         (dependencies mapped-devices))
                        (file-system
                         (device (uuid "2322-F702"
                                       'fat32))
                         (mount-point "/boot/efi")
                         (type "vfat"))
                        %base-file-systems))))


(define home
  (home-environment
   (packages (list asciiquarium
                   binutils
                   btop
                   cliphist
                   emacs-next-pgtk
                   emacs-guix
                   emacs-jinx
                   firefox
                   font-fira-code
                   font-google-material-design-icons
                   font-google-noto
                   font-google-noto-emoji
                   font-google-noto-sans-cjk
                   font-jetbrains-mono
                   font-jetbrains-mono-nerd
		   flatpak
		   font-dejavu
		   font-fira-code
		   font-ghostscript
		   font-gnu-freefont
                   fzf
                   gcc
                   glibc
                   hunspell
                   hyprpaper
                   kitty
                   libreoffice
		   librewolf
                   mu
                   neofetch
                   neovim
                   obs
                   qutebrowser
		   password-store
                   pinentry
                   pinentry-emacs
                   ripgrep
                   rofi-wayland
                   rust
                   rust-analyzer
                   sh-z
                   starship-bin
                   swaynotificationcenter
                   waybar
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
                            ("waybar/config"  ,(local-file "../files/waybar/config"))))))))

(if (equal? (getenv "GUIX_TARGET") "home")
    home
    system)





