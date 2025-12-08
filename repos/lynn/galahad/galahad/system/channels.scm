(define-module (galahad system channels)
  #:use-module (guix channels)
  #:use-module (srfi srfi-1) ; first
  #:use-module (guix gexp) ; plain-file
  #:export (%channels-guix
	    %channels-nonguix
	    %authorized-guix-key-nonguix))

(define %channels-guix
  (channel
   (name 'guix)
   (url "https://codeberg.org/guix/guix.git")
   (branch "master")
   (introduction
    (make-channel-introduction
     "9edb3f66fd807b096b48283debdcddccfea34bad"
     (openpgp-fingerprint
      "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(define %channels-nonguix
  (channel
   (name 'nonguix)
   (url "https://gitlab.com/nonguix/nonguix")
   (introduction
    (make-channel-introduction
     "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
     (openpgp-fingerprint
      "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define %authorized-guix-key-nonguix
  (plain-file "non-guix.pub" "
(public-key 
 (ecc 
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
  )
 )"))
