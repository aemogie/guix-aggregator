(use-modules (nongnu packages linux)
             (nongnu system linux-initrd)
             (gnu))

(use-package-modules admin certs cryptsetup curl version-control)
(use-service-modules desktop networking ssh)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (initrd microcode-initrd)
  (host-name "guix-install")
  (timezone "America/New_York")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us" "dvorak"))

  (packages (cons* btop
                   cryptsetup
                   curl
                   git
                   %base-packages))

  (services
   (cons* (service wpa-supplicant-service-type)
          (service network-manager-service-type)
          (service ntp-service-type)
          (service openssh-service-type)

          (modify-services %base-services
            (guix-service-type
             config => (guix-configuration
                         (inherit config)
                         (authorized-keys
                          (cons* (local-file "nonguix.pub")
                                 %default-authorized-guix-keys))
                         (substitute-urls
                          (cons* "https://substitutes.nonguix.org"
                                 %default-substitute-urls)))))))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

  (swap-devices (list (swap-space
                        (target
                         (uuid "REPLACE-ME")))))

  (file-systems
   (cons* (file-system (mount-point "/")
                       (device
                        (uuid "REPLACE-ME" 'ext4))
                       (type "ext4"))
          (file-system (mount-point "/boot/efi")
                       (device (uuid "REPLACE-ME" 'fat32))
                       (type "vfat"))
          %base-file-systems)))
