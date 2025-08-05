(define-module (vm_config))
(use-modules (guix store)
             (gnu)
             (srfi srfi-1))
(use-service-modules
  admin
  linux
  networking
  ssh)

;; One file, no guix-config checkout.
(define %efraim-ssh-key
  (plain-file "id_ed25519.pub"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3PkIpyUbnAtS8B5oO1rDm2vW5xhArIVjaRJrZzHVkX efraim@flashner.co.il"))

(operating-system
  (host-name "guix_vm")
  (timezone "Etc/UTC")
  (locale "en_US.UTF-8")

  ;; Choose either grub or grub-efi.
  ;; Check 'lsblk' if grub for '/dev/vda' replacement.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/vda"))
                ;(bootloader grub-efi-bootloader)
                ;(target "/boot/efi")
                (terminal-outputs '(console))))

  (firmware '())

  (file-systems
    (cons* (file-system
             (mount-point "/")
             ;; lsblk --output MOUNTPOINT,UUID
             (device (uuid "0000-0000" 'fat))
             (type "ext4"))
           ;; This is only necessary if you're using EFI.
           ;(file-system
           ;  (device (uuid "0000-0000" 'fat))
           ;  (mount-point "/boot/efi")
           ;  (type "vfat"))
           (file-system
             (device "tmpfs")
             (mount-point "/var/guix/temproots")
             (type "tmpfs")
             (flags '(no-suid no-dev no-exec))
             (check? #f))
           %base-file-systems))

  ;; Be sure you create the swpfile first!
  ;(swap-devices
  ;  (list (swap-space
  ;          (target "/swapfile"))))

  (users (cons (user-account
                (name "efraim")
                (comment "Efraim")
                (group "users")
                (supplementary-groups '("wheel" "netdev" "kvm"))
                (password "$6$4t79wXvnVk$bjwOl0YCkILfyWbr1BBxiPxJ0GJhdFrPdbBjndFjZpqHwd9poOpq2x5WtdWPWElK8tQ8rHJLg3mJ4ZfjrQekL1")
                (home-directory "/home/efraim"))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (cons* %base-packages))

  (services
    (cons* (service openssh-service-type
                    (openssh-configuration
                      (openssh (specification->package "openssh-sans-x"))
                      (authorized-keys
                        `(("efraim" ,%efraim-ssh-key)))
                      (extra-content "StreamLocalBindUnlink yes")))

           #;(service tor-service-type
                    (tor-configuration
                      (hidden-services
                        (list
                          (tor-onion-service-configuration
                            (name "ssh")
                            (mapping '((22 "127.0.0.1:22"))))))))

           (service openntpd-service-type
                    (openntpd-configuration
                      (listen-on '("127.0.0.1" "::1"))
                      (constraints-from '("https://www.google.com/"))))

           (service zram-device-service-type
                    (zram-device-configuration
                      (size (* 1 (expt 2 30)))
                      (compression-algorithm 'zstd)
                      (priority 100)))

           ;; For networking
           (service dhcpcd-service-type)

           (modify-services
             %base-services
             ;; The default udev rules are not needed in a VM.
             ;; TODO: Remove udev entirely?
             (udev-service-type config =>
                                (udev-configuration
                                  (inherit config)
                                  (rules '())))
             #;(guix-service-type config =>
             (guix-configuration
               (inherit config))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
