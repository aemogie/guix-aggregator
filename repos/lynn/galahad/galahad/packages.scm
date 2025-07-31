(define-module (galahad packages)
  #:use-module (gnu packages admin) ;inetutils
  #:use-module (gnu packages base) ;findutils
  #:use-module (gnu packages certs)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages debian)
  #:use-module (gnu packages file)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages glib) ;dbus
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages less)
  #:use-module (gnu packages rust-apps) ;bat
  #:use-module (gnu packages linux) ;light
  #:use-module (gnu packages man)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages package-management) ;stow
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages image) ;grim
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages xdisorg) ;fuzzel
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages texinfo) ;info-reader
  #:use-module (gnu packages vim) ;xxd?
  #:use-module (gnu packages wm)

  #:export (galahad-system-packages))

(define galahad-utils-packages
  (list acpi
	bat
	eza
        coreutils
        curl
        dbus
        debianutils
        e2fsprogs
        eudev
        file
        findutils
        gawk
        grep
        gzip
	tar
	ripgrep
        inetutils
        iproute
        kbd
        kmod
        less
        man-db
        man-pages
        nss-certs
	ncurses ;; literally only for 'clear' command
        procps
	gnupg
        psmisc
        shadow
        unzip
        usbutils
        util-linux
        xxd
        xz))

(define galahad-cli-packages
  (list bash-minimal
	zsh
	stow
	btop
	hyfetch
	gnome-keyring
	guile-3.0
	info-reader
	git
	neovim
	openssh))

(define galahad-wm-packages
  (list swaybg
        waybar
        swayfx
        swayidle
        swaylock-effects
	grim
	slurp
	foot
	fuzzel
	zathura
	fnott
        light))

(define galahad-system-packages
  (append galahad-utils-packages
	  galahad-cli-packages
	  galahad-wm-packages))
