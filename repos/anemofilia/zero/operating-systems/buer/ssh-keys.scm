(define-module (operating-systems buer ssh-keys)
  #:use-module (gnu)
  #:export (yumiko.pub))

(define yumiko.pub
  (plain-file "yumiko.pub"
    (format #f
      "ssh-ed25519 ~
       AAAAC3NzaC1lZDI1NTE5AAAAIPaMmUA71F2BJPkVvArx6VGP21QMuJq4+mD7DHUPWcg9 ~
       guix@yumiko")))
