(define-module (E5400_config))
(use-modules (guix store)
             (guix gexp)
             (gnu)
             (gnu system locale)
             (config filesystems)
             (config guix-daemon)
             (srfi srfi-1))
(use-service-modules
  cups
  desktop
  linux
  mcron
  networking
  ssh
  xorg)
(use-package-modules
  cups
  fonts
  gnome
  linux
  pulseaudio)

(operating-system
  (host-name "E5400")
  (timezone "Asia/Jerusalem")
  (locale "en_US.UTF-8")
  (locale-definitions
    (list (locale-definition (source "en_US")
                             (name "en_US.UTF-8"))
          (locale-definition (source "he_IL")
                             (name "he_IL.UTF-8"))))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/sda" "/dev/sdb" "/dev/sdc"))))

  (file-systems (cons* (file-system
                         (device (file-system-label "root"))
                         (mount-point "/")
                         (type "btrfs")
                         (options "compress=zstd,discard,ssd_spread,space_cache=v2"))
                       (file-system
                         (device (file-system-label "data"))
                         (mount-point "/data")
                         (mount-may-fail? #t)
                         (type "btrfs")
                         (options "compress=zstd,space_cache=v2"))
                       %guix-temproots
                       %base-file-systems))

  (swap-devices
    (list (swap-space
            (priority 50)
            (target (uuid "66e10e64-e066-4c77-9ce7-63198f98aa88")))))

  (users (cons* (user-account
                 (name "efraim")
                 (comment "Efraim")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev" "kvm"
                                         "lp" "lpadmin"
                                         "audio" "video"))
                 (home-directory "/home/efraim"))
                (user-account
                 (name "kids")
                 (comment "both kids")
                 (group "users")
                 (supplementary-groups '("netdev"
                                         "audio" "video"))
                 (home-directory "/home/kids"))
                %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (cons* gvfs              ;for user mounts
                   pavucontrol
                   btrfs-progs compsize
                   font-terminus font-dejavu
                   font-opendyslexic
                   %base-packages))

  (services (cons* (service xfce-desktop-service-type)

                   (service guix-publish-service-type
                            (guix-publish-configuration
                              (host "0.0.0.0")
                              (port 3000)
                              (advertise? #t)))
                   (service openssh-service-type
                            (openssh-configuration
                              (password-authentication? #t)))

                   (service tor-service-type
                            (tor-configuration
                              (hidden-services
                                (list
                                  (tor-onion-service-configuration
                                    (name "ssh")
                                    (mapping '((22 "127.0.0.1:22"))))
                                  (tor-onion-service-configuration
                                    (name "guix-publish")
                                    ;; jlcmm5lblot62p4txmplf66d76bsrfs4ilhcwaswjdulf6htvntxztad.onion
                                    (mapping '((3000 "127.0.0.1:3000"))))))))

                   (service cups-service-type
                            (cups-configuration
                              (web-interface? #t)
                              (default-paper-size "A4")
                              (extensions
                                (list cups-filters hplip-minimal))))

                   (service mcron-service-type
                            (mcron-configuration
                              (jobs (append (%btrfs-maintenance-jobs "/")
                                            (%btrfs-maintenance-jobs "/data")))))

                   (service openntpd-service-type
                            (openntpd-configuration
                              (listen-on '("127.0.0.1" "::1"))
                              (constraints-from '("https://www.google.com/"))))

                   (service earlyoom-service-type
                            (earlyoom-configuration
                              (prefer-regexp "(cc1(plus)?|.rustc-real|ghc|Web Content)")
                              (avoid-regexp "xfce")))

                   (service zram-device-service-type
                            (zram-device-configuration
                              (size (* 2 (expt 2 30)))
                              (compression-algorithm 'zstd)
                              (priority 100)))

                   (service slim-service-type)

                   (remove (lambda (service)
                             (let ((type (service-kind service)))
                               (or (memq type
                                         (list
                                           gdm-service-type
                                           ntp-service-type)))))
                           (modify-services
                             %desktop-services
                             (guix-service-type
                               config =>
                               (guix-configuration
                                 (inherit config)
                                 ;; Rely on btrfs compression.
                                 (log-compression 'none)
                                 (discover? #t)
                                 (substitute-urls %substitute-urls)
                                 (authorized-keys %authorized-keys)
                                 (extra-options %extra-options)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
