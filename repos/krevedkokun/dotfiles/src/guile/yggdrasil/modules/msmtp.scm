(define-module (yggdrasil modules msmtp)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((yggdrasil home services msmtp)
                #:select (home-msmtp-service-type
                          home-msmtp-configuration)))

(define (home-services)
  (list
   (service
    home-msmtp-service-type
    (home-msmtp-configuration
     (config
      `((defaults)
        (auth on)
        (tls on)
        (logfile ,(string-append (getenv "XDG_STATE_HOME") "/log/msmtp.log"))
        ,#~""
        (account public)
        (tls_starttls off)
        (host smtp.migadu.com)
        (port 465)
        (from "nikita@domnitskii.me")
        (user "nikita@domnitskii.me")
        (passwordeval "pass show mail/nikita@domnitskii.me")
        ,#~""
        (account private)
        (tls_starttls off)
        (host smtp.migadu.com)
        (port 465)
        (from ,(getenv "MIGADU_USER"))
        (user ,(getenv "MIGADU_USER"))
        (passwordeval ,(format #f "pass show mail/~a" (getenv "MIGADU_USER")))))))))
