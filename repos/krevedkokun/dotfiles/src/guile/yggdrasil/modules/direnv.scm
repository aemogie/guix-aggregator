(define-module (yggdrasil modules direnv)
  #:use-module (gnu home services)
  #:use-module ((gnu packages shellutils) #:select (direnv))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((rde home services shells)
                #:select (home-bash-service-type
                          home-bash-extension)))

(define (home-services)
  (list
   (simple-service 'direnv-pkg
     home-profile-service-type
     (list direnv))
   (simple-service 'direnv-bash-hook
     home-bash-service-type
     (home-bash-extension
      (bashrc
       (list
        #~(format #f "eval \"$(~a hook bash)\""
                  (string-append #$direnv "/bin/direnv"))))))))
