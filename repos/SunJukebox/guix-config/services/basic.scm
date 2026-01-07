(define-module (anon services basic)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu system)
  #:use-module (gnu system setuid)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  #:export (%basic-services))

(use-package-modules audio video nfs certs shells ssh linux bash emacs gnome
                     networking wm fonts libusb cups freedesktop file-systems
                     version-control package-management vim)

(use-service-modules dns guix admin sysctl pm nix avahi dbus cups desktop linux
                     mcron networking xorg ssh docker audio virtualization)

(define-public %basic-services
  (cons*
   ;; Seat management (can't use seatd because Wireplumber depends on elogind)
   ;; TODO: replace with seatd
   (service elogind-service-type)

   ;; Configure swaylock as a screen locker (c.f. System Configuration/Services/X Window)
   (service screen-locker-service-type
            (screen-locker-configuration (name "swaylock")
                                         (program (file-append swaylock
                                                               "/bin/swaylock"))
                                         (using-pam? #t)
                                         (using-setuid? #f)))

   ;; Configure guix service and add nonguix substitutes
   (simple-service 'add-nonguix-substitutes guix-service-type
                   (guix-extension (substitute-urls (append (list
                                                             "https://substitutes.nonguix.org")
                                                            %default-substitute-urls))
                                   (authorized-keys (append (list (plain-file
                                                                   "nonguix.pub"
                                                                   "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                                            %default-authorized-guix-keys))))

   ;; Add polkit rules, so that non-root users in the wheel group can
   ;; perform administrative tasks (similar to "sudo").
   polkit-wheel-service

   ;; Allow desktop users to also mount NTFS and NFS file systems
   ;; without root.
   (simple-service 'mount-setuid-helpers privileged-program-service-type
                   (map file-like->setuid-program
                        (list (file-append nfs-utils "/sbin/mount.nfs")
                              (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))

   ;; Networking services
   (service network-manager-service-type)
   (service wpa-supplicant-service-type) ;needed by NetworkManager
   ;; (simple-service 'network-manager-applet profile-service-type
   ;; (list network-manager-applet))
   (service modem-manager-service-type) ;for cellular modems
   (service bluetooth-service-type
            (bluetooth-configuration (auto-enable? #t)))
   (service usb-modeswitch-service-type)

   ;; Sync system clock
   (service ntp-service-type)

   ;; Some desktop system services (from %desktop-services)
   (service avahi-service-type)
   (service udisks-service-type)
   (service upower-service-type)
   ;; (service accountsservice-service-type)
   (service cups-pk-helper-service-type)
   ;; (service colord-service-type)
   (service geoclue-service-type)
   (service polkit-service-type)
   (service dbus-root-service-type)

   ;; This is a volatile read-write file system mounted at /var/lib/gdm,
   ;; to avoid GDM stale cache and permission issues.
   ;; gdm-file-system-service
   
   ;; The global fontconfig cache directory can sometimes contain
   ;; stale entries, possibly referencing fonts that have been GC'd,
   ;; so mount it read-only.
   fontconfig-file-system-service

   ;; Power and thermal management services
   (service thermald-service-type)
   (service tlp-service-type
            (tlp-configuration
             (start-charge-thresh-bat0 75)
	     (stop-charge-thresh-bat0 80)
             ;; (cpu-boost-on-ac? #t)
             (wifi-pwr-on-bat? #t)))

   ;; Enable Docker containers and virtual machines
   (service containerd-service-type)
   (service docker-service-type)
   (service libvirt-service-type
            (libvirt-configuration (unix-sock-group "libvirt")
                                   (tls-port "16555")))

   ;; Enable SSH access
   (service openssh-service-type
            (openssh-configuration (openssh openssh-sans-x)
                                   (port-number 2222)))

   ;; Enable printing and scanning
   (service sane-service-type)
   (service cups-service-type
            (cups-configuration
             (web-interface? #t)
             (extensions
              (list cups-filters epson-inkjet-printer-escpr hplip-minimal)))) 

   ;; Add udev rules for MTP devices so that non-root users can access
   ;; them.
   (simple-service 'mtp udev-service-type
                   (list libmtp))

   ;; X11 socket directory for XWayland
   (service x11-socket-directory-service-type)

   ;; Nix
   (service nix-service-type
            (nix-configuration
             (extra-config
              (list "experimental-features = nix-command flakes\n"))))

   ;; Schedule cron jobs for system tasks
   (simple-service 'system-cron-jobs mcron-service-type
                   (list
                    ;; Run `guix gc' 5 minutes after midnight every day.
                    ;; Clean up generations older than 2 months and free
                    ;; at least 10G of space.
                    #~(job "5 0 * * *" "guix gc -d 2m -F 10G")))

   ;; (service pulseaudio-service-type)
   ;; (service alsa-service-type)
   
   ;; Seat management
   ;; (service seatd-service-type)
   
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
   
   ;; This is the default list of services we
   ;; are appending to.
   ;; (modify-services %base-services
   ;; greetd-service-type provides "greetd" PAM service
   ;; (delete login-service-type)
   ;; and can be used in place of mingetty-service-type
   ;; (delete mingetty-service-type))))
   
   %base-services))
