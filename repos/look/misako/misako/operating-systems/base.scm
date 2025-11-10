(define-module (misako operating-systems base)
  #|Misako|#
  #:use-module ((misako home-environments look)
                #:prefix home-environment:)
  #:use-module ((misako operating-systems base opendoas)
                #:prefix rules:)
  #:use-module ((misako operating-systems base privileged)
                #:prefix privileged-programs:)
  #:use-module ((misako operating-systems base users)
                #:prefix user:)
  #:use-module ((misako substitute-keys)
                #:prefix substitute-key:)
  #:use-module (misako packages linux)
  #|GNU Bootloader|#
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #|GNU System|#
  #:use-module (gnu system)
  #:use-module (gnu system accounts)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system nss)
  #:use-module (gnu system shadow)
  #:use-module (gnu system pam)
  #|GNU Services|#
  #:use-module (gnu services)
  #:use-module (gnu services admin)
  #:use-module (gnu services avahi)
  #:use-module (gnu services base)
  #:use-module (gnu services dbus)
  #:use-module (gnu services dns)
  #:use-module (gnu services desktop)
  #:use-module (gnu services guix)
  #:use-module (gnu services linux)
  #:use-module (gnu services mcron)
  #:use-module (gnu services networking)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services shepherd)
  #|GNU Packages|#
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages file)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages games)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages less)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages man)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages display-managers)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages vpn)
  #|NonGNU|#
  #:use-module (nongnu packages linux)
  #|Guix|#
  #:use-module (guix gexp)
  #|Saayix|#
  #:use-module (saayix utils)
  #:use-module (saayix services system mullvad)
  #:use-module (saayix packages binaries)
  #:use-module (saayix packages text-editors)
  #:use-module (saayix packages toys)
  #|Radix|#
  #:use-module (radix utils)
  #:use-module (radix services admin)
  #:use-module (radix system monitoring)
  #:export (base))

(define base
  (operating-system
    #|General preferences|#
    (host-name "base") ; Needed for operating-system
    (timezone "America/Sao_Paulo")
    (locale "en_US.utf8")
    (keyboard-layout
      (keyboard-layout "br"
        #:options '("caps:swapescape")))

    (kernel linux)
    (kernel-arguments
      (list "loglevel=3"
            "quiet"
            "console=tty3"))

    ;; We don't use any file-systems for the base operating-system
    (file-systems '())

    #|Bootloader|#
    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))
        (timeout 1)))

    (users
      (cons* user:look
             %base-user-accounts))

    #|System level packages|#
    (packages
      (list #|admin       |# htop inetutils opendoas shadow
            #|base        |# coreutils diffutils findutils grep patch sed tar which
            #|            |# glibc-locales bash-minimal
            #|certs       |# nss-certs
            #|compression |# gzip unzip xz
            #|curl        |# curl
            #|file        |# file
            #|gawk        |# gawk
            #|less        |# less
            #|linux       |# acpi eudev iproute kbd kmod procps psmisc usbutils util-linux
            #|man         |# man-db man-pages
            #|texinfo     |# info-reader
            #|vpn         |# wireguard-tools))

    #|Do not generate a sudoers file|#
    (sudoers-file #f)

    #|Run some programs from each package with file owner privileges|#
    (privileged-programs
      (append privileged-programs:authentication
              privileged-programs:file-systems
              privileged-programs:network))

    #|Allow resolution of '.local' host names with mDNS|#
    (name-service-switch %mdns-host-lookup-nss)

    #|System services|#
    (services
      (list
        #|Guix publish|#
        (service avahi-service-type
          (avahi-configuration
            (wide-area? #f)))
        (service guix-publish-service-type
          (guix-publish-configuration
            (host "0.0.0.0")
            (port 8081)
            (advertise? #t)
            (compression `(("zstd" 3)))))

        #|Guix services|#
        (service shepherd-transient-service-type)
        (service guix-service-type
          (guix-configuration
            (substitute-urls
              '(
                "https://ci.guix.moe"
                ; "https://cuirass.genenetwork.org"
                "https://substitutes.nonguix.org"
                ; "https://guix.bordeaux.inria.fr"
                "https://ci.guix.gnu.org"))
                ; "https://bordeaux.guix.gnu.org"))
            (authorized-keys
              (list substitute-key:guix.pub
                    substitute-key:bordeaux.pub
                    substitute-key:yumiko.pub
                    substitute-key:yuria.pub
                    substitute-key:buer.pub
                    substitute-key:nonguix.pub
                    substitute-key:inria.pub
                    substitute-key:boiledscript.pub
                    substitute-key:genenetwork.pub))
            (build-accounts 300)
            (discover? #t)
            (extra-options '("--gc-keep-derivations=yes"
                             "--gc-keep-outputs=yes"))))

        #|Home environment services|#
        (service guix-home-service-type
          (if (file-exists? "/run/current-system/provenance") '()
              `(("look" ,home-environment:look))))

        (service shared-cache-service-type
          (shared-cache-configuration
            (users (list (user-cache (user "look"))))))

        #|Login services|#
        (service virtual-terminal-service-type)

        (service console-font-service-type
          (associate-right
            (%default-console-font `("tty1" "tty2" "tty3"))))

        (service seatd-service-type)

        (service greetd-service-type
          (greetd-configuration
            (greeter-supplementary-groups `("video" "input" "seat"))
            (terminals
              (map (lambda (x)
                     (greetd-terminal-configuration
                       (terminal-vt (number->string x))
                       (terminal-switch (= x 1))
                       (default-session-command
                         (greetd-agreety-session
                           (command
                             (greetd-user-session
                               (command #~(getenv "SHELL"))))))))
                   (iota 3 1)))))

        #|Log services|#
        (service log-rotation-service-type)

        (service syslog-service-type
          (syslog-configuration
            (syslogd (file-append inetutils "/libexec/syslogd"))
            (config-file %default-syslog.conf)))

        (service log-cleanup-service-type
          (log-cleanup-configuration
            (directory "/var/log/guix/drvs")
            (expiry (* 3 30 24 3600))))

        #|Garbage collector job|#
        (service mcron-service-type
          (mcron-configuration
            (jobs (list #~(job "5 0 * * *" "guix gc -F 5G")))))

        #|Device management services|#
        (service udev-service-type)

        (simple-service 'uaccess-pam-service pam-root-service-type
          (let ((uaccess-pam-entry
                 (pam-entry
                   (control "optional")
                   (module (file-append pam-uaccess "/lib/security/pam_uaccess.so"))
                   (arguments '("skip_ungrant")))))
            (list (pam-extension
                    (transformer
                     (lambda (pam)
                       (if (member (pam-service-name pam)
                                   '("login" "sudo" "greetd" "su"))
                           (pam-service
                             (inherit pam)
                             (session
                              (append (pam-service-session pam)
                                      (list uaccess-pam-entry))))
                           pam)))))))

        #|Hosts|#
        (simple-service 'extra-hosts hosts-service-type
          (list (host "192.168.100.30" "yuria.local"
                  '("yuria"
                    "forgejo.yuria"))
                (host "192.168.100.33" "yumiko.local"
                  '("cuirass.yumiko"
                    "substitutes.yumiko"
                    "ci.yumiko"))))

        (service mullvad-service-type)

        #|NTPD service|#
        (service ntp-service-type)

        #|IPC services|#
        (service dbus-root-service-type)

        #|Memory management services|#
        ;; TODO: see if /proc/meminfo works on new install
        ; (service zram-device-service-type
        ;   (zram-device-configuration
        ;     (size (* 2 (ram-total)))
        ;     (compression-algorithm 'lz4)))
        (service earlyoom-service-type
          (earlyoom-configuration
            (minimum-available-memory 5)))

        #|Xwayland|#
        (service x11-socket-directory-service-type)

        #|Network services|#
        (service static-networking-service-type
          (list
            (static-networking
              (addresses
                (list (network-address
                        (device "lo")
                        (value "127.0.0.1/8"))))
              (provision '(loopback)))))

        (service dhcpcd-service-type)

        #|Doas config service|#
        (service opendoas-service-type
          (opendoas-configuration
            (rules
              (append rules:general
                      rules:power-management
                      rules:service-management))))

        #|Special file services|#
        (service special-files-service-type
          `(("/bin/sh"      ,(file-append bash      "/bin/bash"))
            ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))

        #|Miscellaneous services|#
        (service urandom-seed-service-type)

        (service nscd-service-type)

        (service sysctl-service-type
          (sysctl-configuration
            (sysctl (file-append procps "/sbin/sysctl"))
            (settings '(("fs.protected_hardlinks" . "1")
                        ("fs.protected_symlinks"  . "1")
                        ("vm.max_map_count"       . "1048576")))))))))
