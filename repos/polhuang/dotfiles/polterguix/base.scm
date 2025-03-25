;; (define-module (polterguix systems core-system)
;;   #:use-module (gnu)
;;   #:use-module (gnu system)
;;   #:use-module (nongnu packages linux))
  
;; (use-service-modules guix admin sysctl pm nix avahi dbus cups desktop linux
;; 		     mcron networking xorg ssh docker audio virtualization)

;; (use-package-modules audio video nfs certs shells ssh linux bash emacs gnome
;; 		     networking wm fonts libusb cups freedesktop file-systems
;; 		     version-control package-management vim)
  
;; (define-public base-operating-system
;;   (operating-system
;;    (timezone "America/Chicago")
;;    (locale "en_US.utf8")
   
;;    ;; Use non-free Linux and firmware
;;    (kernel linux)
;;    (firmware (list linux-firmware))
   
;;    (keyboard-layout (keyboard-layout "us"))
   
;;    ;; uefi grub with efi
;;    (bootloader (bootloader-configuration
;;                 (bootloader grub-efi-bootloader)
;;                 (targets '("/boot/efi"))
;;                 (keyboard-layout keyboard-layout)))
   
;;    ;; placeholder file-system
;;    (file-systems (cons*
;;                   (file-system
;;                    (mount-point "/tmp")
;;                    (device "none")
;;                    (type "tmpfs")
;;                    (check? #f))
;;                   %base-file-systems))
   
;;    ;; users
;;    (users (cons (user-account
;;                  (name "pol")
;;                  (comment "Paul Huang")
;;                  (group "users")
;;                  (home-directory "/home/polhuang")
;;                  (supplementary-groups '("wheel"  ;; sudo
;;                                          "netdev" ;; network devices
;;                                          "kvm"
;;                                          "tty"
;;                                          "input"
;;                                           "docker"
;;                                           "realtime" ;; realtime scheduling
;;                                           "lp"       ;; bluetooth devices
;;                                           "audio"    ;; audio devices
;;                                           "video"))) ;; video devices
;;                 %base-user-accounts))
   
;;    ;; Install bare-minimum system packages
;;    (packages (cons* bluez
;;                     bluez-alsa
;;                     brightnessctl
;;                     emacs-no-x-toolkit
;;                     exfat-utils
;;                     fuse-exfat
;;                     git
;;                     gvfs
;;                     libva-utils
;;                     ntfs-3g
;;                     stow
;;                     vim
;;                     %base-packages))
   
;;    (services
;;     (cons* (service bluetooth-service-type)
;;            %base-services))))
