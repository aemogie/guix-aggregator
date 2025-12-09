(define-module (operating-systems base)
  #|GNU Services|#
  #|•|# #:use-module (gnu services)
  #|S|# #:use-module (gnu services shepherd)

  #|GNU system|#
  #|•|# #:use-module (gnu system)
  #|P|# #:use-module (gnu system pam)

  #|Guix|#
  #|G|# #:use-module (guix gexp)

  #|Ice-9|#
  #|M|# #:use-module (ice-9 match)

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

(define freetype-properties
  `((cff:no-stem-darkening . 0)
    (cff:darkening-parameters . (500 400 1000 350 1500 325 2000 300))
    (autofitter:no-stem-darkening . 0)
    (autofitter:darkening-parameters . (500 400 1000 350 1500 325 2000 300))))

(define base
  (operating-system
   (host-name "base")
   (file-systems '())
   (bootloader #f)
   (essential-services
    (cons* (simple-service 'symlink-/etc/config.scm
                           shepherd-root-service-type
                           (list symlink-/etc/config.scm-shepherd-service))
           (simple-service 'global-environment-variables
                           session-environment-service-type
                           `(("FREETYPE_PROPERTIES"
                              . ,(string-join
                                   (map (match-lambda
                                          [(var . (? number? val))
                                           (format #f "~a=~a" var val)]
                                          [(var . (? list? val))
                                           (apply format #f "~a=~a~@{,~a~}" var val)])
                                        freetype-properties)))))
           (operating-system-default-essential-services this-operating-system)))))
