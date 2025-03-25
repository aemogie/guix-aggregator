(define-module (mrh-guix home box)
  #:use-module (gnu)

  #:use-module (gnu services)

  #:use-module (gnu system shadow)

  #:use-module (gnu home)

  #:use-module (gnu home services)

  #:use-module (gnu home services shells)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services syncthing)

  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages game-development))

(use-package-modules emacs
		             emacs-xyz
                     finance
		             fonts
		             games
		             gnome
		             image-viewers
		             librewolf
		             linux
                     passwordutils
                     rsync
		             terminals
		             video
		             wm
		             xdisorg
		             xorg)

(define-public  box-home-config
  (home-environment
   (packages
    (list acpi
          alacritty
	      dunst
          monero
		  rsync

	      emacs-next
	      emacs-bluetooth
          emacs-aggressive-indent
          emacs-bluetooth
          emacs-consult
          emacs-corfu
          emacs-diredfl
          emacs-doom-modeline
          emacs-eat
          emacs-expand-region
          emacs-geiser-guile
          emacs-gruvbox-theme
          emacs-magit
          emacs-marginalia
          emacs-markdown-mode
          emacs-orderless
          emacs-org-bullets
          emacs-paredit
          emacs-pinentry
          emacs-rainbow-delimiters
          emacs-tldr
          emacs-vertico
          emacs-wgrep

	      feh
	      font-awesome
	      font-google-noto
	      font-google-noto-emoji
	      font-google-noto-sans-cjk
	      font-google-noto-serif-cjk
	      font-hack
          keepassxc
	      libnotify
	      librewolf
	      libsteam
	      mpv
	      rofi
	      setxkbmap
	      signal-desktop
	      steam-devices-udev-rules
	      (specification->package "steam-nvidia")
	      xrandr
	      yt-dlp))

   (services
    (list (service home-dbus-service-type)
	      (service home-bash-service-type)
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

	      (service home-files-service-type
		           `((".Xdefaults" ,%default-xdefaults)))

	      (service home-xdg-configuration-files-service-type
		           `(("gdb/gdbinit" ,%default-gdbinit)))))))

box-home-config
