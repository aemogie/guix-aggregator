(define-module (operating-systems base)
  #|GNU Services|#
  #|•|# #:use-module (gnu services)
  #|S|# #:use-module (gnu services shepherd)

  #|GNU system|#
  #|•|# #:use-module (gnu system)

  #|Guix|#
  #|G|# #:use-module (guix gexp)

  #:export (base))

(define symlink-/etc/config.scm-shepherd-service
  (shepherd-service
   (provision '(symlink-/etc/config.scm))
   (requirement '(user-processes host-name))
   (start #~(lambda _
              (let* ((zero "/home/radio/areas/code/scm/zero/")
                     (host-config (string-append zero "operating-systems/"
                                                 (gethostname) ".scm")))
                (symlink host-config "/etc/config.scm")
                host-config)))
   (stop #~(lambda _
             (when (file-exists? "/etc/config.scm")
               (delete-file "/etc/config.scm"))))))

(define symlink-/etc/config.scm
  (simple-service 'symlink-/etc/config.scm
                  shepherd-root-service-type
                  (list symlink-/etc/config.scm-shepherd-service)))

(define base
  (operating-system
   (host-name "base")
   (file-systems '())
   (bootloader #f)
   (essential-services
    (cons symlink-/etc/config.scm
          (operating-system-default-essential-services
           this-operating-system)))))
