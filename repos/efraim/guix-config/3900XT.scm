(define-module (3900XT))
(use-modules
  (gnu)
  (gnu system locale)
  (guix transformations)
  (config filesystems)
  (config guix-daemon)
  (dfsg contrib services tailscale)
  (srfi srfi-1))
(use-service-modules
  cups
  dns
  desktop
  linux
  mcron
  networking
  sddm
  ssh
  virtualization
  xorg)
(use-package-modules
  cups)

(define with-transformations
  (options->transformation
    `((tune . "znver2"))))

(define (S pkg)
  (with-transformations (specification->package pkg)))

(define %sway-keyboard-function-keys
  (mixed-text-file
    "keyboard-function-keys"
    ;; bindsym XF86Tools
    "bindsym XF86AudioLowerVolume exec " (S "pulseaudio") "/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%\n"
    "bindsym XF86AudioRaiseVolume exec " (S "pulseaudio") "/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%\n"
    "bindsym XF86AudioMute exec " (S "pulseaudio") "/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle\n"
    ;; bindsym XF86AudioPrev
    ;; bindsym XF86AudioNext
    ;; bindsym XF86AudioPlay
    ;; bindsym XF86AudioStop
    ;; bindsym XF86HomePage
    ;; bindsym XF86Mail
    ;; bindsym XF86Explorer
    ;; bindsym XF86Favorites
    ))

(operating-system
  (host-name "3900XT")
  (timezone "Asia/Jerusalem")
  (locale "en_IL.utf8")
  (locale-definitions
    (list (locale-definition (source "en_US")
                             (name "en_US.UTF-8"))
          (locale-definition (source "he_IL")
                             (name "he_IL.UTF-8"))))
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets '("/boot/efi"))
      (keyboard-layout keyboard-layout)))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "20048579-a0bd-4180-8ea3-4b546309fb3b"
                     'btrfs))
             (type "btrfs")
             (options "compress=zstd,discard,space_cache=v2"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "9146-2C77" 'fat32))
             (type "vfat"))
           %tmp-tmpfs
           %guix-temproots
           %base-file-systems))

  (users (cons* (user-account
                  (name "efraim")
                  (comment "Efraim Flashner")
                  (group "users")
                  (home-directory "/home/efraim")
                  (supplementary-groups
                    '("wheel" "netdev" "kvm"
                      "lp" "lpadmin"
                      "libvirt"
                      ;"plugdev"
                      "audio" "video")))
                %base-user-accounts))
  (packages
   (map with-transformations
        (append
          (map specification->package
               (list "adwaita-icon-theme"
                     "compsize"
                     "git-minimal"                  ; git-upload-pack
                     "guix-backgrounds"
                     "guix-simplyblack-sddm-theme"  ; sddm theme
                     "virt-manager"
                     "xterm"

                     "sway"
                     "swayidle"
                     "swaylock"

                     "dunst"
                     "i3status"
                     "tofi"))
          %base-packages)))

  (services
    (cons* (service screen-locker-service-type
                    (screen-locker-configuration
                      (name "swaylock")
                      (program (file-append (S "swaylock")
                                              "/bin/swaylock"))
                      (allow-empty-password? #f)
                      (using-pam? #t)
                      (using-setuid? #f)))

           (service guix-publish-service-type
                    (guix-publish-configuration
                      (host "0.0.0.0")
                      (port 3000)
                      (advertise? #t)))

           (simple-service 'sway-kbd-fn-keys etc-service-type
                           `(("sway/config.d/function-keys"
                              ,%sway-keyboard-function-keys)))

           (extra-special-file
             "/usr/share/zoneinfo/tzdata.zi"
             (file-append (S "tzdata") "/share/zoneinfo/tzdata.zi"))

           (service openssh-service-type
                    (openssh-configuration
                      (password-authentication? #t)))
           ;; guix system: error: symlink: File exists: "/etc/ssh"
           ;(simple-service 'ssh-known-hosts etc-service-type
           ;                `(("ssh/ssh-known-hosts" ,(local-file "Extras/ssh-known-hosts"))))

           (service tailscaled-service-type
                    (tailscaled-configuration
                      (package (S "tailscale"))))

           (service dnsmasq-service-type
                    (dnsmasq-configuration
                      (listen-addresses '("127.0.0.1" "::1"))
                      (no-resolv? #t)
                      (servers '("192.168.68.1"
                                 ;; Tailscale
                                 "/unicorn-typhon.ts.net/100.100.100.100"
                                 ;; OpenDNS servers
                                 "208.67.222.222"
                                 "208.67.220.220"
                                 "2620:119:35::35"
                                 "2620:119:53::53"))))

           (service tor-service-type
                    (tor-configuration
                      (config-file
                        (plain-file
                          "extra-torrc-bits"
                          (string-append
                            "# NumCPUs only affects relays, but we want to silence the warnings\n"
                            "NumCPUs 2\n")))
                      (hidden-services
                        (list
                          (tor-onion-service-configuration
                            (name "ssh")
                            (mapping '((22 "127.0.0.1:22"))))
                          (tor-onion-service-configuration
                            (name "guix-publish")
                            ;; k7muufoychzetmq7evsv6gcq4sxq4olxo3uy2zlhek5fkfvl5uscbgyd.onion
                            (mapping '((3000 "127.0.0.1:3000"))))))))

           (service cups-service-type
                    (cups-configuration
                      (web-interface? #t)
                      (default-paper-size "A4")
                      (extensions
                        (list cups-filters hplip-minimal))))

           ;(udev-rules-service 'u2f libfido2 #:groups '("plugdev"))

           (service mcron-service-type
                    (mcron-configuration
                      (jobs (append
                              %btrfs-defrag-var-guix
                              (%btrfs-maintenance-jobs "/")))))

           (service libvirt-service-type
                    (libvirt-configuration
                      (unix-sock-group "libvirt")))
           (service virtlog-service-type)

           (service qemu-binfmt-service-type
                    (qemu-binfmt-configuration
                      ;; We get some architectures for free.
                      (platforms
                        (fold delete %qemu-platforms
                              (lookup-qemu-platforms "i386" "x86_64")))))

           (service earlyoom-service-type
                    (earlyoom-configuration
                      (prefer-regexp "(cc1(plus)?|.rustc-real|ghc|Web Content)")
                      (avoid-regexp "guile")))

           (service zram-device-service-type
                    (zram-device-configuration
                      (size (* 16 (expt 2 30)))
                      (compression-algorithm 'zstd)
                      (priority 100)))

           (service sddm-service-type
                    (sddm-configuration
                      (theme "guix-simplyblack-sddm")
                      ;; This is failing since the update to sddm-0.20.0
                      ;(display-server "wayland")
                      ))

           (remove (lambda (service)
                     (let ((type (service-kind service)))
                       (or (memq type
                                 (list
                                   gdm-service-type
                                   modem-manager-service-type
                                   screen-locker-service-type))
                           (eq? 'network-manager-applet
                                (service-type-name type)))))
                   (modify-services
                     %desktop-services
                     (guix-service-type
                       config =>
                       (guix-configuration
                         (inherit config)
                         ;; Rely on btrfs compression.
                         (log-compression 'none)
                         (discover? #t)
                         (substitute-urls %substitute-urls)
                         (authorized-keys %authorized-keys)
                         (extra-options
                           (cons* "--max-jobs=5" %extra-options))))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
