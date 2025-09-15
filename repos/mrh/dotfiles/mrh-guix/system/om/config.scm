(define-module (mrh-guix system om config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (nongnu packages linux) 
  #:use-module (nongnu system linux-initrd)
  #:use-module (gnu))

(use-package-modules admin
                     cryptsetup
                     curl
                     package-management
                     tls
                     version-control)

(use-service-modules dbus
                     desktop
                     docker
                     networking
                     ssh
                     syncthing
                     sysctl
                     vpn)

(define-public %om-operating-system
  (operating-system
    (kernel linux)
    (firmware (list linux-firmware))
    (initrd microcode-initrd)
    (host-name "om")
    (timezone "America/New_York")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us" "dvorak"))

    (users (cons (user-account
                   (name "mrh")
                   (group "users")
                   (home-directory "/home/mrh")
                   (supplementary-groups '("wheel"
                                           "docker"
                                           "netdev"
                                           "audio"
                                           "video"
                                           "input"
                                           "lp")))
                 %base-user-accounts))

    (packages (cons* btop
                     cryptsetup
                     curl
                     git
                     openssl
                     %base-packages))

    (services
     (cons*
      (service elogind-service-type
               (elogind-configuration
                 (handle-lid-switch 'ignore)
                 (handle-lid-switch-docked 'ignore)
                 (handle-lid-switch-external-power 'ignore)))
      
      (service wpa-supplicant-service-type)
      (service network-manager-service-type)
      (service ntp-service-type)

      (service nftables-service-type
               (nftables-configuration
                 (ruleset (local-file "nftables.conf"))))

      (service openssh-service-type
			   (openssh-configuration
			     (port-number 2222)
                 (password-authentication? #f)
                 (max-connections 3)))

      (service wireguard-service-type
               (wireguard-host-config
                (list (wireguard-host-peer "sleep" 2 %sleep-wireguard-key)
                      (wireguard-host-peer "phone" 3 %phone-wireguard-key))))

      (service syncthing-service-type
               (let ((sleep (syncthing-device
                              (name "sleep")
                              (id %sleep-syncthing-id)))
                     (phone (syncthing-device
                              (name "phone")
                              (id %phone-syncthing-id))))
                 (syncthing-configuration
                   (user "mrh")
                   (config-file
                    (syncthing-config-file
                      (gui-address "10.0.0.1:8384")
                      (folders (list (syncthing-folder
                                       (id "default")
                                       (label "default folder")
                                       (path "~/sync")
                                       (devices (list sleep phone))))))))))

      ;; required for oci-container-service-type
      (service containerd-service-type)
      (service docker-service-type)

      (service oci-container-service-type
               (let ((local-ip (format #f "~a.171" %local-ipv4-prefix))
                     (wireguard-ip (format #f "~a.1"  %wireguard-ipv4-prefix)))
                 (list (oci-container-configuration
                         (image "jellyfin/jellyfin")
                         (provision "jellyfin")
                         (network "host")
                         (ports (list (format #f "~a:8096:8096" wireguard-ip)
                                      (format #f "~a:8920:8920" wireguard-ip)
                                      (format #f "~a:8096:8096" local-ip)
                                      (format #f "~a:8920:8920" local-ip)))
                         (volumes '(("jellyfin-config" . "/config")
                                    ("jellyfin-cache" . "/cache")
                                    ("/home/mrh/media" . "/media"))))
                       (oci-container-configuration
                         (image "linuxserver/sabnzbd")
                         (provision "sabnzbd")
                         (ports (list (format #f "~a:8081:8081" wireguard-ip)
                                      (format #f "~a:8082:8082" wireguard-ip)))
                         (volumes '(("/home/mrh/media" . "/config")))
                         (environment '(("PUID" . "1000")
                                        ("PGID" . "998")
                                        ("TZ" . "Etc/UTC")))))))

      (modify-services %base-services
        (sysctl-service-type
         config => (sysctl-configuration
                     (settings
                      (append
                       '(("net.ipv4.ip_forward" . "1")
                         ("net.ipv6.conf.all.forwarding" . "1"))
                       %default-sysctl-settings))))
        (guix-service-type
         config => (guix-configuration
                     (inherit config)
                     (authorized-keys
                      (cons*
                       (local-file (format #f "~a/nonguix.pub" %guix-dots-dir))
                       %default-authorized-guix-keys))
                     (substitute-urls
                      (cons* "https://substitutes.nonguix.org"
                             %default-substitute-urls)))))))

    (bootloader (bootloader-configuration
                  (bootloader grub-efi-bootloader)
                  (targets (list "/boot/efi"))
                  (keyboard-layout keyboard-layout)))

    (swap-devices (list (swap-space
                          (target
                           (uuid "REPLACE-ME")))))

    (file-systems
     (cons* (file-system (mount-point "/")
                         (device
                          (uuid "REPLACE-ME" 'ext4))
                         (type "ext4"))
            (file-system (mount-point "/boot/efi")
                         (device (uuid "REPLACE-ME" 'fat32))
                         (type "vfat"))
            %base-file-systems))))

%om-operating-system
