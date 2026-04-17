;; This is an operating system configuration template for a "bare bones"
;; setup, with no X11 display server.

(use-modules (gnu)
             (guix channels)
             (nonguix)
             (gnu services networking)
             (gnu services ssh)
             (gnu packages screen)
             (gnu packages ssh))

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
  (host-name "komputilo")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  (kernel linux)
  (firmware (cons* linux-firmware %base-firmware))

  ;; Boot in "legacy" BIOS mode, assuming /dev/sdX is the
  ;; target hard disk, and "my-root" is the label of the target
  ;; root file system.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/sdX"))))
  ;; It's fitting to support the equally bare bones ‘-nographic’
  ;; QEMU option, which also nicely sidesteps forcing QWERTY.
  (kernel-arguments (list "console=ttyS0,115200"))
  (file-systems (cons (file-system
                        (device (file-system-label "my-root"))
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (cons (user-account
                 (name "alice")
                 (comment "Bob's sister")
                 (group "users")

                 ;; Adding the account to the "wheel" group
                 ;; makes it a sudoer.  Adding it to "audio"
                 ;; and "video" allows the user to play sound
                 ;; and access the webcam.
                 (supplementary-groups '("wheel" "audio" "video")))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons screen %base-packages))

  ;; Add services to the baseline: a DHCP client and an SSH
  ;; server.  You may wish to add an NTP service here.
  (services (append (list (service dhcpcd-service-type)
                          (service openssh-service-type
                            (openssh-configuration
                              (openssh openssh-sans-x)
                              (port-number 2222)))
                          ;; Use substitutes from Nonguix.
                          (simple-service 'substitute-servers guix-service-type
                            (guix-extension
                              (substitute-urls
                               (list "https://substitutes.nonguix.org"))
                              (authorized-keys
                               (list nonguix-signing-key)))))
                    (modify-services %base-services
                      ;; Set up Nonguix channel in /etc/guix/channels.scm.
                      (guix-service-type
                       config => (guix-configuration
                                   (inherit config)
                                   (channels channels-with-nonguix)))))))
