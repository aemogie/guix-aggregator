(define-module (yggdrasil configurations asgard)
  #:use-module ((gnu bootloader) #:select (bootloader-configuration))
  #:use-module ((gnu bootloader grub) #:select (grub-efi-bootloader))
  #:use-module ((gnu packages) #:select (specification->package))
  #:use-module ((gnu packages base) #:select (glibc canonical-package))
  #:use-module ((gnu packages fonts) #:select (font-terminus))
  #:use-module ((gnu packages linux)
                #:select (ntfs-3g
                          btrfs-progs
                          acpi-call-linux-module
                          bluez))
  #:use-module ((gnu packages video) #:select (libva-utils))
  #:use-module (gnu services)
  #:use-module ((gnu services avahi) #:select (avahi-service-type))
  #:use-module ((gnu services base)
                #:select (login-service-type
                          mingetty-service-type
                          console-font-service-type
                          guix-service-type
                          guix-configuration
                          %base-services
                          %default-authorized-guix-keys
                          pam-limits-service-type))
  #:use-module ((gnu services dbus) #:select (polkit-service-type))
  #:use-module ((gnu services desktop)
                #:select (polkit-wheel-service
                          bluetooth-service-type
                          bluetooth-configuration))
  #:use-module ((gnu services networking) #:select (ntp-service-type))
  #:use-module ((gnu services pam-mount)
                #:select (pam-mount-service-type
                          pam-mount-configuration))
  #:use-module ((gnu system)
                #:select (%base-packages
                          %default-kernel-arguments))
  #:use-module ((gnu system file-systems)
                #:select (uuid
                          file-system
                          file-system-label
                          swap-space
                          file-system-mount-point-predicate
                          %base-file-systems))
  #:use-module ((gnu system mapped-devices)
                #:select (mapped-device luks-device-mapping))
  #:use-module ((gnu system nss) #:select (%mdns-host-lookup-nss))
  #:use-module ((gnu system pam) #:select (pam-limits-entry))
  #:use-module ((gnu system shadow)
                #:select (user-account %base-user-accounts))
  #:use-module (guix gexp)
  #:use-module ((nongnu packages linux)
                #:select (linux ibt-hw-firmware iwlwifi-firmware))
  #:use-module ((nongnu packages video) #:select (intel-media-driver/nonfree))
  #:use-module ((nongnu system linux-initrd) #:select (microcode-initrd))
  #:use-module ((srfi srfi-1) #:select (lset-difference)))

(use-modules (ice-9 match)
             (srfi srfi-1)
             (gnu home)
             (gnu system))

(export make-config)

(define modules
  '((yggdrasil modules docker)
    (yggdrasil modules transmission)
    (yggdrasil modules podman)
    (yggdrasil modules connman)
    (yggdrasil modules dbus)
    (yggdrasil modules direnv)
    (yggdrasil modules seatd)
    (yggdrasil modules emacs)
    (yggdrasil modules engineering)
    (yggdrasil modules mako)
    (yggdrasil modules fonts)
    (yggdrasil modules foot)
    (yggdrasil modules git)
    (yggdrasil modules gnupg)
    (yggdrasil modules gtk)
    (yggdrasil modules imapnotify)
    (yggdrasil modules isync)
    (yggdrasil modules l2md)
    (yggdrasil modules librewolf)
    (yggdrasil modules brightnessctl)
    (yggdrasil modules make)
    (yggdrasil modules msmtp)
    (yggdrasil modules multimedia)
    (yggdrasil modules notmuch)
    (yggdrasil modules nyxt)
    (yggdrasil modules pass)
    (yggdrasil modules pipewire)
    (yggdrasil modules pm)
    (yggdrasil modules tofi)
    (yggdrasil modules ssh)
    (yggdrasil modules wlsunset)
    (yggdrasil modules xdg)
    (yggdrasil modules sway)
    (yggdrasil modules libvirt)))

(define users
  (cons*
   (user-account
    (name "kreved")
    (group "users")
    (supplementary-groups
     '("wheel" "seat" "audio" "video" "lp" "input"
       "libvirt" "kvm" "disk" "plugdev"
       "docker"))
    (home-directory "/home/kreved"))
   %base-user-accounts))

(define mapped-devices
  (list (mapped-device
         (source (uuid "b75bb152-81d7-495c-b173-a98f93e298b5"))
         (target "guix")
         (type luks-device-mapping))))

(define (btrfs-opts subvol)
  (format #f "compress=zstd,discard=async,subvol=~a" subvol))

(define file-systems
  (cons* (file-system
           (type "btrfs")
           (device (file-system-label "system"))
           (mount-point "/")
           (options (btrfs-opts "@root"))
           (dependencies mapped-devices))
         (file-system
           (type "btrfs")
           (device (file-system-label "system"))
           (mount-point "/gnu")
           (options (btrfs-opts "@gnu"))
           (dependencies mapped-devices))
         (file-system
           (type "btrfs")
           (device (file-system-label "system"))
           (mount-point "/var/log")
           (options (btrfs-opts "@logs"))
           (dependencies mapped-devices))
         (file-system
           (device (file-system-label "BOOT"))
           (mount-point "/boot")
           (type "vfat"))
         %base-file-systems))

(define packages
  (let* ((unused-specs '("mg" "nvi" "nano" "zile" "wireless-tools"))
         (unused-pkgs (map specification->package unused-specs)))
    (cons*
     bluez
     ntfs-3g
     btrfs-progs
     intel-media-driver/nonfree
     libva-utils
     (lset-difference equal? %base-packages unused-pkgs))))

(define-public services
  (cons*
   polkit-wheel-service
   (service polkit-service-type)
   (service ntp-service-type)
   (service avahi-service-type)
   (service
    bluetooth-service-type
    (bluetooth-configuration
     (auto-enable? #t)))
   (service
    pam-mount-service-type
    (pam-mount-configuration
     (rules `((volume (@ (user "kreved")
                         (fstype "crypt")
                         (path "/dev/disk/by-partuuid/3b199fe8-1825-e743-9be8-03a4048968c1")
                         (mountpoint "/home/kreved")
                         (options ,(btrfs-opts "@home"))))
              (mkmountpoint (@ (enable "1")
                               (remove "true")))))))
   (service
    pam-limits-service-type
    (list
     (pam-limits-entry "*" 'both 'nofile 100000)))
   (modify-services %base-services
     (delete login-service-type)
     (delete mingetty-service-type)
     (console-font-service-type
      config =>
      (let ((font (file-append font-terminus "/share/consolefonts/ter-220n")))
        (map (lambda (tty) (cons tty font)) '("tty1" "tty2" "tty3"))))
     (guix-service-type
      config =>
      (guix-configuration
       (inherit config)
       (substitute-urls '("https://ci.guix.gnu.org"
                          "https://substitutes.nonguix.org"))
       (authorized-keys (cons
                         (local-file "keys/nonguix.pub")
                         %default-authorized-guix-keys)))))))

(define asgard-os
  (operating-system
    (initrd microcode-initrd)
    (host-name "asgard")
    (timezone "Asia/Bishkek")
    (bootloader (bootloader-configuration
                 (bootloader grub-efi-bootloader)
                 (targets '("/boot"))))
    (kernel linux)
    (kernel-arguments
     (cons* "intel_iommu=on"
            "iommu=pt"
            %default-kernel-arguments))
    (kernel-loadable-modules (list acpi-call-linux-module))
    (firmware (list ibt-hw-firmware iwlwifi-firmware))
    (swap-devices
     (list (swap-space
             (target "/swapfile")
             (dependencies
              (filter (file-system-mount-point-predicate "/")
                      file-systems)))))
    (mapped-devices mapped-devices)
    (file-systems file-systems)
    (users users)
    (packages packages)
    (services services)
    (name-service-switch %mdns-host-lookup-nss)))

(define (make-operating-system)
  (fold
   (lambda (module-name os)
     (let* ((module (resolve-module module-name))
            (services-getter (module-ref module 'system-services #f))
            (services (if services-getter
                          (services-getter)
                          '())))
       (operating-system
         (inherit os)
         (services (append
                    (operating-system-user-services os)
                    services)))))
   asgard-os
   modules))

(define (make-home-environment)
  (fold
   (lambda (module-name he)
     (let* ((module (resolve-module module-name))
            (services-getter (module-ref module 'home-services #f))
            (services (if services-getter
                          (services-getter)
                          '())))
       (home-environment
        (inherit he)
        (services (append
                   (home-environment-user-services he)
                   services)))))
   (home-environment)
   modules))

(define (make-config target)
  (match target
    ('home (make-home-environment))
    ('system (make-operating-system))))
