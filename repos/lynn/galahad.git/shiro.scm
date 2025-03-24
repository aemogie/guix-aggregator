(use-modules
 (srfi srfi-1)
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
 (gnu packages games)
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
 (gnu services docker)
 (gnu services sddm)
 (gnu packages kde-plasma)
 (gnu services networking)
 (gnu services xorg) ; gdm-service-type
 (gnu system file-systems)
 (gnu system keyboard)
 (guix gexp)
 (nongnu packages linux)
 (nongnu packages nvidia)
 (nongnu services nvidia))

(define %system-packages
  (list
   btop inetutils isc-dhcp opendoas openssh shadow ;; admin
   debianutils findutils coreutils bash file curl gawk grep less gzip unzip xz ;; cli
   man-db man-pages ;; man
   info-reader ;; texinfo
   guile-3.0 ;; guile
   nss-certs ;; certs
   acpi e2fsprogs eudev iproute kbd kmod procps psmisc usbutils util-linux ;; linux
   neovim ;; tty editor
   ))
(define %wayland-sway-packages
  (list
   light ;; brightness
   steam-devices-udev-rules
   ))
(define %shiro-packages
  (append %system-packages
	  %wayland-sway-packages))
(define %shiro-desktop-services
  (remove (lambda (service)
	    (equal? (service-type-name (service-kind service))
				       'network-manager-applet))
	    %desktop-services))
(operating-system
 (kernel linux)
 (kernel-arguments '("quiet" "splash" "modprobe.blacklist=nouveau" "nvidia-drm.modeset=1"))
 (firmware (list linux-firmware))
 (locale "en_US.UTF-8")
 (timezone "Europe/Berlin")
 (keyboard-layout (keyboard-layout "us,de"
				   #:options '("ctrl:nocaps"))) ; needs altered
 (host-name "shiro")
 (users (cons* (user-account
		(name "lynn")
		(group "users")
		(home-directory "/home/lynn")
		(supplementary-groups '("wheel" "netdev" "audio" "video" "docker")))
	       %base-user-accounts))
 (packages %shiro-packages)
 (services
  (append
   (modify-services %shiro-desktop-services
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
					;(set-xorg-configuration
					;(xorg-configuration (keyboard-layout keyboard-layout)
					;			 (modules (cons* nvda %default-xorg-modules))
					;			 (drivers '("nvidia"))))

    (service plasma-desktop-service-type
	     (plasma-desktop-configuration
	      (plasma-package (replace-mesa plasma))))
    (service sddm-service-type
	     (sddm-configuration
	      (theme "breeze")))
    (service nvidia-service-type)
    (service nix-service-type)
    (service tlp-service-type)
    (service containerd-service-type)
    (service docker-service-type)
    (udev-rules-service 'steam-devices steam-devices-udev-rules)
    (udev-rules-service 'light light))))

 (bootloader (bootloader-configuration
	      (bootloader grub-efi-bootloader)
	      (targets (list "/boot/efi"))
	      (keyboard-layout keyboard-layout)))

 (swap-devices (list (swap-space
                      (target (uuid
                               "7dddba60-e708-48e7-8058-8d0394c5081a")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "C146-D169"
                                     'fat32))
                       (type "vfat"))
                      (file-system
                       (mount-point "/")
                       (device (uuid
                                "163e8f1f-2e04-4c5c-928b-4825a030a295"
                                'ext4))
                       (type "ext4"))
                      (file-system
                       (mount-point "/home")
                       (device (uuid
                                "5582217a-7ea4-4666-8fec-11ec1d766db1"
                                'ext4))
                       (type "ext4")) %base-file-systems)))
