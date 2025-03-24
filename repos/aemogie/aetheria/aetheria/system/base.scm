(define-module (aetheria system base)
  ;; modify-services uses this?? but i thought macros were hygenic
  #:use-module ((srfi srfi-1) #:select (delete))
  #:use-module ((gnu services) #:select (service
                                         modify-services
                                         simple-service))
  #:use-module ((gnu services desktop) #:select (%desktop-services
                                                 bluetooth-service-type
                                                 bluetooth-configuration))
  #:use-module ((gnu services xorg) #:select (gdm-service-type))
  #:use-module ((gnu services base) #:select (guix-service-type
                                              guix-configuration
                                              guix-extension
                                              %default-authorized-guix-keys))
  #:use-module ((gnu services shepherd) #:select (shepherd-root-service-type
                                                  shepherd-configuration
                                                  shepherd-configuration-shepherd))
  #:use-module ((gnu services guix) #:select (guix-home-service-type))
  #:use-module ((gnu system) #:select (operating-system-default-essential-services
                                       operating-system
                                       this-operating-system))
  #:use-module ((gnu bootloader) #:select (bootloader-configuration))
  #:use-module ((gnu bootloader grub) #:select (grub-efi-bootloader))
  #:use-module ((gnu system file-systems) #:select (%base-file-systems))
  #:use-module ((gnu system accounts) #:select (user-account))
  #:use-module ((guix gexp) #:select (local-file))
  #:use-module ((guix store) #:select (%default-substitute-urls))
  #:use-module ((guix describe) #:select (current-channels))
  #:use-module ((aetheria) #:select (%project-root))
  #:use-module ((aetheria services kmonad) #:select (kmonad-service-type))
  #:use-module ((aetheria packages package-management) #:select (guix-for-cached-channels))
  #:use-module ((aetheria packages admin) #:select (shepherd-with-propagated-fibers))
  #:use-module ((aetheria home base) #:select (%aetheria-base-home))
  #:export (%aetheria-base-system
            %aetheria-base-services
            %aetheria-user-template))

(define nonguix-substitute-service
  (simple-service
   'nonguix-substitute-service
   guix-service-type
   (guix-extension
    (substitute-urls (list "https://substitutes.nonguix.org"))
    (authorized-keys (list (local-file
                            (string-append %project-root "/substitutes/nonguix.pub")))))))

(define %aetheria-user-template
  (user-account
   (name "user")
   (group "users")
   (password (crypt "password" "$6$aetheria"))
   (supplementary-groups '("wheel" "netdev" "audio" "video" "input"))))

(define %aetheria-base-services
  (cons*
   (service guix-home-service-type (list (list "root" %aetheria-base-home)))
   nonguix-substitute-service
   (service kmonad-service-type) ;; for udev rules
   (service bluetooth-service-type
            (bluetooth-configuration (auto-enable? #t)))
   (modify-services %desktop-services
     ;; use the build-time (current-channels) for the system as well
     (guix-service-type
      prev => (guix-configuration
               (inherit prev)
               (channels (current-channels))
               (guix (guix-for-cached-channels (current-channels)))))
     (delete gdm-service-type))))

(define (aetheria-base-essential-services os)
  ;; kinda stupid, i could instead just add it to the default packages too
  (modify-services (operating-system-default-essential-services os)
    (shepherd-root-service-type
     prev => (shepherd-configuration
              (inherit prev)
              (shepherd (shepherd-with-propagated-fibers
                         (shepherd-configuration-shepherd prev)))))))

(define %aetheria-base-system
  (operating-system
    (host-name "aetheria")
    (locale "en_GB.utf8")
    ;; TODO: look into moving to host-specific configuration. maybe introduce
    ;; another abstraction which is then rendered to an <operating-system>?
    (bootloader (bootloader-configuration
                 (bootloader grub-efi-bootloader)
                 (targets '("/boot"))))
    (services %aetheria-base-services)
    (essential-services
     (aetheria-base-essential-services this-operating-system))
    (file-systems %base-file-systems)
    (skeletons '())))
