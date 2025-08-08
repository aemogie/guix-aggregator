(define-module (galahad user lynn)
  #:use-module (gnu packages video)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages messaging)
  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages mozilla)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fcitx5)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages bqn)
  #:use-module (gnu packages web-browsers)
  #:use-module (gnu packages apl)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages shells)
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
  #:use-module (galahad packages foot files)
  #:use-module (galahad packages waybar files)
  #:use-module (galahad packages qutebrowser files)
  #:use-module (galahad packages emacs info)
  #:use-module (galahad system channels))

(define lynn-wm-packages
  (list mpv
	pavucontrol
	pinentry
	pinentry-qt
	nheko
	signal-desktop
	zathura
	firefox
	qutebrowser
	fastfetch
	hyfetch
	fcitx5
	fcitx5-gtk
	xdg-utils
	xdg-desktop-portal
	xdg-desktop-portal-gtk
	zsh-autosuggestions
	zsh-syntax-highlighting
	libinput
	zathura-pdf-mupdf))

(define lynn-font-packages
  (list font-awesome
	font-iosevka-etoile
	font-iosevka-term
	font-google-noto
	font-google-noto-emoji
	font-sarasa-gothic))

(home-environment
 (packages
  (append lynn-wm-packages
	  lynn-font-packages
	  (emacs-packages)))
 (services
  (list
   (service home-channels-service-type
	    (list %channels-guix
		  %channels-guix-gaming
		  %channels-nonguix))
   (service home-dotfiles-service-type
            (home-dotfiles-configuration
             (layout 'stow)
             (directories '("../../dotfiles"))))
   (simple-service
    'dotfiles-service
    home-files-service-type
    (append (foot-files)
	    (qutebrowser-files)
	    (emacs-files)
	    (waybar-files)))
   (service home-xdg-mime-applications-service-type
	    (home-xdg-mime-applications-configuration
	     (default '((inode/directory . emacs-dired.desktop)))
	     (desktop-entries
	      (list (xdg-desktop-entry
		     (file "emacs-dired")
		     (name "Emacs Dired as a filemanager")
		     (type 'application)
		     (config
		      '((exec . "emacsclient -c -a emacs %u")
			(mimetype . "inode/directory"))))))))
   (service home-xdg-user-directories-service-type
	    (home-xdg-user-directories-configuration
	     (desktop "$HOME/desktop/")
	     (documents "$HOME/docs/")
	     (download "$HOME/downloads/")
	     (pictures "$HOME/pics/")
	     (videos "$HOME/videos/")))
   (service home-zsh-service-type
	    (home-zsh-configuration
	     (zshrc (list (local-file "../packages/zshrc"))))) ;;obviously should be a scheme file!
   
   (simple-service 'env-vars home-environment-variables-service-type
		   `(("SHELL" . ,(file-append zsh "/bin/zsh"))
		     ("EDITOR" . "emacs")
		     ("BROWSER" . "firefox")
		     ("XDG_CURRENT_DESKTOP" . "sway")
		     ("QT_QPA_PLATFORMTHEME" . "qt6ct")
		     ("GTK_IM_MODULE" . "fcitx")
		     ("QT_IM_MODULE" . "fcitx")
		     ("XMODIFIERS" . "@im=fcitx")
		     ("INPUT_METHOD" . "fcitx")
		     ("XCOMPOSEFILE" . "$HOME/.XCompose")
		     ("XCOMPOSECACHE" . "$HOME/.xcompose-cache")
		     ("WEBKIT_DISABLE_COMPOSITING_MODE" . "1") ;; prevent nyxt from crashing
		     ("TERM" . "xterm-256color")))
   (service home-dbus-service-type))))
