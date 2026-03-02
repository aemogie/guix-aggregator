(define-module (lib common)
  #:use-module (guix gexp)
  #:use-module (gnu)
  #:use-module (gnu services base)
  #:use-module (gnu services authentication)
  #:use-module (gnu services linux)
  #:use-module (gnu services security-token)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services containers)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services networking)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  #:use-module (gnu packages android)
  #:use-module (gnu packages security-token)
  #:use-module (gnu packages firmware)
  #:use-module (gnu packages display-managers)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages linux)
  
  #:export (wlo-common-accounts
	    wlo-common-groups
	    wlo-common-packages
	    wlo-common-services))


(define %zmk-udev-rules
  (udev-rule
   "90-zmk-devices.rules"
   (string-append "ATTRS{idVendor}==\"0011\", ATTRS{idProduct}==\"0006\", "
                  "MODE=\"0666\", ENV{ID_MM_DEVICE_IGNORE}=\"1\", "
                  "ENV{ID_MM_PORT_IGNORE}=\"1\"\n"
                  "ATTRS{idVendor}==\"0011\", ATTRS{idProduct}==\"DEAD\", "
                  "MODE=\"0666\", ENV{ID_MM_DEVICE_IGNORE}=\"1\", "
                  "ENV{ID_MM_PORT_IGNORE}=\"1\"")))

;; a list of all of the services i use across every computer
(define wlo-common-services
  (cons* (service earlyoom-service-type)
         ;; (service gnome-desktop-service-type)
         (service screen-locker-service-type
                  (screen-locker-configuration
                   (name "swaylock")
                   (program (file-append swaylock-effects "/bin/swaylock"))))

         ;; To configure OpenSSH, pass an 'openssh-configuration'
         ;; record as a second argument to 'service' below.
         (service openssh-service-type)
         (service cups-service-type)
         (service fprintd-service-type)
         
	 ;; yubikey stuff
         (service pcscd-service-type)
         (udev-rules-service 'yubikey yubikey-personalization)
	 ;; enable configuration of my keyboard
         (udev-rules-service 'qmk qmk-udev-rules)
         ;; configuration of the endgame trackball
         (udev-rules-service 'zmk %zmk-udev-rules)
         ;; allow non-root users to adjust brightness
         (udev-rules-service 'light light)
         (udev-rules-service 'android android-udev-rules)
         ;; weylus (and probably ydotool)
         (udev-rules-service 'weylus
                             (udev-rule
                              "60-weylus.rules"
                              (string-append "KERNEL==\"uinput\", MODE==\"0660\", "
                                             "GROUP==\"uinput\", "
                                             "OPTIONS+=\"static_node=uinput\"")))

         (service libvirt-service-type
                  (libvirt-configuration
                   (unix-sock-group "libvirt")
                   (listen-tcp? #t)))
         (service virtlog-service-type)
	 (service greetd-service-type
		  (greetd-configuration
		   (motd "^_^")
		   (greeter-supplementary-groups (list "video" "input" "seat"))
		   (terminals
		    (list (greetd-terminal-configuration (terminal-vt "1"))
			  (greetd-terminal-configuration (terminal-vt "2"))
			  (greetd-terminal-configuration (terminal-vt "3"))
			  (greetd-terminal-configuration (terminal-vt "4"))
			  (greetd-terminal-configuration (terminal-vt "5"))
			  (greetd-terminal-configuration (terminal-vt "6"))
			  (greetd-terminal-configuration
			   (terminal-vt "7")
			   (terminal-switch #t)
			   (default-session-command
			     ;; later, look into making this graphical.
			     ;; manual login isn't too bad for now though.
			     (greetd-agreety-session
                              (command (file-append niri "/bin/niri --session"))
                              ;; default arg is -l for bash login, we want none
                              (command-args '()))))))))

         (service pam-limits-service-type
                  (list
                   ;; esync in wine
                   (pam-limits-entry "willow"
                                     'hard 'nofile 1048576)
                   ;; for audio work
                   (pam-limits-entry "@realtime"
                                     'both 'rtprio 99)
                   (pam-limits-entry "@realtime"
                                     'both 'memlock 'unlimited)))

         ;; This is the default list of services we
         ;; are appending to.
         (modify-services %desktop-services
			  (delete gdm-service-type)
			  (delete mingetty-service-type)

                          (guix-service-type
                           config => (guix-configuration
                                      (inherit config)
                                      (substitute-urls
                                       (append (list "https://substitutes.nonguix.org"
                                                     )
                                               %default-substitute-urls))
                                      (authorized-keys
                                       (append (list (local-file "./nonguix-signing-key.pub")
                                                     (local-file "./guix-hpc-signing-key.pub")
                                                     (local-file "./wlo-tower-signing-key.pub"))
                                                     ;; (local-file "./na-substitute-genenetwork-signing-key.pub"))
                                               %default-authorized-guix-keys)))))))

(define wlo-common-packages
  (append (specifications->packages
           (list "htop"
                 "xwayland-satellite"
                 "niri"
                 "swayfx"
                 "swaylock-effects"
                 "light" ;; change screen brightness
                 "gvfs"))
          %base-packages))

(define wlo-common-groups
  (cons* (user-group (name "plugdev")) ;; for qmk firmware access
	 (user-group (name "seat"))
	 (user-group (name "realtime"))
	 (user-group (name "adbusers"))
	 (user-group (name "uinput")) ;; for use with weylus
         %base-groups))

(define wlo-common-accounts
  (cons* (user-account
          (name "willow")
          (comment "Willow")
          (group "users")
          (home-directory "/home/willow")
          ;; the kvm group allows access to raw qemu
          (supplementary-groups '("wheel" "netdev" "audio" "video" "plugdev"
                                  "libvirt" "realtime" "kvm" "cgroup" "adbusers")))
	 %base-user-accounts))
