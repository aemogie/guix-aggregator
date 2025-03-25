(define-module (mrh-guix system box)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (mrh-guix system base)

  #:use-module (gnu)

  #:use-module (nongnu packages linux) 
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu services nvidia)
  #:use-module (nongnu system linux-initrd))

(use-package-modules admin compton cryptsetup package-management version-control wm)
(use-service-modules cups dbus desktop docker networking ssh sddm sysctl vpn xorg)

(define-public box-operating-system
  (operating-system
   (inherit base-operating-system)
   (kernel-arguments (cons* "modprobe.blacklist=nouveau"
			                %default-kernel-arguments))
   (initrd microcode-initrd)
   (host-name "guix-box")
   (keyboard-layout (keyboard-layout "us" "dvorak"))

   (users (cons* (user-account
                  (name "mrh")
                  (group "users")
                  (home-directory "/home/mrh")
                  (supplementary-groups
                   '("wheel" "docker" "netdev" "audio" "video" "input" "lp")))
			     %base-user-accounts))

   (packages (map replace-mesa (cons* btop
		                              cryptsetup
		                              git
		                              i3-wm
		                              i3lock
		                              i3blocks
		                              picom
		                              %base-packages)))

   (services
    (cons* 
     (service cups-service-type
	          (cups-configuration
	           (web-interface? #t)))

     (service bluetooth-service-type
	          (bluetooth-configuration
	           (name "guix-box")))

     ;; required for oci-container-service-type
     (service elogind-service-type)
     (service containerd-service-type)
     (service docker-service-type)

     (service oci-container-service-type
              (list (oci-container-configuration
				     (image "jellyfin/jellyfin")
				     (provision "jellyfin")
				     (network "host")
				     (ports '(("8096" . "8096")))
				     (volumes '(("jellyfin-config" . "/config")
                                ("jellyfin-cache" . "/cache")
                                ("/home/mrh/media" . "/media"))))
                    (oci-container-configuration
                     (image "linuxserver/sabnzbd")
                     (provision "sabnzbd")
                     (ports '("10.0.0.1:8081:8080"))
                     (volumes '(("/home/mrh/media" . "/config")))
                     (environment '(("PUID" . "1000")
                                    ("PGID" . "998")
                                    ("TZ" . "Etc/UTC"))))))

     (service nftables-service-type
			  (nftables-configuration
			   (ruleset (plain-file "nftables.conf" %nftables-config))))

     (service wireguard-service-type
			  (wireguard-host-config
			   (list (wireguard-host-peer "guix-lap" 2 %lap-public-key)
                     (wireguard-host-peer "phone" 3 %phone-public-key))))

     (service nvidia-service-type)
     (set-xorg-configuration
      (xorg-configuration
       (keyboard-layout keyboard-layout)
       (modules (cons nvda %default-xorg-modules))
       (drivers '("nvidia")))     
      sddm-service-type)

     (modify-services
      (operating-system-user-services base-operating-system)
      (sysctl-service-type
	   config => (sysctl-configuration
	    		  (settings
	    		   (append '(("net.ipv4.ip_forward" . "1")
	    					 ("net.ipv6.conf.all.forwarding" . "1"))
	    				   %default-sysctl-settings)))))))

   (swap-devices (list (swap-space
					    (target (uuid "0d1e3200-3aed-4c35-a376-a839d9e8ccef")))))

   (file-systems
    (cons* (file-system (mount-point "/")
		                (device (uuid "3a7ea0db-cdca-4d6f-ac73-26095aa68178" 'ext4))
		                (type "ext4"))
           (file-system (mount-point "/boot/efi")
		                (device (uuid "2A6C-A323" 'fat32))
		                (type "vfat"))
	       %base-file-systems))))

box-operating-system
