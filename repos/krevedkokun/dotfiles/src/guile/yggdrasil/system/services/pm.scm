(define-module (yggdrasil system services pm)
  #:use-module (guix gexp)

  #:use-module (yggdrasil packages pm)

  #:use-module (gnu services)
  #:use-module (gnu services shepherd)

  #:export (throttled-service-type))

(define (throttled-shepherd-services _)
  (list
   (shepherd-service
    (provision '(throttled))
    (requirement '(dbus-system))
    (documentation "")
    (start #~(make-forkexec-constructor
              (list (string-append #$throttled "/bin/throttled.py"))
              #:log-file "/var/log/throttled.log"
              #:environment-variables '("PYTHONUNBUFFERED=1")))
    (stop #~(make-kill-destructor)))))

(define throttled-service-type
  (service-type
   (name 'throttled)
   (extensions
    (list (service-extension
           shepherd-root-service-type
           throttled-shepherd-services)))
   (default-value #f)
   (description "")))
