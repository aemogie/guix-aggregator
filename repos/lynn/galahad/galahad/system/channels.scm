(define-module (galahad system channels)
  #:use-module (guix channels)
  #:use-module (srfi srfi-1) ; first
  #:use-module (guix gexp) ; plain-file
  #:export (%channels-guix
	    %channels-nonguix
	    %channels-artoria
	    %channels-guix-gaming
	    %channels-emacs
	    %authorized-guix-key-nonguix))

(define %channels-guix
  (first %default-channels))

(define %channels-nonguix
  (channel
   (name 'nonguix)
   (url "https://gitlab.com/nonguix/nonguix")
   (introduction
    (make-channel-introduction
     "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
     (openpgp-fingerprint
      "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define %channels-artoria
  (channel
   (name 'artoria)
   (url "https://git.transistor.house/lynn/artoria.git")
   (branch "main")
   (introduction
    (make-channel-introduction
     "56579fce18ab54c21442a98d923bd2bc6844d321"
     (openpgp-fingerprint
      "FE30 E8F6 522D 0615 35E0 E449 55E7 97F6 31DD A03C")))))

(define %channels-guix-gaming
  (channel
   (name 'guix-gaming-games)
   (url "https://gitlab.com/guix-gaming-channels/games.git")
   ;; Enable signature verification:
   (introduction
    (make-channel-introduction
     "c23d64f1b8cc086659f8781b27ab6c7314c5cca5"
     (openpgp-fingerprint
      "50F3 3E2E 5B0C 3D90 0424  ABE8 9BDC F497 A4BB CC7F")))))

(define %channels-emacs
  (channel
   (name 'emacs)
   (url "https://github.com/garrgravarr/guix-emacs")
   (introduction
    (make-channel-introduction
     "d676ef5f94d2c1bd32f11f084d47dcb1a180fdd4"
     (openpgp-fingerprint
      "2DDF 9601 2828 6172 F10C  51A4 E80D 3600 684C 71BA")))))

(define %authorized-guix-key-nonguix
  (plain-file "non-guix.pub" "
(public-key 
 (ecc 
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
  )
 )"))
