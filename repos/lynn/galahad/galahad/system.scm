(define-module (galahad system)
  #:use-module (galahad host)
  #:use-module (galahad packages)
  #:use-module (galahad system channels)
  #:use-module (gnu packages linux) ;light
  #:use-module (gnu packages shells)
  #:use-module (gnu packages wm)

  #:use-module (gnu services cups)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop) ;sane-service-type
  #:use-module (gnu services networking)
  #:use-module (gnu services sound) ;pulseaudio-service-type
  #:use-module (gnu services xorg) ;screen-locker-service-type
  #:use-module (gnu services avahi)
  #:use-module (gnu services)
  #:use-module (gnu)
  #:use-module (guix packages)
  #:use-module (guix)
  #:use-module (nongnu packages linux))

(define galahad-user-lynn
  (user-account
   (name "lynn")
   (group "users")
   (shell (file-append zsh "/bin/zsh"))
   (supplementary-groups '("wheel" "netdev" "audio" "video"))))

(define galahad-desktop-services
  (cons*
   (simple-service 'podman-subuid-subgid
		   etc-service-type
                   `(("subuid" ,(plain-file "subuid"
                                            (string-append "lynn"
                                                           ":100000:65536\n")))
                     ("subgid" ,(plain-file "subgid"
                                            (string-append "lynn"
                                                           ":100000:65536\n")))))

   ;; Add udev rules for scanners.
   (service sane-service-type)
   ;; CUPS for printers.
   (service cups-service-type
            (cups-configuration (web-interface? #t)
                                (default-paper-size "a4")))
   ;; Add polkit rules, so that non-root users in the wheel group can
   ;; perform administrative tasks (similar to "sudo").
   polkit-wheel-service
   ;; The global fontconfig cache directory can sometimes contain
   ;; stale entries, possibly referencing fonts that have been GC'd,
   ;; so mount it read-only.
   fontconfig-file-system-service
   ;; NetworkManager. Applet not included as it causes issues with
   ;; nvidia.
   (service network-manager-service-type)
   (service wpa-supplicant-service-type)    ;needed by NetworkManager
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
   ;; Network time protocol to synchronize time.
   ;; TODO: consider openntpd.
   (service ntp-service-type)
   (service x11-socket-directory-service-type)
   ;; Audio services.
   ;; TODO: look into if pipewire can replace this?
   (service pulseaudio-service-type)
   (service alsa-service-type)
   
   (service gnome-keyring-service-type)
   (udev-rules-service 'light light)
   ;; Screen lock is important if using a desktop environment, for
   ;; security.
   (service screen-locker-service-type
            (screen-locker-configuration (name "swaylock")
                                         (program (file-append
                                                   swaylock-effects
                                                   "/bin/swaylock"))
                                         (using-pam? #t)
                                         (using-setuid? #f)))
   (modify-services %base-services
		    (guix-service-type
		     config => (guix-configuration
				(inherit config)
				(substitute-urls
				 (append (list "https://substitutes.nonguix.org")
					 %default-substitute-urls))
				(authorized-keys
				 (append
				  (list %authorized-guix-key-nonguix)
				  %default-authorized-guix-keys)))))))

(operating-system
 (host-name galahad-hostname)
 (timezone galahad-timezone)
 (locale (format #f "~a.utf8" galahad-language))
 (bootloader (bootloader-configuration
	      (bootloader grub-efi-bootloader)
	      (targets (list "/boot/efi"))))
 (kernel linux)
 (kernel-arguments
  '("quiet" "splash"))
 (firmware
  (list linux-firmware))
 (file-systems
  (append galahad-file-systems %base-file-systems))
 (users
  (cons* galahad-user-lynn %base-user-accounts))
 (packages
  (append galahad-system-packages galahad-per-host-packages))
 (services galahad-desktop-services))
