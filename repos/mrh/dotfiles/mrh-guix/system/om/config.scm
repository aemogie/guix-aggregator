(define-module (mrh-guix system om config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (mrh-guix system om networking)
  #:use-module (mrh-guix system om web)
  #:use-module (mrh services)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (gnu)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports))

(use-package-modules admin
                     cryptsetup
                     curl
                     dns
                     package-management
                     tls
                     version-control)

(use-service-modules containers
                     dbus
                     desktop
                     dns
                     docker
                     networking
                     nfs
                     ssh
                     syncthing
                     sysctl
                     vpn
                     web)

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
                     (list isc-bind "utils")
                     openssl
                     %base-packages))

    (services
     (cons*
      (service elogind-service-type
               (elogind-configuration
                 (handle-lid-switch 'ignore)
                 (handle-lid-switch-docked 'ignore)
                 (handle-lid-switch-external-power 'ignore)))

      %wpa-supplicant-service
      %nftables-service
      %unbound-service
      %dhcpcd-service

      (service ntp-service-type)

      (service openssh-service-type
               (openssh-configuration
                 (port-number 2222)
                 (password-authentication? #f)
                 (max-connections 5)))

      (service wireguard-service-type
               (wireguard-host-config
                (list (wireguard-host-peer "sleep" 2 %sleep-wireguard-key)
                      (wireguard-host-peer "phone" 3 %phone-wireguard-key)
                      (wireguard-host-peer "vps" 4 %vps-wireguard-key))))

      (service syncthing-service-type
               (syncthing-configuration
                 (user "mrh")
                 (config-file
                  (syncthing-config-file
                    (gui-address (format #f "[::1]:8384" %ipv6-wireguard-host))
                    (gui-user "wumpus")
                    (gui-password %syncthing-password)
                    (folders
                     (let ((sleep (syncthing-device
                                    (name "sleep")
                                    (id %sleep-syncthing-id)))

                           (phone (syncthing-device
                                    (name "phone")
                                    (id %phone-syncthing-id))))
                       (list (syncthing-folder
                               (id "default")
                               (label "default folder")
                               (path "~/sync")
                               (devices (list sleep phone)))

                             (syncthing-folder
                               (id "dotfiles")
                               (label "dotfiles folder")
                               (path "~/src/dotfiles")
                               (devices (list sleep))))))))))

      (service nfs-service-type
               (nfs-configuration
                 (exports
                  '(("/mnt/wd"
                     "sleep(rw,sync,insecure,no_root_squash,no_subtree_check)")))))

      ;; required for oci-service-type
      (service containerd-service-type)
      (service docker-service-type)

      (simple-service
       'oci-provisioning
       oci-service-type
       (oci-extension
        (containers
         (let ((oci-uid (get-line (open-input-pipe "id oci-container -u")))
               (oci-gid (get-line (open-input-pipe "id oci-container -g"))))
           (list (oci-container-configuration
                   (image "linuxserver/sabnzbd")
                   (provision "sabnzbd")
                   (network "host")
                   (ports '("[::1]:8081:8081"))
                   (environment `(("PUID" . ,oci-uid)
                                  ("PGID" . ,oci-gid)
                                  ("TZ" . "Etc/UTC")))
                   (volumes '(("/home/mrh/.config/sabnzbd" . "/config")
                              ("/mnt/wd/media" . "/media"))))

                 (oci-container-configuration
                   (image "jellyfin/jellyfin")
                   (provision "jellyfin")
                   (network "host")
                   (ports '("[::1]:8096:8096"))
                   (environment `(("PUID" . ,oci-uid)
                                  ("PGID" . ,oci-gid)))
                   (volumes '(("jellyfin-config" . "/config")
                              ("jellyfin-cache" . "/cache")
                              ("/mnt/wd/media" . "/media")))))))))

      %nginx-service

      (service i2pd-service-type
               (i2pd-configuration
                (user "mrh")
                (conf "/home/mrh/.config/i2pd/i2pd.conf")
                (datadir "/home/mrh/.config/i2pd")))

      (modify-services %base-services
        (sysctl-service-type
         config => (sysctl-configuration
                     (settings
                      (append '(("net.ipv6.conf.all.forwarding" . "1")
                                ("net.ipv4.ip_forward" . "1"))
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

    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets (list "/boot/efi"))
        (keyboard-layout keyboard-layout)))

    (swap-devices
     (list (swap-space
             (target (uuid "23c6c6c3-3653-4eed-95fa-cee1b87acc32")))))

    (file-systems
     (cons* (file-system
              (mount-point "/")
              (device
               (uuid "6ec680cc-bf14-49d2-b4d0-d4feac003ae1" 'ext4))
              (type "ext4"))
            (file-system
              (mount-point "/boot/efi")
              (device (uuid "1921-C31A" 'fat32))
              (type "vfat"))
            %base-file-systems))))

%om-operating-system
