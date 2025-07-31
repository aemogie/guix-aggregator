(define-module (galahad system)
  #:use-module (galahad host)
  #:use-module (galahad packages)
  #:use-module (galahad system channels)
  #:use-module (gnu packages linux) ;light
  #:use-module (gnu packages shells)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages admin) ;inetutils
  #:use-module (gnu packages base) ;findutils
  #:use-module (gnu packages certs)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages debian)
  #:use-module (gnu packages file)
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
  #:use-module (gnu packages bash)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages texinfo) ;info-reader
  #:use-module (gnu packages vim) ;xxd?
  #:use-module (gnu packages wm)
  #:use-module (gnu services cups)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop) ;sane-service-type
  #:use-module (gnu services networking)
  #:use-module (gnu services sound) ;pulseaudio-service-type
  #:use-module (gnu services xorg) ;screen-locker-service-type
  #:use-module (gnu services avahi)
  #:use-module (gnu services)
  #:use-module (gnu)
  #:use-module (guix packages)
  #:use-module (guix)
  #:use-module (nongnu packages linux))



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

(define galahad-user-lynn
  (user-account
   (name "lynn")
   (group "users")
   (shell (file-append zsh "/bin/zsh"))
   (supplementary-groups '("wheel" "netdev" "audio" "video"))))

(define galahad-desktop-services
  (cons*
   (simple-service 'podman-subuid-subgid
		   etc-service-type
                   `(("subuid" ,(plain-file "subuid"
                                            (string-append "lynn"
                                                           ":100000:65536\n")))
                     ("subgid" ,(plain-file "subgid"
                                            (string-append "lynn"
                                                           ":100000:65536\n")))))

   ;; Add udev rules for scanners.
   (service sane-service-type)
   ;; CUPS for printers.
   (service cups-service-type
            (cups-configuration (web-interface? #t)
                                (default-paper-size "a4")))
   ;; Add polkit rules, so that non-root users in the wheel group can
   ;; perform administrative tasks (similar to "sudo").
   polkit-wheel-service
   ;; The global fontconfig cache directory can sometimes contain
   ;; stale entries, possibly referencing fonts that have been GC'd,
   ;; so mount it read-only.
   fontconfig-file-system-service
   ;; NetworkManager. Applet not included as it causes issues with
   ;; nvidia.
   (service network-manager-service-type)
   (service wpa-supplicant-service-type)    ;needed by NetworkManager
   (service modem-manager-service-type)
   (service usb-modeswitch-service-type)
   ;; The D-Bus clique.
   (service avahi-service-type)
   (service udisks-service-type)
   (service upower-service-type)
   (service accountsservice-service-type)
   (service cups-pk-helper-service-type)
   (service colord-service-type)
   (service geoclue-service-type)
   (service polkit-service-type)
   (service elogind-service-type)
   (service dbus-root-service-type)
   ;; Network time protocol to synchronize time.
   ;; TODO: consider openntpd.
   (service ntp-service-type)
   (service x11-socket-directory-service-type)
   ;; Audio services.
   ;; TODO: look into if pipewire can replace this?
   (service pulseaudio-service-type)
   (service alsa-service-type)
   
   (service gnome-keyring-service-type)
   (udev-rules-service 'light light)
   ;; Screen lock is important if using a desktop environment, for
   ;; security.
   (service screen-locker-service-type
            (screen-locker-configuration (name "swaylock")
                                         (program (file-append
                                                   swaylock-effects
                                                   "/bin/swaylock"))
                                         (using-pam? #t)
                                         (using-setuid? #f)))
   (modify-services %base-services
		    (guix-service-type
		     config => (guix-configuration
				(inherit config)
				(substitute-urls
				 (append (list "https://substitutes.nonguix.org")
					 %default-substitute-urls))
				(authorized-keys
				 (append
				  (list %authorized-guix-key-nonguix)
				  %default-authorized-guix-keys)))))))

(operating-system
 (host-name galahad-hostname)
 (timezone galahad-timezone)
 (locale (format #f "~a.utf8" galahad-language))
 (bootloader (bootloader-configuration
	      (bootloader grub-efi-bootloader)
	      (targets (list "/boot/efi"))))
 (kernel linux)
 (kernel-arguments
  '("quiet" "splash"))
 (firmware
  (list linux-firmware))

  (swap-devices (list (swap-space
                        (target (uuid
                                 "0881fb03-4053-4010-b3b7-5a9ea35ccf60")))))

  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "6332-F4BA"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "d2c8af8a-5b78-4aa6-930d-1ac1b0d237ca"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/home")
                         (device (uuid
                                  "14f1680f-52d6-4285-bef9-41a4946803f0"
                                  'ext4))
                         (type "ext4")) %base-file-systems))
 (users
  (cons* galahad-user-lynn %base-user-accounts))
 (packages
  (append galahad-system-packages galahad-per-host-packages))
 (services galahad-desktop-services))

