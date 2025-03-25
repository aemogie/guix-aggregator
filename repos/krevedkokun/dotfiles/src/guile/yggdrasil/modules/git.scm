(define-module (yggdrasil modules git)
  #:use-module (gnu home services)
  #:use-module ((gnu home-services version-control)
                #:select (home-git-service-type
                          home-git-configuration))
  #:use-module ((gnu packages version-control) #:select (git))
  #:use-module (gnu services)
  #:use-module (guix gexp))

(define (home-services)
  (list
   (simple-service 'git-packages
     home-profile-service-type
     (list (list git "send-email")))
   (service
    home-git-service-type
    (home-git-configuration
     (config
      `((user
         ((name . "Nikita Domnitskii")
          (email . "nikita@domnitskii.me")
          (signingkey . "99465567F17FF3EFD36300348469C699F6646AC6")))
        (pull
         ((rebase . #t)))
        (github
         ((user . "krevedkokun")))
        (sendemail                      ; TODO: move to mail module?
         ((smtpserver . "smtp.migadu.com")
          (smtpuser . ,(getenv "MIGADU_USER"))
          (smtpencryption . "ssl")
          (smtpserverport . "465")
          (annotate . #t)))
        (diff
         ((submodule . diff)))
        (format
         ((signature . "")
          (coverLetter . auto)))))))))
