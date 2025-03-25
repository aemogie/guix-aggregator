(define-module (polterguix systems core-home)
   #:use-module (gnu)
   #:use-module (gnu home)
   #:use-module (gnu packages)
   #:use-module (gnu packages admin)
   #:use-module (gnu packages xdisorg)
   #:use-module (gnu packages autotools)
   #:use-module (gnu packages package-management)
   #:use-module (gnu packages emacs-xyz)
   #:use-module (gnu packages emacs)
   #:use-module (gnu packages gnupg)
   #:use-module (gnu packages librewolf)
   #:use-module (gnu packages video)
   #:use-module (gnu packages fonts)
   #:use-module (gnu packages base)
   #:use-module (gnu packages pkg-config)
   #:use-module (gnu packages ghostscript)
   #:use-module (gnu packages rust)
   #:use-module (gnu packages rust-apps)
   #:use-module (gnu packages gnupg)
   #:use-module (gnu packages vim)
   #:use-module (gnu packages mail)
   #:use-module (gnu packages password-utils)
   #:use-module (gnu packages wm)
   #:use-module (gnu packages web-browsers)
   #:use-module (gnu packages terminals)
   #:use-module (nongnu packages mozilla)
   #:use-module (gnu services)
   #:use-module (guix gexp)
   #:use-module (gnu home services)
   #:use-module (gnu home services shells)
   #:use-module (gnu home services pm)
   #:use-module (gnu home services gnupg)
   #:use-module (polterguix packages hyprland)
   #:use-module (polterguix packages desktop)
   #:use-module (polterguix packages security)
   #:use-module (polterguix packages cli))

(define-public core-home-services
  (list
    (simple-service 'core-home-environment-variables-service
                    home-environment-variables-service-type
                    '(("VISUAL" . "emacsclient")
                      ("EDITOR" . "emacsclient")
                      ("PATH" . "$HOME/.bin:$HOME/.npm-global/bin:$PATH")
                      ("XDG_DATA_DIRS" . "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share")))

    (service home-bash-service-type
             (home-bash-configuration
              (guix-defaults? #t)
              (bashrc (list (local-file
                             "/home/pol/polterguix/files/.bashrc" "bashrc")))
              (bash-profile (list (local-file
                                   "/home/pol/polterguix/files/.bash_profile"
                                   "bash_profile")))))

    (service home-zsh-service-type
             (home-zsh-configuration
              (zshrc (list
                      (mixed-text-file "zsh-autosuggestions"
                                       "source $HOME/.guix-home/profile/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh")
                      (mixed-text-file "zsh-syntax-highlighting"
                                       "source $HOME/.guix-home/profile/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh")
                      (mixed-text-file "zsh-completions"
                                       "fpath=($HOME/.guix-home/share/zsh/site-functions $fpath)")
                      (local-file
                       "/home/polhuang/polterguix/files/.zshrc" "zshrc")
                      ))
              (zprofile (list (local-file
                               "/home/polhuang/polterguix/files/.zprofile"
                               "zprofile")))))

    (service home-gpg-agent-service-type
             (home-gpg-agent-configuration
              (pinentry-program
               (file-append pinentry-emacs "/bin/pinentry-emacs"))
              (ssh-support? #t)
              (default-cache-ttl 28800)
              (max-cache-ttl 28800)
              (default-cache-ttl-ssh 28800)
              (max-cache-ttl-ssh 28800)))

    ;; mcron jobs
    ;; (service home-mcron-service-type
    ;;          (home-mcron-configuration
    ;;           (jobs
    ;;            (list
    ;;             #~(job
    ;;                '(next-hour (range 0 24 4))
    ;;                "~/.dotfiles/.bin/script.sh")))))

    ;; Monitor battery levels
    (service home-batsignal-service-type)))

;; (define home
;;   (home-environment
;;    (services (cons* (service example)
;;                     core-home-services))
;;    (packages (list pinentry
;;                    pinentry-emacs
;;                    emacs-next-pgtk-xwidgets
;;                    emacs-desktop-environment
;;                    emacs-guix
;;                    emacs-jinx
;;                    firefox
;;                    asciiquarium
;;                    kitty
;;                    qutebrowser
;;                    font-fira-code
;;                    rofi-wayland
;;                    font-google-noto
;;                    font-google-noto-emoji
;;                    font-google-noto-sans-cjk 
;;                    mu
;;                    gnupg-new
;; 		   automake
;;                    emacs-jinx
;;                    btop
;; 		   libtool
;;                    librewolf
;; 		   flatpak
;; 		   font-fira-code
;; 		   password-store
;; 		   binutils
;; 		   pkg-config
;;                    waybar
;; 		   font-ghostscript
;; 		   font-dejavu
;; 		   font-gnu-freefont
;;                    swaynotificationcenter
;;                    neovim
;;                    obs
;;                    rust
;;                    rust-cargo
;;                    hyprpaper
;;                    hypridle
;;                    starship-bin))))
;; home
