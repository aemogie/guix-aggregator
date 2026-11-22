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
                                                  shepherd-service
                                                  shepherd-transient-service-type
                                                  shepherd-configuration
                                                  shepherd-configuration-shepherd))
  #:use-module ((gnu services guix) #:select (guix-home-service-type
                                              shared-cache-service-type
                                              shared-cache-configuration
                                              user-cache))
  #:use-module ((gnu services nix) #:select (nix-service-type
                                             nix-configuration))
  #:use-module ((gnu system) #:select (operating-system-default-essential-services
                                       operating-system
                                       operating-system-users
                                       this-operating-system))
  #:use-module ((gnu home) #:select (home-environment))
  #:use-module ((gnu bootloader) #:select (bootloader-configuration))
  #:use-module ((gnu bootloader grub) #:select (grub-efi-bootloader))
  #:use-module ((gnu system file-systems) #:select (%base-file-systems))
  #:use-module ((gnu system accounts) #:select (user-account
                                                user-account-name
                                                user-account-group
                                                user-account-home-directory
                                                user-account-create-home-directory?))
  #:use-module ((guix gexp) #:select (gexp local-file))
  #:use-module ((guix store) #:select (%default-substitute-urls))
  #:use-module ((guix describe) #:select (current-channels))
  #:use-module ((aetheria) #:select (%project-root))
  #:use-module ((aetheria services persist) #:select (persist-service-type
                                                      persist-configuration))
  #:use-module ((aetheria services kmonad) #:select (kmonad-service-type))
  #:use-module ((aetheria packages package-management) #:select (guix-for-cached-channels))
  #:use-module ((aetheria packages admin) #:select (shepherd-with-propagated-fibers))
  #:use-module ((aetheria home services base) #:select (home-base-service-type))
  #:export (%aetheria-base-system
            aetheria-base-services
            %aetheria-user-template))
(define operating-system-accounts (@@ (gnu system) operating-system-accounts))

(define nonguix-substitute-service
  (simple-service
   'nonguix-substitute-service
   guix-service-type
   (guix-extension
    (substitute-urls (list "https://substitutes.nonguix.org"))
    (authorized-keys (list (local-file
                            (string-append %project-root "/substitutes/nonguix.pub")))))))
(define guix-science-substitute-service
  (simple-service
   'guix-science-substitute-service
   guix-service-type
   (guix-extension
    (substitute-urls (list "https://guix.bordeaux.inria.fr"))
    (authorized-keys (list (local-file
                            (string-append %project-root "/substitutes/guix-science.pub")))))))

(define %aetheria-user-template
  (user-account
   (name "user")
   (group "users")
   (password (crypt "password" "$6$aetheria"))
   (supplementary-groups '("wheel" "netdev" "audio" "video" "input"))))

(define (aetheria-base-services os)
  (cons*
   (service guix-home-service-type
            `(("root" ,(home-environment
                         (services (list (service home-base-service-type)))))))
   nonguix-substitute-service
   guix-science-substitute-service
   #;(service kmonad-service-type) ;; for udev rules
   (service bluetooth-service-type
            (bluetooth-configuration (auto-enable? #t)))
   (service nix-service-type
            (nix-configuration
              (extra-config '("extra-experimental-features = flakes nix-command"))))
   (simple-service
    'shepherd-repl
    shepherd-root-service-type
    (list (shepherd-service
            (provision '(repl))
            (modules '((shepherd service repl)))
            (free-form #~(repl-service)))))
   (simple-service 'shepherd-transient shepherd-transient-service-type '())
   (simple-service 'persist-for-users persist-service-type
                   (map (lambda (user)
                          (persist-configuration
                           (user user)
                           (src (user-account-home-directory user))
                           ;; looks hacky, but its what works
                           (dest (string-append (user-account-home-directory user) "/.local/state/persist"
                                                (user-account-home-directory user)))
                           (requirements '(user-homes))))
                        (filter user-account-create-home-directory? (operating-system-accounts os))))
   (service shared-cache-service-type (shared-cache-configuration (mode 'share)))
   (simple-service 'shared-cache-for-users shared-cache-service-type
                   (map (lambda (user*)
                          (user-cache
                           (user     (user-account-name user*))
                           (location (string-append (user-account-home-directory user*) "/.cache"))
                           (group    (user-account-group user*))))
                        (filter user-account-create-home-directory? (operating-system-accounts os))))
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
    (services
     (aetheria-base-services this-operating-system))
    (essential-services
     (aetheria-base-essential-services this-operating-system))
    (file-systems %base-file-systems)
    (skeletons '())))
