;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.

;; Indicate which modules to import to access the variables
;; used in this configuration.

(define-module (system oldcoal)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu system)
  #:use-module (gnu system setuid)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(use-service-modules admin avahi audio cups dbus desktop docker guix linux
                     mcron networking nix pm ssh sysctl virtualization xorg)

(use-package-modules audio admin bash certs cups databases emacs file-systems
                     fonts freedesktop gnome libusb linux networking nfs
                     package-management shells ssh suckless terminals
                     version-control video vim wm xdisorg)

(define-public my-operating-system
  (operating-system
    (kernel linux)
    (initrd microcode-initrd)
    (firmware (list linux-firmware))
    (locale "en_US.utf8")
    (timezone "America/New_York")
    (keyboard-layout (keyboard-layout "us" "dvp"))
    (host-name "oldcoal")

    ;; The list of user accounts ('root' is implicit).
    (users (cons* (user-account
                    (name "kyle")
                    (comment "Kyle O.")
                    (group "users")
                    (home-directory "/home/kyle")
                    (supplementary-groups '("wheel" "netdev" "audio" "video")))
                  ;; "docker")))
                  %base-user-accounts))

    ;; Packages installed system-wide.  Users can also install packages
    ;; under their own account: use 'guix search KEYWORD' to search
    ;; for packages and 'guix install PACKAGE' to install a package.
    (packages (cons* bluez
                     bluez-alsa
                     emacs
                     git
                     neovim
                     recutils
                     %base-packages))

    ;; Below is the list of system services.  To search for available
    ;; services, run 'guix system search KEYWORD' in a terminal.
    (services
     (append (list
              ;; Configure swaylock as a screen locker (c.f. System Configuration/Services/X Window)
              ;; (service screen-locker-service-type
              ;; (screen-locker-configuration (name "swaylock")
              ;; (program (file-append
              ;; swaylock
              ;; "/bin/swaylock"))
              ;; (using-pam? #t)
              ;; (using-setuid? #f)))
              
              ;; Add udev rules for MTP devices so that non-root users can access
              ;; them.
              (simple-service 'mtp udev-service-type
                              (list libmtp))
              ;; Add udev rules for scanners.
              (service sane-service-type)
              ;; Add polkit rules, so that non-root users in the wheel group can
              ;; perform administrative tasks (similar to "sudo").
              polkit-wheel-service

              ;; Allow desktop users to also mount NTFS and NFS file systems
              ;; without root.
              (simple-service 'mount-setuid-helpers
                              privileged-program-service-type
                              (map file-like->setuid-program
                                   (list (file-append nfs-utils
                                                      "/sbin/mount.nfs")
                                         (file-append ntfs-3g
                                                      "/sbin/mount.ntfs-3g"))))

              ;; This is a volatile read-write file system mounted at /var/lib/gdm,
              ;; to avoid GDM stale cache and permission issues.
              ;; gdm-file-system-service
              
              ;; The global fontconfig cache directory can sometimes contain
              ;; stale entries, possibly referencing fonts that have been GC'd,
              ;; so mount it read-only.
              ;; fontconfig-file-system-service
              
              ;; NetworkManager and its applet.
              (service network-manager-service-type)
              (service wpa-supplicant-service-type) ;needed by NetworkManager
              (simple-service 'network-manager-applet profile-service-type
                              (list network-manager-applet))
              (service modem-manager-service-type)
              (service usb-modeswitch-service-type)

              ;; The D-Bus clique.
              (service avahi-service-type)
              (service udisks-service-type)
              (service upower-service-type)
              (service accountsservice-service-type)
              (service cups-pk-helper-service-type)
              (service colord-service-type)
              (service geoclue-service-type)
              (service polkit-service-type)
              (service elogind-service-type)
              (service dbus-root-service-type)

              (service ntp-service-type)

              (service x11-socket-directory-service-type)

              ;; (service pulseaudio-service-type)
              ;; (service alsa-service-type)
              
              ;; Seat management
              ;; (service seatd-service-type)
              
              ;; Configure guix service and add nonguix substitutes
              (simple-service 'add-nonguix-substitutes guix-service-type
                              (guix-extension (substitute-urls (append (list
                                                                        "https://substitutes.nonguix.org")
                                                                %default-substitute-urls))
                                              (authorized-keys (append (list (plain-file
                                                                              "nonguix.pub"
                                                                              "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                                                %default-authorized-guix-keys))))

              ;; (service greetd-service-type
              ;; (greetd-configuration
              ;; ;; We need to give the greeter user these permissions, otherwise
              ;; ;; Sway will crash on launch.
              ;; (greeter-supplementary-groups (list "video" "input"))
              ;; (terminals (list (greetd-terminal-configuration (terminal-vt
              ;; "1")
              ;; (terminal-switch
              ;; #t))
              ;; ;; (default-session-command
              ;; ;; (greetd-wlgreet-sway-session)))
              ;; ;; Set up remaining TTYs for terminal use
              ;; (greetd-terminal-configuration (terminal-vt
              ;; "2"))
              ;; (greetd-terminal-configuration (terminal-vt
              ;; "3"))
              ;; (greetd-terminal-configuration (terminal-vt
              ;; "4"))
              ;; (greetd-terminal-configuration (terminal-vt
              ;; "5"))
              ;; (greetd-terminal-configuration (terminal-vt
              ;; "6"))))))
              
              ;; Enable printing
              (service cups-service-type)

              ;; Enable Docker containers
              ;; (service docker-service-type)
              
              ;; Enable SSH access
              (service openssh-service-type
                       (openssh-configuration (openssh openssh-sans-x)
                                              (port-number 2222))))

             ;; This is the default list of services we
             ;; are appending to.
             ;; (modify-services %base-services
             ;; greetd-service-type provides "greetd" PAM service
             ;; (delete login-service-type)
             ;; and can be used in place of mingetty-service-type
             ;; (delete mingetty-service-type))))
             %base-services))

    ;; (services (append (list (service cups-service-type)
    ;; (set-xorg-configuration
    ;; (xorg-configuration (keyboard-layout keyboard-layout))))
    ;;
    ;; ;; This is the default list of services we
    ;; ;; are appending to.
    ;; (modify-services %desktop-services
    ;; (guix-service-type config => (guix-configuration
    ;; (inherit config)
    ;; (substitute-urls
    ;; (append (list "https://substitutes.nonguix.org")
    ;; %default-substitute-urls))
    ;; (authorized-keys
    ;; (append (list (plain-file "nonguix.pub"
    ;; "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
    ;; %default-authorized-guix-keys)))))))
    
    (bootloader (bootloader-configuration
                  (bootloader grub-efi-bootloader)
                  (targets (list "/boot/efi"))
                  (keyboard-layout keyboard-layout)))

    (swap-devices (list (swap-space
                          (target (uuid "1ae62a34-b8d9-4b4c-842e-a44df903115f")))))

    ;; The list of file systems that get "mounted".  The unique
    ;; file system identifiers there ("UUIDs") can be obtained
    ;; by running 'blkid' in a terminal.
    (file-systems (cons* (file-system
                           (mount-point "/home")
                           (device (uuid
                                    "524e315e-8939-4114-8367-72749faa7531"
                                    'xfs))
                           (type "xfs"))
                         (file-system
                           (mount-point "/")
                           (device (uuid
                                    "1a9d8b80-b5c4-43a8-a9fa-ba1e863a9089"
                                    'btrfs))
                           (type "btrfs"))
                         (file-system
                           (mount-point "/boot/efi")
                           (device (uuid "D9E1-B54A"
                                         'fat32))
                           (type "vfat")) %base-file-systems))))

my-operating-system
