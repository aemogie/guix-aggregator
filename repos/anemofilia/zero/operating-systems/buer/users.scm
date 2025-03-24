(define-module (operating-systems buer users)
  #:use-module (operating-systems buer secrets)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages shells)
  #:use-module (gnu system accounts)
  #:use-module (guix gexp)

  #:export (radio root))

(define radio
  (user-account
   (name "radio")
   (password %radio-password)
   (home-directory "/home/radio")
   (shell (file-append fish "/bin/fish"))
   (uid 1000)
   (group "users")
   (supplementary-groups `("audio" "kvm" "seat" "video" "wheel"))))

(define root
  (user-account
   (name "root")
   (password %root-password)
   (home-directory "/root")
   (uid 0)
   (group "root")
   (shell (file-append bash "/bin/bash"))))
