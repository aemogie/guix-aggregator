(define-module (aetheria home services kmonad)
  #:use-module ((gnu services) #:select (service-type
                                         service-type-extensions
                                         service-extension-target
                                         for-home))
  #:use-module ((gnu services base) #:select (udev-service-type))
  #:use-module ((gnu home services) #:select (system->home-service-type))
  #:use-module ((aetheria services kmonad) #:select (kmonad-service-type))
  #:export (home-kmonad-service-type))

(define home-kmonad-service-type
  (let* ((kmonad-configuration
          (variable-ref (module-variable (resolve-module '(aetheria services kmonad))
                                         'kmonad-configuration)))
         (not-udev? (lambda (ext) (not (eq? (service-extension-target ext) udev-service-type))))
         (no-udev (service-type
                   (inherit kmonad-service-type)
                   (extensions
                    (filter not-udev? (service-type-extensions kmonad-service-type))))))
    (service-type
     (inherit (system->home-service-type no-udev))
     (default-value (for-home ((@@(aetheria services kmonad) kmonad-configuration)))))))
