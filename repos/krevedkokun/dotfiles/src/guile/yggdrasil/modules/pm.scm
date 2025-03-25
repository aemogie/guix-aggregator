(define-module (yggdrasil modules pm)
  #:use-module (gnu services)
  #:use-module ((gnu services desktop)
                #:select (upower-service-type
                          upower-configuration))
  #:use-module ((gnu services linux)
                #:select (kernel-module-loader-service-type))
  #:use-module ((gnu services pm)
                #:select (tlp-service-type
                          tlp-configuration)))

(define (system-services)
  (list
   ;; (service throttled-service-type) ; FIXME: figure out why it's not working anymore

   (service kernel-module-loader-service-type '("acpi_call"))

   (service
    upower-service-type
    (upower-configuration
     (use-percentage-for-policy? #t)))

   (service
    tlp-service-type
    (tlp-configuration
     (start-charge-thresh-bat0 75)
     (stop-charge-thresh-bat0 80)
     (start-charge-thresh-bat1 75)
     (stop-charge-thresh-bat1 80)))))
