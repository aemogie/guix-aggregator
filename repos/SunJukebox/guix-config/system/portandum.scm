(define-module (anon system portandum)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu system)
  #:use-module (gnu system setuid)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  #:use-module (anon services basic))

(use-package-modules audio
                     admin
                     bash
                     certs
		     cryptsetup
                     curl
                     cups
                     databases
                     emacs
                     file-systems
                     fonts
                     freedesktop
                     gnome
                     libusb
                     linux
                     networking
                     nfs
                     package-management
                     shells
                     ssh
                     suckless
                     terminals
                     version-control
                     video
                     vim
                     wm
                     xdisorg)

(use-service-modules admin
                     avahi
                     audio
                     cups
                     dbus
                     desktop
                     docker
                     guix
                     linux
                     mcron
                     networking
                     nix
                     pm
                     ssh
                     sysctl
                     virtualization
                     xorg)

(define-public portandum-operating-system
  (operating-system
   (kernel linux)
   ;; sof-firmware required for sound, linux-firmware takes care of everything else
   (firmware (list linux-firmware
		   sof-firmware))
   (initrd microcode-initrd)
   (locale "en_US.utf8")
   (timezone "America/New_York")
   (keyboard-layout (keyboard-layout "us" "dvp"))
   (host-name "portandum")
   
   ;; The list of user accounts ('root' is implicit).
   (users (cons* (user-account
  		  (name "kyle")
  		  (comment "Kyle O.")
  		  (group "users")
  		  (home-directory "/home/kyle")
  		  (supplementary-groups '("wheel" "netdev" "audio" "video")))
  		 %base-user-accounts))
   
   (packages (cons* bluez
                    btop
  		    cryptsetup
  		    curl
  		    emacs
  		    git
  		    neovim
  		    %base-packages))
   
   (services %basic-services)
   
   (bootloader (bootloader-configuration
  		(bootloader grub-efi-bootloader)
  		(targets (list "/boot/efi"))
  		(keyboard-layout keyboard-layout)))
   (swap-devices (list (swap-space
  			(target (uuid
  				 "78ae9c8b-00ce-400e-8f20-efea7a78697d")))))
   (mapped-devices (list (mapped-device
  			  (source (uuid
  				   "e22ab99f-13eb-4f5c-b27a-0b3eff6512e5"))
  			  (target "home")
  			  (type luks-device-mapping))
  			 (mapped-device
  			  (source (uuid
  				   "2d94777b-f19a-4b5d-9012-e41c38eaba88"))
  			  (target "root")
  			  (type luks-device-mapping))))
   
   ;; The list of file systems that get "mounted".  The unique
   ;; file system identifiers there ("UUIDs") can be obtained
   ;; by running 'blkid' in a terminal.
   (file-systems (cons* (file-system
  			 (mount-point "/home")
  			 (device "/dev/mapper/home")
  			 (type "ext4")
  			 (dependencies mapped-devices))
  		        (file-system
  			 (mount-point "/")
  			 (device "/dev/mapper/root")
  			 (type "ext4")
  			 (dependencies mapped-devices))
  		        (file-system
  			 (mount-point "/boot/efi")
  			 (device (uuid "E22D-5849"
  				       'fat32))
 			 (type "vfat")) %base-file-systems))))

portandum-operating-system
