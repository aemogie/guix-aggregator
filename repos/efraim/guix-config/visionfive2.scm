(define-module (visionfive2))
(use-modules (guix packages)
             (gnu)
             (gnu bootloader u-boot)
             (gnu system locale)
             (gnu system images visionfive2)
             (config filesystems)
             (config guix-daemon)
             (dfsg contrib services tailscale)
             (srfi srfi-1))
(use-service-modules
  linux
  mcron
  networking
  ssh)
(use-package-modules
  linux)
(export %visionfive2-system)

(define %visionfive2-system
 (operating-system
  (inherit visionfive2-barebones-os)
  (host-name "visionfive2")
  (timezone "Asia/Jerusalem")
  (locale "en_IL.utf8")
  (locale-definitions
    (list (locale-definition (source "en_US")
                             (name "en_US.UTF-8"))
          (locale-definition (source "he_IL")
                             (name "he_IL.UTF-8"))))
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))

  (bootloader
    (bootloader-configuration
      (bootloader u-boot-starfive-visionfive2-bootloader)
      (targets '("/dev/mmcblk0"))))     ; SD card/eMMC (SD priority) storage

  ;(initrd-modules '())
  ;(kernel linux-libre-riscv64-generic)
  (firmware '())

  (file-systems
    (cons* (file-system
             (device (file-system-label "Guix_image"))
             (mount-point "/")
             (type "ext4"))
           %guix-temproots
           %base-file-systems))

  (users (cons (user-account
                (name "efraim")
                (comment "Efraim")
                (group "users")
                (home-directory "/home/efraim")
                (password "$6$4t79wXvnVk$bjwOl0YCkILfyWbr1BBxiPxJ0GJhdFrPdbBjndFjZpqHwd9poOpq2x5WtdWPWElK8tQ8rHJLg3mJ4ZfjrQekL1")
                (supplementary-groups '("wheel"
                                        "netdev" "kvm")))
               %base-user-accounts))

  (sudoers-file
    (plain-file "sudoers"
                (string-append (plain-file-content %sudoers-specification)
                               (format #f "efraim ALL = NOPASSWD: ALL~%"))))

  ;; This is where we specify system-wide packages.
  (packages
    (append
      (map specification->package
           (list "screen"))
      (delete (specification->package "guix-icons") %base-packages)))

  (services
    (cons* (service openssh-service-type
                    (openssh-configuration
                      (openssh (specification->package "openssh-sans-x"))
                      (authorized-keys
                        `(("efraim" ,(local-file "Extras/efraim.pub"))))))

           (service tailscaled-service-type
                    (tailscaled-configuration
                      (package (specification->package "tailscale"))))

           (service mcron-service-type
                    (mcron-configuration
                      (jobs
                        (list
                          #~(job '(next-hour '(3))
                                 "guix gc --free-space=15G")))))

           (service ntp-service-type)

           (service dhcp-client-service-type)

           (service earlyoom-service-type
                    (earlyoom-configuration
                      (prefer-regexp "(cc1(plus)?|.rustc-real|ghc|Web Content)")
                      (avoid-regexp "guile")))

           (service zram-device-service-type
                    (zram-device-configuration
                      (size (* 4 (expt 2 30)))
                      (compression-algorithm 'zstd)
                      (priority 100)))

           (modify-services
             %base-services
             (guix-service-type
               config =>
               (guix-configuration
                 (inherit config)
                 (substitute-urls '())   ; Offload machine
                 (authorized-keys %authorized-keys)
                 (extra-options
                   (cons* "--cache-failures"
                          %extra-options)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss)))

%visionfive2-system

;; guix system image --image-type=visionfive2-raw -L ~/workspace/my-guix -L ~/workspace/guix-config ~/workspace/guix-config/visionfive2.scm --system=riscv64-linux
;; guix system image --image-type=visionfive2-raw -L ~/workspace/my-guix -L ~/workspace/guix-config ~/workspace/guix-config/visionfive2.scm --target=riscv64-linux-gnu

;; sudo cfdisk /dev/sdX to resize /dev/sdX3 to use the remaining space left at the end of the µSD card
;; guix shell e2fsprogs -- sudo resize2fs /dev/sdX3
;; guix shell e2fsck-static -- sudo -E e2fsck /dev/sdX3
