(define-module (anon system oldcoal)
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

(define-public oldcoal-operating-system
  (operating-system
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))

   (locale "en_US.utf8")
   (timezone "America/New_York")
   (keyboard-layout (keyboard-layout "us" "dvp"))
   (host-name "oldcoal")

   (users (cons* (user-account
                  (name "kyle")
                  (comment "Kyle O.")
                  (group "users")
                  (home-directory "/home/kyle")
                  (supplementary-groups '("wheel" "netdev" "audio" "video"
                                          "docker"))) %base-user-accounts))

   (packages (cons* btop
                    curl
                    ;; emacs-no-x-toolkit
                    git
                    neovim
                    nix
                    %base-packages))

   (services %basic-services)

   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

   (swap-devices (list (swap-space
                        (target (uuid "1ae62a34-b8d9-4b4c-842e-a44df903115f")))))

   ;; The list of file systems that get "mounted".  The unique
   ;; file system identifiers there ("UUIDs") can be obtained
   ;; by running 'blkid' in a terminal.
   (file-systems (cons* (file-system
                         (mount-point "/home")
                         (device (uuid
                                  "524e315e-8939-4114-8367-72749faa7531"
                                  'xfs))
                         (type "xfs"))
                        (file-system
                         (mount-point "/")
                         (device (uuid
                                  "1a9d8b80-b5c4-43a8-a9fa-ba1e863a9089"
                                  'btrfs))
                         (type "btrfs"))
                        (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "D9E1-B54A"
                                       'fat32))
                         (type "vfat")) %base-file-systems))))

oldcoal-operating-system
