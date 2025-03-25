(define-module (polterguix systems core-system)
  #:use-module (gnu)
  #:use-module (gnu system)
  #:use-module (gnu system privilege)
  
  
  #:use-module (gnu services avahi)
  #:use-module (gnu services cups)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop)
  ;; #:use-module (gnu services guix)
  #:use-module (gnu services networking)
  #:use-module (gnu services nix)
  #:use-module (gnu services ssh)
  #:use-module (gnu services sound) 
  #:use-module (gnu services xorg)
  
  #:use-module (gnu packages admin)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages emacs)  
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nfs)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages suckless) 
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages xdisorg)
  
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  
)


(define-public core-operating-system
  (operating-system
   (host-name "akhetaten")
   (kernel linux)
   (firmware (list linux-firmware))
   (initrd microcode-initrd)
   (timezone "America/Chicago")
   (keyboard-layout (keyboard-layout "us"))			
   (locale "en_US.utf8")
   

   ;; uefi grub with efi
   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))

   (file-systems (cons* (file-system
                         (mount-point "/tmp")
                         (device "none")
                         (type "tmpfs")
                         (check? #f))
                        %base-file-systems))

   (swap-devices (list (swap-space
			(target "/swap/swapfile"))))

   ;; users
   (users (append (list (user-account
			 (name "pol")
			 (comment "Paul Huang")
			 (group "users")
			 (home-directory "/home/pol")
			 (shell (file-append zsh "/bin/zsh"))
			 (supplementary-groups '("wheel"
						 "netdev"
						 "kvm"
						 "tty"
						 "input"                
						 "realtime"
						 "lp"
						 "audio"
						 "video")))
			(user-account
			 (name "admin")
			 (comment "Admin")
			 (group "users")
			 (home-directory "/home/admin")
                         (shell (file-append zsh "/bin/zsh"))
			 (supplementary-groups '("wheel" "netdev" "audio" "video"))))
		  %base-user-accounts))

   ;; real-time group
   (groups (cons (user-group (name "realtime"))
                 %base-groups))

   ;; essential system packages
   (packages (cons* bluez
                    bluez-alsa
                    brightnessctl
                    emacs-no-x-toolkit
                    emacs-desktop-environment
                    exfat-utils
                    font-awesome
                    fuse-exfat
                    git
                    libva-utils
                    ntfs-3g
                    solaar
                    stow
                    vim
                    zsh
                    %base-packages))
   (services
    (append (list

      ;; screen lockers
      (service screen-locker-service-type
               (screen-locker-configuration
                (name "slock")
                (program (file-append slock "/bin/slock"))))
      (service screen-locker-service-type
               (screen-locker-configuration
                (name "xlock")
                (program (file-append xlockmore "/bin/xlock"))))
      
      ;; add udev rules for MTP devices so that non-root users can access
      ;; them.
      (simple-service 'mtp udev-service-type (list libmtp))
      ;; add udev rules for scanners.
      (service sane-service-type)
      ;; add polkit rules so that non-root users in the wheel group can
      ;; perform admin tasks
      polkit-wheel-service
         
      ;; allow desktop users to also mount NTFS and NFS file systems
      ;; without root.
      (simple-service 'mount-setuid-helpers privileged-program-service-type
                      (map file-like->setuid-program
                           (list (file-append nfs-utils "/sbin/mount.nfs")
                                 (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))
      
      ;; volatile read-write file system mounted at /var/lib/gdm,
      ;; to avoid GDM stale cache and permission issues.
      gdm-file-system-service
      
      ;; global fontconfig cache directory can sometimes contain
      ;; stale entries, possibly referencing fonts that have been GC'd,
      ;; so mount it read-only.
      fontconfig-file-system-service
      
      ;; networkManager and its applet.
      (service network-manager-service-type)
      (service wpa-supplicant-service-type)    ;needed by NetworkManager
      (simple-service 'network-manager-applet
                      profile-service-type
                      (list network-manager-applet))
      (service modem-manager-service-type)
      (service usb-modeswitch-service-type)
      
      ;; d-Bus clique
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

      (service bluetooth-service-type
               (bluetooth-configuration
                (auto-enable? #t)))      
      (service ntp-service-type)
      (service x11-socket-directory-service-type)
      (service pulseaudio-service-type)
      (service alsa-service-type)
      (service gnome-desktop-service-type)
      (service gnome-keyring-service-type)
      (service openssh-service-type)
      (service tor-service-type)
      (service cups-service-type)
      (set-xorg-configuration
       (xorg-configuration (keyboard-layout keyboard-layout)))
      (service nix-service-type)
      (simple-service 'add-nonguix-substitutes
                               guix-service-type
                               (guix-extension
                                (substitute-urls
                                 (append (list "https://substitutes.nonguix.org")
                                         %default-substitute-urls))
                                (authorized-keys
                                 (append (list (plain-file "nonguix.pub"
                                                           "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                         %default-authorized-guix-keys)))))
     
            %base-services))))

