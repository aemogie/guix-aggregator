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
             (gnu services containers)
             (gnu system accounts)
             ;; (small-guix system accounts)
             (gnu system nss)
	     ;; unified configuration for all machines
	     (lib common))

(operating-system
  
  (kernel linux)
  (initrd microcode-initrd)	  ; nonfree but more secure and faster
  (firmware (list linux-firmware)) ; nonfree
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "tower")

  (groups wlo-common-groups)
  
  (users wlo-common-accounts)

  (packages wlo-common-packages)

  (services
   (cons* (service zram-device-service-type
		   (zram-device-configuration
		    (size "56G")
		    (compression-algorithm 'zstd)))

          ;; ;; see: https://issues.guix.gnu.org/72740
          (service rootless-podman-service-type
                   (rootless-podman-configuration
                    (subuids (list (subid-range (name "willow"))))
                    (subgids (list (subid-range (name "willow"))))))

          ;; teh firewallz0rz
	  (service nftables-service-type
		   (nftables-configuration
		    (ruleset (local-file "./nftables-workstation.conf"))))
	  wlo-common-services))

  (name-service-switch %mdns-host-lookup-nss)
  
  (bootloader
   (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets (list "/boot/efi"))
    (keyboard-layout keyboard-layout)))

  (mapped-devices
   (list (mapped-device
          (source (uuid
                   "2c465937-b93c-4153-b094-0eda5f469ec5"))
          (target "cryptos")
          (type luks-device-mapping))
         (mapped-device
          (source (uuid
                   "9c0e3caf-b336-4ea0-8aff-4377e3b8feb3"))
          (target "cryptdata-hdd")
          (type luks-device-mapping))
         (mapped-device
          (source (uuid
                   "be7789dc-2ce0-451c-92fb-ff80630e2f24"))
          (target "cryptdata-nvme")
          (type luks-device-mapping))))


  (file-systems
   ;; The list of file systems that get "mounted".  The unique
   ;; file system identifiers there ("UUIDs") can be obtained
   ;; by running 'blkid' in a terminal.
   (cons* (file-system
            (mount-point "/")
            (device "/dev/mapper/cryptos")
            (type "btrfs")
            (options "subvol=@guixsd-root,compress=zstd")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/gnu/store")
            (device "/dev/mapper/cryptos")
            (type "btrfs")
            (options "subvol=@guix,compress=zstd")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/boot")
            (device "/dev/mapper/cryptos")
            (type "btrfs")
            (options "subvol=@guixsd-boot,compress=zstd")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/home")
            (device "/dev/mapper/cryptdata-nvme")
            (type "btrfs")
            (options "subvol=@guixsd-home,compress=zstd")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/var/lib/libvirt/images/")
            (device "/dev/mapper/cryptdata-nvme")
            (type "btrfs")
            (options "subvol=@vm")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/home/willow/Music")
            (device "/dev/mapper/cryptdata-hdd")
            (type "btrfs")
            (options "subvol=@music,compress=zstd")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/home/willow/Downloads")
            (device "/dev/mapper/cryptdata-hdd")
            (type "btrfs")
            (options "subvol=@downloads,compress=zstd")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/home/willow/Documents/Archive")
            (device "/dev/mapper/cryptdata-hdd")
            (type "btrfs")
            (options "subvol=@archive,compress=zstd")
            (dependencies mapped-devices))
          (file-system
            (mount-point "/boot/efi")
            (device (uuid "48AF-2D52"
                          'fat32))
            (type "vfat"))
          %base-file-systems)))


