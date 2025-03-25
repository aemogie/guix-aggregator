(use-modules (gnu)
             (gnu packages bash)
             (gnu packages certs)
             (gnu packages databases)
             (gnu packages geo)
             (gnu packages display-managers)
             (gnu packages emacs)
             (gnu packages fonts)
             (gnu packages gnome)
             (gnu packages lisp)
             (gnu packages lisp-xyz)
             (gnu packages version-control)
             (gnu packages package-management)
             (gnu packages suckless)
             (gnu packages xdisorg)
             (gnu packages xorg)
             (gnu packages wm)

             (gnu services databases)
             (gnu services dbus)
             (gnu services desktop)
             (gnu services docker)
             (gnu services networking)
             (gnu services nix)
             (gnu services sddm)
             (gnu services virtualization)
             (gnu services web)
             (gnu services xorg)

             (gnu system nss)

             (guix gexp)
             (guix packages)
             (guix utils)

             (nongnu packages linux)      ;; NON-FREE
             (nongnu system linux-initrd) ;; NON-FREE

             (srfi srfi-1)

             (ice-9 match))

(define %additional-xorg-configuration
  "Section \"InputClass\"
   Identifier \"Touchpads\"
   Driver \"libinput\"
   MatchDevicePath \"/dev/input/event*\"
   MatchIsTouchpad \"on\"

   Option \"DisableWhileTyping\" \"on\"
   Option \"MiddleEmulation\" \"on\"
   Option \"ClickMethod\" \"clickfinger\"
   Option \"Tapping\" \"on\"
   Option \"TappingButtonMap\" \"lrm\"
   Option \"TappingDrag\" \"on\"
   Option \"ScrollMethod\" \"twofinger\"
   Option \"NaturalScrolling\" \"true\"
  EndSection")

(operating-system
 (host-name "paranoidal")
 (timezone "Asia/Yerevan")

 (kernel linux)                        ; NON-FREE
 (kernel-arguments
  (cons* "i915.i915_enable_fbc=1"
         "i915.i915_enable_fbc=1"
         "i915.lvds_downclock=1"
         %default-kernel-arguments))
 (initrd microcode-initrd)             ; NON-FREE
 (firmware (cons* iwlwifi-firmware     ; NON-FREE
                  sof-firmware
                  %base-firmware))

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))
              (keyboard-layout #f)))

 (mapped-devices
  (list (mapped-device
         (source "/dev/nvme0n1p2")
         (target "cryptroot")
         (type luks-device-mapping))))

 (file-systems (append
                (list (file-system
                       (device "/dev/mapper/cryptroot")
                       (mount-point "/")
                       (type "btrfs")
                       (dependencies mapped-devices))
                      (file-system
                       (device "/dev/nvme0n1p1")
                       (mount-point "/boot/efi")
                       (type "vfat")))
                %base-file-systems))

 (users (cons (user-account
               (name "aartaka")
               (comment "Artyom Bologov")
               (group "users")
               (supplementary-groups '("libvirt" "wheel" "netdev" "audio" "video" "input" "lp" "dialout" "tty")))
              %base-user-accounts))

 (packages
  (cons*
   xinit xorg-server orca sugar-dark-sddm-theme sbcl cl-slynk stumpwm font-hack git nix
   postgresql postgis
   dwm
   %base-packages))

 (services (cons* (service tor-service-type)
                  (service docker-service-type)
                  (service containerd-service-type)
                  (service postgresql-service-type
                           (postgresql-configuration
                            (postgresql postgresql)
                            (extension-packages (list postgis))
                            (config-file
                             (postgresql-config-file
                              (log-destination "stderr")
                              (hba-file
                               (plain-file "pg_hba.conf"
                                           "
local	all	all			trust
host	all	all	127.0.0.1/32 	md5
host	all	all	::1/128 	md5"))))))
                  (service postgresql-role-service-type
                           (postgresql-role-configuration
                            (roles (list (postgresql-role
                                          (name "aartaka")
                                          (create-database? #t))
                                         (postgresql-role
                                          (name "postgres")
                                          (permissions
                                           '(bypassrls createdb createrole login replication superuser))
                                          (create-database? #t))))))
                  (service openntpd-service-type)
                  (service bluetooth-service-type)
                  (service nix-service-type)
                  (pam-limits-service
                   (list
                    (pam-limits-entry "@realtime" 'both 'rtprio 99)
                    (pam-limits-entry "@realtime" 'both 'memlock 'unlimited)))
                  (service libvirt-service-type)
                  (service virtlog-service-type)
                  (service qemu-binfmt-service-type
                           (qemu-binfmt-configuration
                            (platforms (lookup-qemu-platforms "arm" "aarch64"))))
                  (service gnome-desktop-service-type)
                  (service mate-desktop-service-type)
                  (service xfce-desktop-service-type)
                  (service sddm-service-type
                           (sddm-configuration
                            (theme "sugar-dark")
                            (xorg-configuration
                             (xorg-configuration
                              (modules
                               (cons xf86-input-wacom
                                     (remove (lambda (m) (eq? m xf86-input-synaptics))
                                             %default-xorg-modules)))
                              (keyboard-layout
                               (keyboard-layout
                                "us,ru"
                                #:options '("ctrl:nocaps"
                                            "terminate:ctrl_alt_bksp"
                                            "grp:rctrl_toggle"
                                            "grp:shifts_toggle")))
                              (extra-config (list %additional-xorg-configuration))))))
                  (screen-locker-service slock)
                  (extra-special-file "/bin/bash" (file-append bash "/bin/bash"))
                  (modify-services %desktop-services
                                   (delete ntp-service-type)
                                   (delete gdm-service-type)
                                   (guix-service-type
                                    config => (guix-configuration
                                               (inherit config)
                                               (substitute-urls
                                                (append (list "https://substitutes.nonguix.org")
                                                        %default-substitute-urls))
                                               (authorized-keys
                                                (append (list (local-file "nonguix-signing-key.pub"))
                                                        %default-authorized-guix-keys)))))))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
