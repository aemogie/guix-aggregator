(define-module (misako operating-systems yumiko)
  #|Misako|#
  #:use-module (misako home-environments look)
  #:use-module (misako operating-systems base)
  #:use-module (misako operating-systems yumiko file-systems)
  #:use-module (misako operating-systems yumiko cuirass)
  #:use-module (misako utils)
  #:use-module (saayix services system nvidia-unload)
  #|Guix|#
  #:use-module (guix gexp)
  #|GNU System|#
  #:use-module (gnu system)
  #:use-module (gnu system accounts)
  #:use-module (gnu system pam)
  #|GNU Packages|#
  #:use-module (gnu packages admin)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages games)
  #|GNU Services|#
  #:use-module (gnu services)
  #:use-module (gnu services avahi)
  #:use-module (gnu services base)
  #:use-module (gnu services containers)
  #:use-module (gnu services cuirass)
  #:use-module (gnu services databases)
  #:use-module (gnu services docker)
  #:use-module (gnu services guix)
  #:use-module (gnu services linux)
  #:use-module (gnu services networking)
  #:use-module (gnu services samba)
  #:use-module (gnu services ssh)
  #:use-module (gnu services virtualization)
  #|Non-GNU|#
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu services nvidia)
  #:use-module (nongnu system linux-initrd)
  #|Saayix|#
  #|SOPS|#
  #:use-module (sops secrets)
  #|SOPS Service|#
  #:use-module (sops services sops)
  #:export (yumiko))

#|Operating system definition|#
(define yumiko
  (nvidia-operating-system
    (inherit base)
    (host-name "yumiko")

    (initrd microcode-initrd)
    (firmware (list linux-firmware))

    (kernel-arguments
      (cons* "modprobe.blacklist=i2c_nvidia_gpu,wacom,hid_uclogic"
             (operating-system-user-kernel-arguments base)))

    (kernel-loadable-modules
      (list v4l2loopback-linux-module))

    (file-systems %btrfs-ephemeral-file-systems)

    (services
      (cons* (service pam-limits-service-type
               (list
                 (pam-limits-entry "*" 'hard 'nofile 1048576)))

             ; (service nvidia-unload-service-type)
             ; (service samba-service-type
             ;   (samba-configuration
             ;     (enable-smbd? #t)
             ;     (config-file (local-file (string-append yumiko-dir "/samba/smb.conf")))))

             (udev-rules-service 'otd
               (let ((rules "70-opentabletdriver.rules"))
                 (file->udev-rule rules
                   (local-file
                     (string-append yumiko-dir "/udev/" rules))))
               #:groups '("tablet"))

             (udev-rules-service 'usb-phone
               (let ((rules "90-usb-phone.rules"))
                 (file->udev-rule rules
                   (local-file
                     (string-append yumiko-dir "/udev/" rules))))
               #:groups '("usb"))

             (udev-rules-service 'controller steam-devices-udev-rules)

             #|SSH services|#
             (service openssh-service-type
               (openssh-configuration
                 (port-number 2222)
                 (permit-root-login #f)
                 (password-authentication? #f)
                 (x11-forwarding? #f)
                 (authorized-keys
                   `(("look" ,(local-file "/etc/ssh/look.pub"))))))

             #|SOPS services|#
             ; (service sops-secrets-service-type
             ;   (sops-service-configuration
             ;     (gnupg-home "/root/.gnupg")
             ;     (generate-key? #f)
             ;     (config (local-file "../../secrets/.sops.yaml" "sops.yaml"))
             ;     (secrets
             ;       (list
             ;         (sops-secret
             ;           (key '("wireguard"))
             ;           (file (local-file "../../secrets/yumiko.yaml"))
             ;           (user "root")
             ;           (group "root")
             ;           (permissions #o400))))))

             (service kernel-module-loader-service-type
               '("v4l2loopback" "ntsync"))
             (simple-service 'v4l2loopback-config etc-service-type
               (list `("modprobe.d/v4l2loopback.conf"
                       ,(plain-file "v4l2loopback.conf"
                          "options v4l2loopback devices=1 exclusive_caps=1 card_label=\"VirtualCam\""))))

             #|Persistent Files|#
             (extra-special-file "/etc/system.scm"
               (string-append misako-dir "/misako/operating-systems/yumiko.scm"))
             (extra-special-file "/etc/machine-id" "/gnu/persist/etc/machine-id")

             (modify-services (operating-system-user-services base)
               (guix-service-type
                 config =>
                 (guix-configuration
                   (inherit config)
                   (extra-options
                     (cons* "--max-jobs=4"
                            "--cores=12"
                            (guix-configuration-extra-options config))))))))))

yumiko
