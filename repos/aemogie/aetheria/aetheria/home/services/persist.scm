(define-module (aetheria home services persist)
  #:use-module ((gnu services) #:select (service-type
                                          service-type-extensions
                                          service-extension-target
                                          for-home
                                          etc-service-type))
  #:use-module ((gnu services base) #:select (file-system-service-type))
  #:use-module ((gnu home services) #:select (system->home-service-type
                                              define-service-type-mapping))
  #:use-module ((aetheria services persist) #:select (persist-service-type
                                                      persist-configuration
                                                      persist-configuration-defaults))
  #:re-export (persist-configuration
               persist-configuration-defaults)
  #:export (home-persist-service-type))


(define home-persist-service-type
  (system->home-service-type
   (service-type
     (inherit persist-service-type)
     (extensions
      (filter
       (lambda (ext) (not (memq (service-extension-target ext)
                                (list file-system-service-type etc-service-type))))
       (service-type-extensions persist-service-type))))))

(service-type-extensions home-persist-service-type)

(define-service-type-mapping
  persist-service-type => home-persist-service-type)
