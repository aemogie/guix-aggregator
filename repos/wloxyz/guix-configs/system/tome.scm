(add-to-load-path (dirname (current-filename)))

;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu services linux)
	     (gnu services networking)
	     (gnu packages)
             ;; Import nonfree linux module.
             (nongnu packages linux)
             (nongnu system linux-initrd)
	     ;; unified configuration for all machines
	     (lib common))

(operating-system
 (kernel linux)
 (initrd microcode-initrd)	  ; nonfree but more secure and faster
 (firmware (list linux-firmware)) ; nonfree
 (locale "en_US.utf8")
 (timezone "America/New_York")
 (keyboard-layout (keyboard-layout "us" "colemak-dh"
                                   #:options '("ctrl:nocaps")))
 (host-name "tower")

 (groups wlo-common-groups)
          
 (users wlo-common-accounts)

 (packages wlo-common-packages)

 (services
  (cons* (service zram-device-service-type
		  (zram-device-configuration
		   (size "6G")
		   (compression-algorithm 'zstd)))
         
         (service rootless-podman-service-type
                  (rootless-podman-configuration
                   (subuids (list (subid-range (name "willow"))))
                   (subgids (list (subid-range (name "willow"))))))

	 ;; teh firewallz0rz
	 (service nftables-service-type
		  (nftables-configuration
		   (ruleset (local-file "./nftables-workstation.conf"))))
	 wlo-common-services))

 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets (list "/boot/efi"))
   (keyboard-layout keyboard-layout)))
 ;;; mapped devices & filesystems here
  (mapped-devices (list (mapped-device
                        (source (uuid
                                 "5af6e852-b737-4c24-9fd9-62f0163ad1b2"))
                        (target "cryptroot")
                        (type luks-device-mapping))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/")
                       (device "/dev/mapper/cryptroot")
                       (type "btrfs")
                       (dependencies mapped-devices))
                      (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "6810-74DB"
                                     'fat32))
                       (type "vfat"))
                      %base-file-systems)))
