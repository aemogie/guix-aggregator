;; This is an operating system configuration template for a "desktop" setup
;; without full-blown desktop environments.

(use-modules (gnu)
             (guix channels)
             (nonguix)
             (gnu system nss)
             (gnu services desktop)
             (gnu packages bootloaders)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages ratpoison)
             (gnu packages suckless)
             (gnu packages wm)
             (gnu packages xorg))

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

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))

  ;; Assume the target root file system is labelled "my-root",
  ;; and the EFI System Partition has UUID 1234-ABCD.
  (file-systems (append
                 (list (file-system
                         (device (file-system-label "my-root"))
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device (uuid "1234-ABCD" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (users (cons (user-account
                 (name "alice")
                 (comment "Bob's sister")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

  ;; Add a bunch of window managers; we can choose one at
  ;; the log-in screen with F1.
  (packages (append (list
                     ;; window managers
                     ratpoison i3-wm i3status dmenu
                     emacs emacs-exwm emacs-desktop-environment
                     ;; terminal emulator
                     xterm)
                    %base-packages))

  ;; Use the "desktop" services, which include the X11
  ;; log-in service, networking with NetworkManager, and more.
  (services (append (list
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
