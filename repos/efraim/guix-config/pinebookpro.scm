(define-module (pinebookpro))
(use-modules
  (gnu)
  (gnu system locale)
  (nongnu packages firmware)
  (nongnu packages linux)
  (config filesystems)
  (config guix-daemon)
  (dfsg contrib services tailscale)
  (srfi srfi-1))
(use-service-modules
  cups
  desktop
  dns
  linux
  mcron
  networking
  sddm
  ssh
  virtualization
  xorg)
(use-package-modules
  cups
  firmware
  linux)

(define %sway-keyboard-function-keys
  (mixed-text-file
    "keyboard-function-keys"
    ;; bindsym XF86Sleep
    "bindsym XF86MonBrightnessUp exec " (specification->package "brightnessctl") "/bin/brightnessctl set 5%+\n"
    "bindsym XF86MonBrightnessDown exec " (specification->package "brightnessctl") "/bin/brightnessctl set 5%-\n"
    ;; Fn + F3 doesn't register as a key
    "bindsym XF86AudioMute exec " (specification->package "pulseaudio") "/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle\n"
    "bindsym XF86AudioLowerVolume exec " (specification->package "pulseaudio") "/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%\n"
    "bindsym XF86AudioRaiseVolume exec " (specification->package "pulseaudio") "/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%\n"
    ;; Fn + F7 actually does stop the keyboard
    ;; bindsym Insert
    ;; bindsym Print
    ;; bindsym Num_Lock
    ;; bindsym Scroll_Lock
    ;; bindsym Pause
    ;; TODO? Remap power button
    ))

(operating-system
  (host-name "pbp")
  (timezone "Asia/Jerusalem")
  (locale "en_IL.utf8")
  (locale-definitions
    (list (locale-definition (source "en_US")
                             (name "en_US.UTF-8"))
          (locale-definition (source "he_IL")
                             (name "he_IL.UTF-8"))))
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))

  ;; Currently using tow-boot
  #;(bootloader
    (bootloader-configuration
      (bootloader u-boot-pinebook-pro-rk3399-bootloader)
      (targets '("/dev/mmcblk2"))))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-removable-bootloader)
      (targets '("/boot/efi"))
      (keyboard-layout keyboard-layout)))

  (initrd-modules '())
  ;(initrd-modules (list "nvme"))        ; By default none.
  (kernel linux-arm64-generic)
  (firmware (list ap6256-firmware ath9k-htc-ar9271-firmware))

  (file-systems
    (cons* (file-system
             (device (file-system-label "Guix_image"))
             (mount-point "/")
             (type "btrfs")
             (options "compress=zstd,discard,space_cache=v2"))
           (file-system
             (mount-point "/boot/efi")
             (device (file-system-label "GNU-ESP"))
             (type "vfat"))
           ;%tmp-tmpfs
           %guix-temproots
           %base-file-systems))

  (users (cons* (user-account
                  (name "efraim")
                  (comment "Efraim Flashner")
                  (group "users")
                  (home-directory "/home/efraim")
                  (supplementary-groups
                    '("wheel" "netdev" "kvm"
                      ;"lp" "lpadmin"       ; CUPS
                      ;"plugdev"
                      "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (map specification->package
           (list "compsize"
                 "guix-backgrounds"
                 "guix-simplyblack-sddm-theme"  ; sddm theme
                 "xterm"

                 "sway"
                 "swayidle"
                 "swaylock"

                 "dunst"
                 "i3status"
                 "tofi"))
      %base-packages))

  (services
    (cons* (service screen-locker-service-type
                    (screen-locker-configuration
                      (name "swaylock")
                      (program (file-append (specification->package "swaylock")
                                              "/bin/swaylock"))
                      (allow-empty-password? #f)
                      (using-pam? #t)
                      (using-setuid? #f)))

           (extra-special-file
             "/var/lib/alsa/asound.state"
             (local-file "Extras/pbp-asound.state"))

           (simple-service 'sway-kbd-fn-keys etc-service-type
                           `(("sway/config.d/function-keys"
                              ,%sway-keyboard-function-keys)))

           (service openssh-service-type
                    (openssh-configuration
                      (password-authentication? #t)
                      (authorized-keys
                       `(("efraim" ,(local-file "Extras/efraim.pub"))))))

           (service tailscaled-service-type
                    (tailscaled-configuration
                      (package (specification->package "tailscale"))))

           (service dnsmasq-service-type
                    (dnsmasq-configuration
                      (no-resolv? #t)
                      (servers '("192.168.1.1"
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

           #;(service cups-service-type
                    (cups-configuration
                      (web-interface? #t)
                      (default-paper-size "A4")
                      (extensions
                        (list cups-filters hplip-minimal))))

           (service mcron-service-type
                    (mcron-configuration
                      (jobs (append
                              %btrfs-defrag-var-guix
                              (%btrfs-maintenance-jobs "/")))))

           (service openntpd-service-type
                    (openntpd-configuration
                      (listen-on '("127.0.0.1" "::1"))
                      (constraints-from '("https://www.google.com/"))))

           ;; This one seems to cause the boot process to hang.
           #;(service qemu-binfmt-service-type
                    (qemu-binfmt-configuration
                      ;; We get some architectures for free.
                      (platforms
                        (fold delete %qemu-platforms
                              (lookup-qemu-platforms "arm" "aarch64")))))

           (service earlyoom-service-type
                    (earlyoom-configuration
                      (prefer-regexp "(cc1(plus)?|.rustc-real|ghc|Web Content)")
                      (avoid-regexp "guile")))

           (service zram-device-service-type
                    (zram-device-configuration
                      (size (* 4 (expt 2 30)))
                      (compression-algorithm 'zstd)
                      (priority 100)))

           (remove (lambda (service)
                     (let ((type (service-kind service)))
                       (or (memq type
                                 (list
                                   modem-manager-service-type
                                   ntp-service-type
                                   screen-locker-service-type))
                           (eq? 'network-manager-applet
                                (service-type-name type)))))
                   (modify-services
                     %desktop-services
                     (sddm-service-type
                       config =>
                       (sddm-configuration
                         (inherit config)
                         (theme "guix-simplyblack-sddm")
                         ;; This is failing since the update to sddm-0.20.0
                         ;(display-server "wayland")
                         (numlock "off")))

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
                           (cons* "--cores=3" %extra-options))))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))

;; guix system image --image-type=efi-raw -L ~/workspace/my-guix/ -L ~/workspace/guix-config/ ~/workspace/guix-config/pinebookpro.scm --system=aarch64-linux
;; sudo cfdisk /dev/sdX to resize /dev/sdX2 to use the remaining space left at the end of the µSD card
;; guix shell e2fsprogs -- sudo resize2fs /dev/sdX2
;; guix shell e2fsck-static -- sudo -E e2fsck /dev/sdX2
;; guix shell btrfs-progs -- sudo btrfs-convert -L /dev/sdX2
