(define-module (polterguix systems core-system)
  #:use-module (gnu)
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
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu services avahi)
  #:use-module (gnu services cups)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  ;; #:use-module (gnu services guix)
  #:use-module (gnu services networking)
  #:use-module (gnu services nix)
  ;; #:use-module (gnu services ssh)
  #:use-module (gnu services sound) 
  #:use-module (gnu services xorg)
  #:use-module (gnu system)
  #:use-module (gnu system privilege)  
  #:use-module (nongnu packages linux))

(define-public core-operating-system
  (operating-system
   (kernel linux)
   ;; (initrd microcode-initrd)
   (firmware (list linux-firmware))

   (host-name "akhetaten")
   (timezone "America/Chicago")
   (locale "en_US.utf8")
   (keyboard-layout (keyboard-layout "us"))
   
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
                    hyprland
                    libva-utils
                    ntfs-3g
                    stow
                    vim
                    zsh
                    %base-packages))
   
   (services (append (list (service gnome-desktop-service-type)
                           (service openssh-service-type)
                           (service tor-service-type)
                           (service cups-service-type)
                           (service bluetooth-service-type
                                    (bluetooth-configuration
                                     (auto-enable? #t)))
                           (simple-service 'add-nonguix-substitutes
                                           guix-service-type
                                           (guix-extension
                                            (substitute-urls
                                             (append (list "https://substitutes.nonguix.org")
                                                     %default-substitute-urls))
                                            (authorized-keys
                                             (append (list (plain-file "nonguix.pub"
                                                                       "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                                     %default-authorized-guix-keys))))
                           (set-xorg-configuration
                            (xorg-configuration (keyboard-layout keyboard-layout))))
                     %desktop-services))))

