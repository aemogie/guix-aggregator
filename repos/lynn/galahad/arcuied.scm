(use-modules
 (galahad pure)
 (gnu bootloader grub)
 (gnu bootloader)
 (gnu packages admin)
 (gnu packages bash)
 (gnu packages base)
 (gnu packages certs)
 (gnu packages compression)
 (gnu packages curl)
 (gnu packages debian)
 (gnu packages file)
 (gnu packages gawk)
 (gnu packages guile)
 (gnu packages gnome)
 (gnu packages less)
 (gnu packages linux)
 (gnu packages man)
 (gnu packages ssh)
 (gnu packages texinfo)
 (gnu packages wm)
 (gnu packages vim)
 (gnu services base) ; guix-service-type
 (gnu services cups)
 (gnu services desktop)
 (gnu services nix)
 (gnu services pm)
 (gnu services xorg) ; gdm-service-type
 (gnu system file-systems)
 (gnu system keyboard)
 (guix gexp)
 (nongnu packages linux))

(define %system-packages
  (list
   btop inetutils isc-dhcp opendoas openssh shadow ;; admin
   debianutils findutils coreutils bash file curl gawk grep less gzip unzip xz ;; cli
   man-db man-pages ;; man
   info-reader ;; texinfo
   guile-3.0 ;; guile
   nss-certs ;; certs
   gnome-keyring ;; signing &c
   acpi e2fsprogs eudev iproute kbd kmod procps psmisc usbutils util-linux ;; linux
   neovim ;; tty editor
   ))
(define %wayland-sway-packages
  (list
   swayfx swayidle waybar ;; wm
   light ;; brightness
   ))
(define %arc-packages
  (append %system-packages
	  %wayland-sway-packages))
(operating-system
 (kernel linux)
 (kernel-arguments '("quiet" "splash"))
 (firmware (list linux-firmware))
 (locale "en_US.UTF-8")
 (timezone "Europe/Berlin")
 (keyboard-layout (keyboard-layout "us,de"
				   #:options '("ctrl:nocaps"))) ; needs altered
 (host-name "arcueid")
 (users (cons* (user-account
		(name "lynn")
		(group "users")
		(home-directory "/home/lynn")
		(supplementary-groups '("wheel" "netdev" "audio" "video")))
	       %base-user-accounts))
 (packages %arc-packages)
 (services
  (append
   (modify-services %desktop-services
		    (guix-service-type
		     config => (guix-configuration
				(inherit config)
				(substitute-urls
				 (append (list "https://substitutes.nonguix.org")
					 %default-substitute-urls))
				(authorized-keys
				 (append
				  (list %authorized-guix-key-nonguix)
				  %default-authorized-guix-keys))))
		    (delete gdm-service-type))
   (list
    (service nix-service-type)
    (service tlp-service-type)
    (service cups-service-type
             (cups-configuration
              (web-interface? #t)))
    (service gnome-keyring-service-type)
    (udev-rules-service 'light light))))

 (bootloader (bootloader-configuration
	      (bootloader grub-efi-bootloader)
	      (targets (list "/boot/efi"))
	      (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
		      (target (uuid
			       "19fb704c-ec99-469e-b8f1-2148785a085c")))))
 (file-systems (cons* (file-system
		       (mount-point "/boot/efi")
		       (device (uuid "6332-F4BA"
				     'fat32))
		       (type "vfat"))
		      (file-system
		       (mount-point "/")
		       (device (uuid
				"61c7fcef-5dd4-4a86-988d-da53f973a0e5"
				'ext4))
		       (type "ext4"))
		      (file-system
		       (mount-point "/home")
		       (device (uuid
				"a6b3eb0b-456d-4a31-9131-6dc3fa28ca3a"
				'ext4))
		       (type "ext4")) %base-file-systems)))
