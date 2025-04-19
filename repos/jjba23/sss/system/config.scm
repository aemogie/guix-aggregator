;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

(use-modules (gnu)
             (guix)
             (gnu system privilege)
             (gnu services)
             (guix packages))

(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))

;; load SSS defaults
(load "./sss-defaults.scm")

;; load user preferences per-host
(load "../per-host.scm")

;; show input settings
(load "../system/show-settings.scm")
(sss-show-settings)

(load "../lib/process.scm")
(load "../lib/sudoers.scm")
(load "../lib/nftables.scm")

;; load system packages and definitions
(load "./packages/conky.scm")
(load "./packages/fonts.scm")
(load "./packages/sss-packages.scm")

;; load system users
(load "./users.scm")

(use-modules (sss packages)
             (sss nftables))

(use-service-modules networking
                     desktop
                     audio
                     shepherd
                     dbus
                     base
                     xorg
                     desktop
                     configuration
                     avahi
                     nix
                     xorg
                     networking
                     sound
                     cups
                     virtualization
                     mcron
                     pm)

(use-package-modules certs
                     nfs
                     mate
                     lxqt
                     libusb
                     linux
                     glib
                     sugar
                     suckless
                     scanner
                     xdisorg
                     avahi
                     xfce
                     pulseaudio
                     kde-plasma
                     kde-frameworks
                     wm
                     kde
                     gnome
                     freedesktop
                     cups
                     admin
                     glib
                     base
                     idutils)

;; Cron job destined to fetch WikiMusic backups from my production server to my local machines
(define wikimusic-fetch-backups-job
  '(job "0 0 * * *"
        (string-append "mkdir -p $HOME/Documenten/wikimusic-backups &&"
                       " scp -r joe@wolk-jjba:/wolk-jjba-backups/wikimusic/*"
                       " $HOME/Documenten/wikimusic-backups/")))

;; Setup system cron jobs
(define sss-cron-jobs-service
  (simple-service 'sss-cron-jobs mcron-service-type
                  (list wikimusic-fetch-backups-job)))

;; Setup subuid and subgid for the system
(define sss-subuid
  (simple-service 'podman-subuid-subgid
                  ;; If subuid/subgid will be needed somewhere else, the service must be
                  ;; created to handle it.
                  etc-service-type
                  `(("subuid" ,(plain-file "subuid"
                                           (string-append "joe"
                                                          ":100000:65536\n")))
                    ("subgid" ,(plain-file "subgid"
                                           (string-append "joe"
                                                          ":100000:65536\n"))))))

(define* (sss-desktop-services-for-system #:optional (system (or (%current-target-system)
                                                                 (%current-system))))
  
  (cons*
   ;; Add udev rules for MTP devices so that non-root users can access
   ;; them.
   (simple-service 'mtp udev-service-type
                   (list libmtp))
   ;; Add udev rules for scanners.
   (service sane-service-type)
   ;; Add polkit rules, so that non-root users in the wheel group can
   ;; perform administrative tasks (similar to "sudo").
   polkit-wheel-service

   (service cups-service-type
            (cups-configuration (web-interface? #t)
                                (default-paper-size "Letter")
                                (extensions (list cups-filters hplip-minimal))))

   ;; Allow desktop users to also mount NTFS and NFS file systems
   ;; without root.
   (simple-service 'mount-setuid-helpers privileged-program-service-type
                   (map file-like->setuid-program
                        (list (file-append nfs-utils "/sbin/mount.nfs")
                              (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))

   ;; The global fontconfig cache directory can sometimes contain
   ;; stale entries, possibly referencing fonts that have been GC'd,
   ;; so mount it read-only.
   fontconfig-file-system-service

   ;; NetworkManager and its applet.
   (service network-manager-service-type)
   (service wpa-supplicant-service-type)
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
   (service dbus-root-service-type)
   (service elogind-service-type
            (elogind-configuration (kill-user-processes? #t)))

   (service openntpd-service-type
            (openntpd-configuration (listen-on '("127.0.0.1" "::1"))
                                    (sensor '("udcf0 correction 70000"))
                                    (constraint-from '("www.gnu.org"))
                                    (constraints-from '("https://www.google.com/"))))

   (service x11-socket-directory-service-type)

   (service bluetooth-service-type
            (bluetooth-configuration (experimental #t)
                                     (auto-enable? #t)))

   %base-services))

(define-syntax sss-desktop-services
  (identifier-syntax (sss-desktop-services-for-system)))

(operating-system
  (host-name sss-hostname)
  (timezone sss-timezone)
  (locale (format #f "~a.utf8" sss-lang))
  (keyboard-layout (keyboard-layout sss-keyboard-layout))
  (bootloader sss-bootloader-configuration)
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (sudoers-file (plain-file "sudoers"
                            (sss-sudoers)))
  (mapped-devices sss-mapped-devices)
  (file-systems (append sss-filesystems %base-file-systems))
  (users sss-users)
  (packages (append (sss-system-packages #:per-host-packages
                                         sss-per-host-packages) %base-packages))
  (services
   (cons* (service nix-service-type)
          (service power-profiles-daemon-service-type)
          (sss-nftables-svc)
          sss-subuid
          (service screen-locker-service-type
                   (screen-locker-configuration (name "hyprlock")
                                                (program (file-append hyprlock
                                                          "/bin/hyprlock"))
                                                (using-pam? #t)
                                                (using-setuid? #f)))
          (service libvirt-service-type
                   (libvirt-configuration (unix-sock-group "libvirt")
                                          (tls-port "16555")))
          (service virtlog-service-type
                   (virtlog-configuration (max-clients 1000)))
          sss-cron-jobs-service
          sss-desktop-services)))

