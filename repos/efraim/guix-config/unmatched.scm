(define-module (unmatched))
(use-modules (guix packages)
             (guix utils)
             (gnu)
             (gnu bootloader u-boot)
             (gnu system locale)
             (config filesystems)
             (config guix-daemon)
             (dfsg contrib services tailscale)
             (srfi srfi-1))
(use-service-modules
  linux
  networking
  ssh)
(use-package-modules
  gcc
  linux)
(export %unmatched-system)

;; OS starts from here:

(define %unmatched-system
 (operating-system
  (host-name "unmatched")
  (timezone "Asia/Jerusalem")
  (locale "en_IL.utf8")
  (locale-definitions
    (list (locale-definition (source "en_US")
                             (name "en_US.UTF-8"))
          (locale-definition (source "he_IL")
                             (name "he_IL.UTF-8"))))
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))

  (bootloader (bootloader-configuration
                (bootloader u-boot-sifive-unmatched-bootloader)
                (targets '("/dev/mmcblk0"))))   ; SD card/eMMC (SD priority) storage

  (firmware '())
  (initrd-modules '())
  (kernel linux-libre-riscv64-generic)

  (file-systems
    (cons* (file-system
             (device (file-system-label "Guix_image"))
             (mount-point "/")
             (type "ext4"))
           %guix-temproots
           %base-file-systems))

  (users (cons* (user-account
                  (name "efraim")
                  (comment "Efraim Flashner")
                  (group "users")
                  (home-directory "/home/efraim")
                  (password "$6$4t79wXvnVk$bjwOl0YCkILfyWbr1BBxiPxJ0GJhdFrPdbBjndFjZpqHwd9poOpq2x5WtdWPWElK8tQ8rHJLg3mJ4ZfjrQekL1")
                  (supplementary-groups '("wheel" "netdev" "kvm")))
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
                      (package (specification->package "tailscale"))
                      (dev-net-tun? #f)))

           (service openntpd-service-type
                    (openntpd-configuration
                      (listen-on '("127.0.0.1" "::1"))
                      ;; Prevent moving to year 2116.
                      (constraints-from '("https://www.google.com/"))))

           (service dhcp-client-service-type)

           (service earlyoom-service-type
                    (earlyoom-configuration
                      (earlyoom
                        (package
                          (inherit earlyoom)
                          (native-inputs
                           ;; Almost any version of go will work here.
                           (modify-inputs (package-native-inputs earlyoom)
                                          (replace "go" gccgo-12)))))
                      (prefer-regexp "(cc1(plus)?|.rustc-real|Web Content)")
                      (avoid-regexp "guile")))

           (service zram-device-service-type
                    (zram-device-configuration
                      (size (* 8 (expt 2 30)))
                      (compression-algorithm 'zstd)
                      (priority 100)))

           (modify-services
             %base-services
             (guix-service-type
               config =>
               (guix-configuration
                 (inherit config)
                 ;; If there's no substitute for guix then skip the tests.
                 ;; Uncomment or comment out this block as needed.
                 (guix
                   (let ((base (specification->package "guix")))
                     (package
                       (inherit base)
                       (arguments
                        (substitute-keyword-arguments (package-arguments base)
                          ((#:tests? _ #f) #f))))))
                 (substitute-urls '())   ; Offload machine
                 (authorized-keys %authorized-keys)
                 (extra-options
                   (cons* "--cache-failures" %extra-options)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss)))

%unmatched-system

;; guix system image --image-type=unmatched-raw -L ~/workspace/my-guix -L ~/workspace/guix-config/ ~/workspace/guix-config/unmatched.scm --system=riscv64-linux
