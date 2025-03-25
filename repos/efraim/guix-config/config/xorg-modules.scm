(define-module (config xorg-modules)
  #:use-module (gnu packages xorg)
  #:export (%intel-xorg-modules))

;; It must be an explicit list, 'fold delete %default-xorg-modules' isn't enough.
(define %intel-xorg-modules
  (list xf86-video-vesa
        xf86-video-fbdev
        xf86-video-intel
        xf86-input-libinput))
