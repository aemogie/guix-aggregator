(define-module (lemote))
(use-modules (guix packages)
             (gnu)
             (gnu system locale)
             (config filesystems)
             (config guix-daemon)
             (srfi srfi-1))
(use-service-modules
  linux
  ;mcron
  networking
  ssh)
(use-package-modules
  connman
  linux)

(operating-system
  (host-name "lemote")
  (timezone "Asia/Jerusalem")
  (locale "en_US.UTF-8")
  (locale-definitions
    (list (locale-definition (source "en_US")
                             (name "en_US.UTF-8"))
          (locale-definition (source "he_IL")
                             (name "he_IL.UTF-8"))))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/sda"))))

  (firmware '())

  (initrd-modules '())
  (kernel linux-libre-mips64el-fuloong2e)

  (file-systems (cons* (file-system
                         (device (file-system-label "root"))
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device (file-system-label "boot"))
                         (mount-point "/boot")
                         (type "ext2"))
                       %guix-temproots
                       %base-file-systems))

  (users (cons (user-account
                (name "efraim")
                (comment "Efraim")
                (group "users")
                (supplementary-groups '("wheel"
                                        "netdev" "kvm"))
                (home-directory "/home/efraim"))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (cons* ;btrfs-progs compsize
                   (delete (specification->package "guix-icons") %base-packages)))

  (services (cons* ;(service agetty-service-type
                   ;         (agetty-configuration
                   ;           (extra-options '("-L")) ; no carrier detect
                   ;           (baud-rate "115200")
                   ;           (term "vt100")
                   ;           (tty "ttyS0")))

                   (service guix-publish-service-type
                            (guix-publish-configuration
                              (host "0.0.0.0")
                              (port 3000)))
                   (service openssh-service-type
                            (openssh-configuration
                              (x11-forwarding? #t)
                              (extra-content "StreamLocalBindUnlink yes")))

                   ;(service tor-service-type)
                   ;(tor-hidden-service "ssh"
                   ;                    '((22 "127.0.0.1:22")))
                   ;(tor-hidden-service "guix-publish"
                   ;                    '((3000 "127.0.0.1:3000")))

                   ;; Image created with ext4
                   ;(service mcron-service-type
                   ;         (mcron-configuration
                   ;           (jobs (%btrfs-maintenance-jobs "/"))))

                   ;(service openntpd-service-type
                   ;         (openntpd-configuration
                   ;           (listen-on '("127.0.0.1" "::1"))
                   ;           (allow-large-adjustment? #t)))

                   ;; elogind cannot be cross compiled
                   ;(service connman-service-type)
                   ;(service wpa-supplicant-service-type)

                   ;; Not supported by the chosen kernel
                   ;(service zram-device-service-type
                   ;         (zram-device-configuration
                   ;           (size (* 2 (expt 2 30)))
                   ;           (compression-algorithm 'zstd)
                   ;           (priority 100)))

                   (modify-services
                     %base-services
                     (guix-service-type
                       config =>
                       (guix-configuration
                         (inherit config)
                         (substitute-urls %substitute-urls)
                         (authorized-keys %authorized-keys)
                         (extra-options %extra-options))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
