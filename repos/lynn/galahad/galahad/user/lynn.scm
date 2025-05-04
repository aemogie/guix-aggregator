(define-module (galahad user lynn)
  #:use-module (gnu packages video)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages messaging)
  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages mozilla)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fcitx5)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages bqn)
  #:use-module (gnu packages apl)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages llvm)
  #:use-module (gnu services) ;simple service
  #:use-module (guix gexp) ;plain-file
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services xdg)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services shells)
  #:use-module (galahad system channels)
  )

(define lynn-wm-packages
  (list mpv
	pavucontrol
	pinentry-qt
	nheko
	signal-desktop
	zathura
	firefox
	fcitx5
	fcitx5-gtk
	cbqn
	apl
					;zsh-autocompletions
					;zsh-syntax-highlighting
					;fzf-tab
	zathura-pdf-mupdf))

(define lynn-font-packages
  (list font-awesome
	font-iosevka-etoile
	font-iosevka-term
	font-google-noto
	font-google-noto-emoji
	font-sarasa-gothic))

(define lynn-emacs-packages
  (list emacs-aggressive-indent
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
	emacs-dired-hacks		; dired-subtree
	emacs-eat
	emacs-eglot
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
	emacs-rainbow-delimiters
	emacs-rainbow-mode
	emacs-simple-httpd
	emacs-swiper
	emacs-typescript-mode
	emacs-outline-indent
	emacs-yaml-mode
	emacs-pinentry
	emacs-which-key
	emacs-bqn-mode
	emacs-zig-mode))

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
 (packages
  (append lynn-wm-packages
	  lynn-font-packages
	  lynn-emacs-packages))
 (services
  (list
   (service home-channels-service-type
	    (list %channels-guix
		  %channels-guix-gaming
		  %channels-nonguix
		  %channels-emacs
		  %channels-artoria))
   (service home-dotfiles-service-type
            (home-dotfiles-configuration
             (layout 'stow)
             (directories '("../../dotfiles"))))
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
		     ("GTK_IM_MODULE" . "fcitx")
		     ("QT_IM_MODULE" . "fcitx")
		     ("XMODIFIERS" . "@im=fcitx")
		     ("INPUT_METHOD" . "fcitx")
		     ("XCOMPOSEFILE" . "$HOME/.XCompose")
		     ("XCOMPOSECACHE" . "$HOME/.xcompose-cache")
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
