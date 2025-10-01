;; https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_9)
(define-module (X1))
(use-modules
  (gnu)
  (gnu system locale)
  (nongnu packages linux)
  (guix transformations)
  (config filesystems)
  (config guix-daemon)
  (dfsg contrib services tailscale)
  (srfi srfi-1))
(use-service-modules
  dns
  desktop
  linux
  mcron
  networking
  pm
  sddm
  ssh
  virtualization
  xorg)
(use-package-modules
  linux)

(define with-transformations
  (options->transformation
    `()))
    ;`((tune . "cannonlake"))))

(define (S pkg)
  (with-transformations (specification->package pkg)))

(define %sway-keyboard-function-keys
  (mixed-text-file
    "keyboard-function-keys"
    "bindsym XF86AudioMute exec " (S "pulseaudio") "/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle\n"
    "bindsym XF86AudioLowerVolume exec " (S "pulseaudio") "/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%\n"
    "bindsym XF86AudioRaiseVolume exec " (S "pulseaudio") "/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%\n"
    "bindsym XF86AudioMicMute exec " (S "pulseaudio") "/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle\n"
    "bindsym XF86MonBrightnessDown exec " (S "brightnessctl") "/bin/brightnessctl set 5%-\n"
    "bindsym XF86MonBrightnessUp exec " (S "brightnessctl") "/bin/brightnessctl set 5%+\n"
    ;; bindsym XF86Display
    "bindsym XF86WLAN exec " (S "util-linux") "/sbin/rfkill toggle all\n"
    "bindsym XF86NotificationCenter exec " (S "dunst") "/bin/dunstctl set-paused toggle\n"
    ;; bindsym XF86PickupPhone
    ;; bindsym XF86HangupPhone
    ;; bindsym XF86Favorites
    ))

(operating-system
  (host-name "X1")
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

  (kernel linux)
  (firmware
    (list i915-firmware
          ibt-hw-firmware
          iwlwifi-firmware
          sof-firmware
          wireless-regdb))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "f5bb474f-b7e7-46e1-b913-c1927df99a91"
                     'btrfs))
             (type "btrfs")
             (options "compress=zstd,discard,space_cache=v2"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "30D4-D6C5" 'fat32))
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

           (simple-service 'sway-kbd-fn-keys etc-service-type
                           `(("sway/config.d/function-keys"
                              ,%sway-keyboard-function-keys)))

           (service tlp-service-type)

           (service openssh-service-type
                    (openssh-configuration
                      (password-authentication? #t)))
           ;; guix system: error: symlink: File exists: "/etc/ssh"
           ;(simple-service 'ssh-known-hosts etc-service-type
           ;                `(("ssh/ssh_known_hosts" ,(local-file "Extras/ssh-known-hosts"))))

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
                      (hidden-services
                        (list
                          (tor-onion-service-configuration
                            (name "ssh")
                            (mapping '((22 "127.0.0.1:22"))))))))

           ;(udev-rules-service 'u2f libfido2 #:groups '("plugdev"))

           (service mcron-service-type
                    (mcron-configuration
                      (jobs (append
                              %btrfs-defrag-var-guix
                              (%btrfs-maintenance-jobs "/")))))

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
                      (size (* 8 (expt 2 30)))
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
                         (extra-options %extra-options)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
