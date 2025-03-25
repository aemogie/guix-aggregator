(define-module (lynn))
(use-modules
 (artoria packages games)
 (artoria packages gl)
 (artoria packages php)
 (galahad pure)
 (gnu home services dotfiles)
 (gnu home services guix)
 (gnu home services shells)
 (gnu home services xdg)
 (gnu home services)
 (gnu home services desktop)
 (gnu home)
 (gnu packages admin)
 (gnu packages base)
 (gnu packages compression)
 (gnu packages curl)
 (gnu packages web-browsers)
 (gnu packages emacs)
 (gnu packages emacs-xyz)
 (artoria packages emacs-xyz)
 (gnu packages fonts)
 (gnu packages gnome)
 (gnu packages gnupg)
 (gnu packages image)
 (gnu packages image-viewers)
 (gnu packages imagemagick)
 (gnu packages freedesktop)
 (gnu packages linux)
 (gnu packages llvm)
 (gnu packages ncurses)
 (gnu packages package-management)
 (gnu packages pdf)
 (gnu packages pulseaudio)
 (gnu packages rust-apps)
 (gnu packages shells)
 (gnu packages ssh)
 (gnu packages inkscape)
 (gnu packages messaging)
 (gnu packages game-development)
 (gnu packages terminals)
 (gnu packages tex)
 (gnu packages textutils)
 (gnu packages version-control)
 (gnu packages video)
 (gnu packages wget)
 (gnu packages wm)
 (gnu packages tor-browsers)
 (gnu packages xdisorg)
 (gnu services)
 (guix packages)
 (guix gexp)
 (nongnu packages game-client)
 (nongnu packages messaging)
 (nongnu packages mozilla))

(define %home-packages
  (append (list
	   bat
	   chafa
	   eza
	   fastfetch
	   ffmpeg
	   fish
	   git
	   (list git "send-email")
	   gnupg
	   gnome-keyring
	   grim
	   imagemagick
	   libsixel
	   ncurses
	   powertop
	   ripgrep
	   slurp
	   stow
	   tar
	   vale
	   wget) ; cli
	  ;; (list
	  ;;  texlive-scheme-basic
	  ;;  texlive-courier
	  ;;  texlive-sffms
	  ;;  ) ; LaTeX
	  (list
	   emacs-aggressive-indent
	   emacs-auctex
	   emacs-autothemer
	   emacs-base16-theme
	   emacs-buffer-env
	   emacs-clang-format
	   emacs-consult
	   emacs-company
	   emacs-counsel
	   emacs-dash
	   emacs-doom-modeline
	   emacs-dired-hacks ; dired-subtree
	   emacs-eat
	   emacs-eglot
	   emacs-fish-mode
	   emacs-flycheck
	   emacs-geiser-guile
	   emacs-htmlize
	   emacs-ivy
	   emacs-jsonrpc
	   emacs-ligature
	   emacs-magit
	   emacs-meow
	   emacs-mixed-pitch
	   emacs-nerd-icons
	   emacs-no-littering
	   emacs-olivetti
	   emacs-org-auto-tangle
	   emacs-org-modern
	   emacs-org-roam
	   emacs-paredit
	   emacs-pgtk			; the actual emacs package
	   emacs-php-mode
	   emacs-pinentry
	   emacs-reformatter
	   emacs-rainbow-delimiters
	   emacs-rainbow-mode
	   emacs-simple-httpd
	   emacs-svelte-mode
	   emacs-swiper
	   emacs-typescript-mode
	   emacs-which-key
	   emacs-zig-mode)		; emacs
	  (list
	   foot
	   firefox
	   fnott
	   fuzzel
	   mpv
	   pavucontrol
	   pinentry
	   inkscape
	   nheko
	   libresprite
	   steam-nvidia
	   signal-desktop
	   zathura
	   xdg-desktop-portal-gtk
	   xdg-desktop-portal-wlr
	   zathura-pdf-mupdf)			;wayland-ish
	  (list
	   glfw-wayland-minecraft
	   prismlauncher)
	  (list
	   font-awesome
	   font-iosevka-etoile
	   font-iosevka-term
	   font-google-noto
	   font-google-noto-emoji
	   font-sarasa-gothic)))

(define %bashrc
  (plain-file
   "bashrc"
   "
export SHELL
[ -f /etc/bashrc ] && source /etc/bashrc
export PATH=/run/setuid-programs:$PATH
export PATH=$HOME/.nix-profile/bin:$PATH
export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS
"))

(define %bash-profile
  (plain-file
   "bash_profile"
   "
if [ -f ~/.profile ]; then source ~/.profile fi
if [ -f ~/.bashrc ]; then source ~/.bashrc fi
export PATH=/run/setuid-programs:$PATH
export PATH=$HOME/.nix-profile/bin:$PATH"))

(home-environment
 (packages %home-packages)
 (services
  (list
   (service home-channels-service-type
	    (list %channels-guix
		  %channels-nonguix
		  %channels-artoria))
   (service home-dotfiles-service-type
            (home-dotfiles-configuration
             (layout 'stow)
             (directories '("./dotfiles"))))
   (service home-xdg-user-directories-service-type
	    (home-xdg-user-directories-configuration
	     (desktop "$HOME/desktop/")
	     (documents "$HOME/docs/")
	     (download "$HOME/downloads/")
	     (pictures "$HOME/pics/")
	     (videos "$HOME/videos/")))
   (simple-service 'env-vars home-environment-variables-service-type
		   '(("EDITOR" . "emacs")
		     ("BROWSER" . "firefox")
		     ("XDG_CURRENT_DESKTOP" . "sway")
		     ("WEBKIT_DISABLE_COMPOSITING_MODE" . "1") ;; prevent nyxt from crashing
		     ("TERM" . "xterm-256color")))
   (service home-dbus-service-type)
   (service home-bash-service-type
	    (home-bash-configuration
	     (guix-defaults? #f)
	     (aliases
	      '(("grep" . "grep --color=auto")
		("ll" . "ls -l")
		("ls" . "ls -p --color=auto")
		("lt" . "eza --tree --git-ignore")))
	     (bashrc
	      (list
	       %bashrc))
	     (bash-profile
	      (list
	       %bash-profile)))))))
