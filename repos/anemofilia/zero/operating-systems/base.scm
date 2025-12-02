(define-module (operating-systems base)
  #|GNU Services|#
  #|•|# #:use-module (gnu services)
  #|S|# #:use-module (gnu services shepherd)

  #|GNU system|#
  #|•|# #:use-module (gnu system)

  #|Guix|#
  #|G|# #:use-module (guix gexp)

  #:export (base))

(define symlink-/etc/config.scm-gexp
  #~(service '(symlink-/etc/config.scm)
             #:transient? #t
             #:requirement '(user-processes host-name)
             #:start (lambda _
                       (symlink
                        (string-append
                         "/home/radio/areas/code/scm/zero/"
                         "operating-systems/" (gethostname) ".scm")
                        "/etc/config.scm"))))

(define symlink-/etc/config.scm
  (simple-service 'symlink-/etc/config.scm shepherd-root-service-type
                  (list (shepherd-service
                         (provision '(symlink-/etc/config.scm))
                         (free-form symlink-/etc/config.scm-gexp)))))

(define base
  (operating-system
   (host-name "base")
   (file-systems '())
   (bootloader #f)
   (essential-services
    (cons symlink-/etc/config.scm
          (operating-system-default-essential-services
           this-operating-system)))))
