(define-module (yggdrasil modules ssh)
  #:use-module (gnu home services)
  #:use-module ((gnu home-services ssh)
                #:select (home-ssh-service-type
                          home-ssh-configuration
                          ssh-host)))

(define (home-services)
  (list
   (service
    home-ssh-service-type
    (home-ssh-configuration
     (extra-config
      (list
       (ssh-host
        (host "git.sr.ht")
        (options
         '((kex-algorithms . "-sntrup761x25519-sha512@openssh.com"))))))))))
