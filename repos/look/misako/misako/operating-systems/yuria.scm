(define-module (misako operating-systems yuria)
  #|Misako|#
  #:use-module (misako operating-systems base)
  #:use-module (misako operating-systems yuria file-systems)
  #:use-module (misako utils)
  #:use-module ((misako build-machines) #:prefix build-machine:)
  #|GNU|#
  #:use-module (gnu packages linux)
  #:use-module (gnu packages networking)
  #|GNU System|#
  #:use-module (gnu system)
  #:use-module (gnu system linux-initrd)
  #:use-module (gnu system file-systems)
  #|GNU Services|#
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services desktop)
  #:use-module ((gnu services networking)
                #:hide (iwd-service-type
                        iwd-configuration))
  #:use-module (gnu services docker)
  #|Guix|#
  #:use-module (guix gexp)
  #|Non-GNU|#
  #:use-module (nongnu system linux-initrd)
  #:use-module (nongnu packages linux)
  #|Saayix|#
  #:use-module (saayix services system rfkill)
  #:use-module (saayix services system iwd)
  #:export (yuria))

#|Operating system definition|#
(define yuria
  (operating-system
    (inherit base)
    (host-name "yuria")

    (initrd
      (lambda (file-systems . rest)
        (apply microcode-initrd
               file-systems
               #:initrd base-initrd
               #:microcode-packages (list amd-microcode)
               rest)))
    (firmware
      (cons* amdgpu-firmware
             realtek-firmware
             %base-firmware))

    (kernel linux)
    (kernel-arguments
      (cons* "amdgpu.backlight=0"
             (operating-system-user-kernel-arguments base)))

    (file-systems %btrfs-ephemeral-file-systems)

    (mapped-devices %mapped-devices)

    #|System-level Services|#
    (services
      (cons*
        #|Bluetooth services|#
        (service bluetooth-service-type
          (bluetooth-configuration
            (name "yuria")
            (auto-enable? #t)))

        #|Networking Services|#
        (service rfkill-service-type)
        (service iwd-service-type
          (iwd-configuration
            (iwd iwd)
            (enable-network-configuration? #t)
            (use-default-interface? #f)
            (address-randomization #f)
            (address-randomization-range 'full)
            (roam-threshold -75)
            (roam-threshold-5g -80)
            (roam-retry-interval 60)
            (country "BR")
            (enable-ipv6? #t)
            (name-resolving-service 'resolvconf)
            (route-priority-offset 300)
            ;; Blacklist
            (initial-timeout 60)
            (multiplier 30)
            (maximum-timeout 86400)
            ;; Rank
            (band-modifier-5ghz 1.0)
            ;; Scan
            (disable-periodic-scan? #f)
            (initial-periodic-scan-interval 10)
            (maximum-periodic-scan-interval 300)
            (disable-roaming-scan? #f)
            ;; IPv4
            (ap-address-pool '("192.168.0.0/16"))))

        ; (service docker-service-type)
        ; (service containerd-service-type)
        ; (service oci-forgejo-service-type
        ;   (forgejo-configuration
        ;     (uid 34595)
        ;     (gid 98715)
        ;     (image "codeberg.org/forgejo/forgejo:9.0.2-amd64-rootless")
        ;     (port "3000")
        ;     (ssh-port "22")
        ;     (datadir "/var/lib/forgejo")))

        #|Persistent Files|#
        (extra-special-file "/etc/system.scm"
          (string-append misako-dir "/misako/operating-systems/yuria.scm"))
        (extra-special-file "/etc/machine-id" "/gnu/persist/etc/machine-id")

        #|Base Services|#
        (modify-services (operating-system-user-services base)
          (guix-service-type
            config =>
            (guix-configuration
              (inherit config)
              ; (substitute-urls
              ;   (cons* "http://substitutes.yumiko:8082"
              ;          (guix-configuration-substitute-urls config)))
              (extra-options
                (cons* "--max-jobs=3"
                       "--cores=4"
                       (guix-configuration-extra-options config)))))
              ; Remember to unlink /etc/guix/machines.scm due to bug
              ; (build-machines
              ;   (list build-machine:yumiko))))
          (udev-service-type
            config =>
            (udev-configuration
              (udev eudev)
              (rules (list light))))
          (delete dhcpcd-service-type))))))

yuria
