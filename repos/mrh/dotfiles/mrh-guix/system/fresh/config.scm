(use-modules (nongnu packages linux)
             (nongnu system linux-initrd)
             (gnu))

(use-package-modules admin
                     cryptsetup
                     curl
                     package-management
                     rsync
                     version-control)

(use-service-modules desktop
                     networking
                     ssh)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (initrd microcode-initrd)
  (host-name "guix-install")
  (timezone "America/New_York")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us" "dvorak"))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

  (file-systems
   (cons* (file-system (mount-point "/boot/efi")
                       (device (uuid "REPLACE-ME" 'fat32))
                       (type "vfat"))
          (file-system (mount-point "/")
                       (device
                        (uuid "REPLACE-ME" 'ext4))
                       (type "ext4"))
          %base-file-systems))

  (users (cons (user-account
                 (name "mrh")
                 (group "users")
                 (home-directory "/home/mrh")
                 (supplementary-groups '("audio"
                                         "input"
                                         "lp"
                                         "netdev"
                                         "video"
                                         "wheel")))
               %base-user-accounts))

  (packages (cons* btop
                   cryptsetup
                   curl
                   git
                   rsync
                   stow
                   %base-packages))

  (services
   (cons* (service wpa-supplicant-service-type)
          (service network-manager-service-type)
          (service ntp-service-type)
          (service openssh-service-type
                   (permit-root-login #t))

          (modify-services %base-services
            (guix-service-type
             config => (guix-configuration
                         (inherit config)
                         (authorized-keys
                          (cons* (local-file "nonguix.pub")
                                 %default-authorized-guix-keys))
                         (substitute-urls
                          (cons* "https://substitutes.nonguix.org"
                                 %default-substitute-urls))))))))
