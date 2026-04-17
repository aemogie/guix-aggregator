;; This is an operating system configuration template for a "desktop" setup
;; with GNOME and Xfce where the root partition is encrypted with LUKS, and a
;; swap file.

(use-modules (gnu)
             (guix channels)
             (guix utils)
             (nonguix)
             (gnu system nss)
             (gnu services desktop)
             (gnu services sddm)
             (gnu services xorg)
             (gnu packages gnome))

(define channels-with-nonguix
  (list (channel
          (inherit %default-guix-channel)
          (name 'guix)
          (url "https://git.guix.gnu.org/guix.git"))
        (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))))

(define nonguix-signing-key
  (plain-file "nonguix.pub" "(public-key (ecc (curve Ed25519)
 (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(operating-system
  (host-name "antelope")
  (timezone "Europe/Paris")
  (locale "en_US.utf8")

  (kernel linux)
  (firmware (cons* linux-firmware %base-firmware))

  ;; Choose US English keyboard layout.  The "altgr-intl"
  ;; variant provides dead keys for accented characters.
  (keyboard-layout (keyboard-layout "us" "altgr-intl"))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))
                (keyboard-layout keyboard-layout)))

  ;; Specify a mapped device for the encrypted root partition.
  ;; The UUID is that returned by 'cryptsetup luksUUID'.
  (mapped-devices
   (list (mapped-device
           (source (uuid "12345678-1234-1234-1234-123456789abc"))
           (target "my-root")
           (type luks-device-mapping))))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "my-root"))
                         (mount-point "/")
                         (type "ext4")
                         (dependencies mapped-devices))
                       (file-system
                         (device (uuid "1234-ABCD" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  ;; Specify a swap file for the system, which resides on the
  ;; root file system.
  (swap-devices (list (swap-space
                        (target "/swapfile"))))

  ;; Create user `bob' with `alice' as its initial password.
  (users (cons (user-account
                 (name "bob")
                 (comment "Alice's brother")
                 (password (crypt "alice" "$6$abc"))
                 (group "students")
                 (supplementary-groups '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

  ;; Add the `students' group
  (groups (cons* (user-group
                   (name "students"))
                 %base-groups))

  ;; This is where we specify system-wide packages.
  (packages (append (list
                     ;; force user mounts
                     gvfs)
                    %base-packages))

  ;; Add GNOME and Xfce---we can choose at the log-in screen
  ;; by clicking the gear.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (append (if (target-x86-64?)
                        (list (service gnome-desktop-service-type)
                              (service xfce-desktop-service-type)
                              (set-xorg-configuration
                               (xorg-configuration
                                 (keyboard-layout keyboard-layout))))

                        ;; FIXME: Since GDM depends on Rust (gdm -> gnome-shell -> gjs
                        ;; -> mozjs -> rust) and Rust is currently unavailable on
                        ;; non-x86_64 platforms, we use SDDM and Mate here instead of
                        ;; GNOME and GDM.
                        (list (service mate-desktop-service-type)
                              (service xfce-desktop-service-type)
                              (set-xorg-configuration
                               (xorg-configuration
                                 (keyboard-layout keyboard-layout))
                               sddm-service-type)))

                    (list
                     ;; Use substitutes from Nonguix.
                     (simple-service 'substitute-servers guix-service-type
                       (guix-extension
                         (substitute-urls
                          (list "https://substitutes.nonguix.org"))
                         (authorized-keys
                          (list nonguix-signing-key)))))
                    (modify-services %desktop-services
                      ;; Set up Nonguix channel in /etc/guix/channels.scm.
                      (guix-service-type
                       config => (guix-configuration
                                   (inherit config)
                                   (channels channels-with-nonguix))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
