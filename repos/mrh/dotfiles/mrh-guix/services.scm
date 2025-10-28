(define-module (mrh-guix services)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd))

(define (unbound-after-wg-shepherd-service config)
  (let ((base-shepherd-services ((@@ (gnu services dns) unbound-shepherd-service)
                                 config)))
    (map (lambda (base-service)
           (shepherd-service
             (inherit base-service)
             (requirement (cons 'wireguard-wg0
                                (shepherd-service-requirement base-service)))))
         base-shepherd-services)))

(define-public unbound-after-wg-service-type
  (service-type
    (name 'unbound-after-wg)
    (description "unbound but with a shepherd requirement of wireguard")
    (extensions
     (list (service-extension account-service-type
                              (const (@@ (gnu services dns)
                                         unbound-account-service)))
           (service-extension shepherd-root-service-type
                              unbound-after-wg-shepherd-service)))))
