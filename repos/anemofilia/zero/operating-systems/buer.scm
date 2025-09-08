(define-module (operating-systems buer)
  #|GNU bootloader|#
  #|•|# #:use-module (gnu bootloader)
  #|G|# #:use-module (gnu bootloader grub)

  #|GNU packages|#
  #|A|# #:use-module (gnu packages admin)
  #|B|# #:use-module (gnu packages base)
        #:use-module (gnu packages bash)
  #|C|# #:use-module (gnu packages certs)
        #:use-module (gnu packages compression)
  #|G|# #:use-module (gnu packages gawk)
        #:use-module (gnu packages guile)
        #:use-module (gnu packages guile-xyz)
  #|L|# #:use-module (gnu packages less)
        #:use-module (gnu packages linux)
  #|M|# #:use-module (gnu packages man)
  #|N|# #:use-module (gnu packages nss)
  #|P|# #:use-module (gnu packages package-management)
        #:use-module (gnu packages pciutils)
  #|T|# #:use-module (gnu packages texinfo)

  #|GNU services|#
  #|•|# #:use-module (gnu services)
  #|A|# #:use-module (gnu services admin)
  #|B|# #:use-module (gnu services base)
  #|D|# #:use-module (gnu services dbus)
        #:use-module (gnu services desktop)
  #|G|# #:use-module (gnu services guix)
  #|L|# #:use-module (gnu services linux)
  #|N|# #:use-module (gnu services networking)
  #|P|# #:use-module (gnu services pm)
  #|S|# #:use-module (gnu services shepherd)
        #:use-module (gnu services sysctl)

  #|GNU system|#
  #|•|# #:use-module (gnu system)
  #|A|# #:use-module (gnu system accounts)
  #|F|# #:use-module (gnu system file-systems)
  #|K|# #:use-module (gnu system keyboard)
  #|N|# #:use-module (gnu system nss)
  #|S|# #:use-module (gnu system shadow)

  #|Guix|#
  #|G|# #:use-module (guix gexp)

  #|Home environments|#
  #|R|# #:use-module ((home-environments radio)
                      #:prefix home-environment:)

  #|Radix|#
  #|A|# #:use-module (radix artwork)

  #|Radix packages|#
  #|A|# #:use-module (radix packages admin)
  #|L|# #:use-module (radix packages linux)
  #|T|# #:use-module (radix packages text-editors)

  #|Radix services|#
  #|A|# #:use-module (radix services admin)
  #|P|# #:use-module (radix services pm)
  #|S|# #:use-module (radix services shepherd)

  #|Radix system|#
  #|M|# #:use-module (radix system monitoring)

  #|Buer|#
  #|F|# #:use-module ((operating-systems buer files)
                      #:prefix file:)
        #:use-module ((operating-systems buer file-systems)
                      #:prefix file-system:)
  #|P|# #:use-module ((operating-systems buer privilege)
                      #:prefix privileged-programs:)
  #|R|# #:use-module ((operating-systems buer rules)
                      #:prefix rules:)
  #|S|# #:use-module ((operating-systems buer substitute-keys)
                      #:prefix substitute-key:)
  #|T|# #:use-module ((operating-systems buer timers)
                      #:prefix timer:)
  #|U|# #:use-module ((operating-systems buer users)
                      #:prefix user:)

  #:export (buer buer.scm))

(define buer.scm
  (search-path %load-path (module-filename (current-module))))

(define buer
  (operating-system
   (host-name "buer")
   (timezone "America/Sao_Paulo")
   (locale "en_US.utf8")

   (keyboard-layout
    (keyboard-layout "us,br"
                     #:options `("grp:menu_switch"
                                 "parens:swap_brackets"
                                 "caps:swapescape")))

   (bootloader
    (bootloader-configuration
     (bootloader grub-bootloader)
     (targets `("/dev/disk/by-id/wwn-0x50026b7785a0a591"))
     (theme (grub-theme
             (resolution `(1366 . 768))
             (color-normal
              '((fg . light-gray) (bg . black)))
             (color-highlight
              '((fg . black) (bg . light-gray)))
             (image (file-append %artwork-repository
                                 "/backgrounds/guix-silver-16-9.svg"))
             (gfxmode `("1280x720x32"))))))

   (kernel linux-libre-6.16)
   (kernel-arguments
    `("console=tty1"
      "modprobe.blacklist=usbmouse,usbkbd,pcspkr"
      "thinkpad_acpi.fan_control=1"
      "quiet"))

   (file-systems
     (append file-system:volumes
             file-system:persistent-directories))

   (users
    (cons* user:radio
           user:root
           %base-user-accounts))

   (packages
    (list #|admin       |# btop inetutils shadow zzz
          #|base        |# coreutils diffutils findutils grep sed tar which
          #|bash        |# bash-minimal
          #|certs       |# nss-certs
          #|compression |# gzip xz zstd
          #|gawk        |# gawk
          #|guile       |# guile-next guile-colorized guile-readline
          #|less        |# less
          #|linux       |# iproute kmod procps usbutils util-linux
          #|man         |# man-db man-pages
          #|pciutils    |# pciutils
          #|texinfo     |# info-reader
          #|text-editors|# kakoune))

   #|Do not generate a sudoers file|#
   (sudoers-file #f)

   #|Run some programs from with privileges|#
   (privileged-programs
     (append privileged-programs:authentication
             privileged-programs:file-systems
             privileged-programs:network))

   #|Allow resolution of '.local' host names with mDNS|#
   (name-service-switch %mdns-host-lookup-nss)

   (services
    (list #|TTY services|#
          (service virtual-terminal-service-type)
          (service console-font-service-type
                   `(("tty1" . ,%default-console-font)
                     ("tty2" . ,%default-console-font)))

          #|Shepherd services|#
          (service radix:shepherd-timer-service-type
                   (list timer:guix-gc))
          (service shepherd-timer-service-type)
          (service shepherd-transient-service-type)

          #|Login services|#
          (service seatd-service-type)
          (service greetd-service-type
                   (greetd-configuration
                    (greeter-supplementary-groups `("seat"))
                    (terminals
                      (map (lambda (x)
                             (greetd-terminal-configuration
                              (terminal-vt (number->string x))
                              (terminal-switch (= x 1))
                              (default-session-command
                               (greetd-agreety-session
                                (command
                                 (greetd-user-session
                                  (command
                                   #~(passwd:shell (getpwnam (getenv "USER"))))))))))
                           (iota 2 1)))))

          #|Home environment services|#
          (service guix-home-service-type
                   (if (file-exists? "/run/current-system/provenance") '()
                     `(("radio" ,home-environment:radio))))

          #|Log services|#
          (service log-rotation-service-type)
          (service shepherd-system-log-service-type)
          (service log-cleanup-service-type
                   (log-cleanup-configuration
                    (directory "/var/log/guix/drvs")
                    (expiry (* 2 30 24 3600))))

          #|IPC services|#
          (service dbus-root-service-type)

          #|Guix services|#
          (service guix-service-type
                   (guix-configuration
                    (build-accounts 16)
                    (authorized-keys
                     (cons* substitute-key:inria.pub
                            substitute-key:moe.pub
                            substitute-key:yumiko.pub
                            %default-authorized-guix-keys))
                    (substitute-urls
                      `("https://cache-us-lax.guix.moe"
                        "https://ci.guix.gnu.org"
                        "https://guix.bordeaux.inria.fr"))
                    (extra-options
                      `("--cores=4"
                        "--gc-keep-derivations=yes"
                        "--gc-keep-outputs=yes"))))
          (service shared-cache-service-type
                   (shared-cache-configuration
                    (users (list (user-cache (user "radio"))))))

          #|Device management services|#
          (service udev-service-type
                   (udev-configuration
                    (rules (list crda fuse))))

          #|Network services|#
          (service static-networking-service-type
                   (list %loopback-static-networking))
          (service ntp-service-type)
          (service wpa-supplicant-service-type
                   (wpa-supplicant-configuration
                    (config-file "/etc/wpa-supplicant.conf")
                    (interface "wlp2s0")
                    (extra-options `("-B"))))
          (service dhcpcd-service-type)

          #|Power management services|#
          (service tlp-service-type
                   (tlp-configuration
                    (cpu-scaling-governor-on-ac `("performance"))
                    (cpu-scaling-governor-on-bat `("powersave"))
                    (cpu-scaling-min-freq-on-ac 1500000)
                    (cpu-scaling-max-freq-on-ac 3500000)
                    (cpu-scaling-min-freq-on-bat 1000000)
                    (cpu-scaling-max-freq-on-bat 3000000)
                    (cpu-min-perf-on-ac 0)
                    (cpu-max-perf-on-ac 100)
                    (cpu-min-perf-on-bat 0)
                    (cpu-max-perf-on-bat 40)
                    (cpu-boost-on-ac? #t)
                    (cpu-boost-on-bat? #f)
                    (nmi-watchdog? #t)
                    (start-charge-thresh-bat0 70)
                    (stop-charge-thresh-bat0 90)))
          (service thinkfan-service-type
                   (thinkfan-configuration
                    (thinkfan thinkfan-next)
                    (auto-start? #f)
                    (config-file file:thinkfan-config)))

          #|Memory management services|#
          (service zram-device-service-type
                   (zram-device-configuration
                    (priority 100)
                    (size (* 2 (ram-total)))
                    (compression-algorithm 'lz4)))
          (simple-service 'zram-sysctl-settings
                          sysctl-service-type
                          `(("vm.swappiness" . "180")
                            ("vm.watermark_boost_factor" . "0")
                            ("vm.watermark_scale_factor" . "125")
                            ("vm.page-cluster" . "0")))

          #|Permission services|#
          (service opendoas-service-type
                   (opendoas-configuration
                     (rules (append rules:general
                                    rules:text-editors
                                    rules:power-management
                                    rules:service-management))))

          #|Special file services|#
          (service special-files-service-type
                   `(("/bin/sh" ,(file-append bash-minimal "/bin/bash"))
                     ("/usr/bin/env" ,(file-append coreutils "/bin/env"))
                     ("/etc/config.scm" ,buer.scm)))
          (simple-service 'persistent-files
                          special-files-service-type
                          (map (lambda (dir)
                                 (list dir (string-append "/gnu/persist" dir)))
                               file-system:persistent-files))

          #|Base services|#
          (service sysctl-service-type)
          (service urandom-seed-service-type)
          (service nscd-service-type)))))
buer
