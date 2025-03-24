;; my additions to (gnu packages package-management)
(define-module (aetheria packages package-management)
  #:use-module ((aetheria build-system file-like) #:select (raw-build-system))
  #:use-module ((guix monads) #:select (mlet))
  #:use-module ((guix store) #:select (%store-monad
                                       store-lift))
  #:use-module ((guix profiles) #:select (profile-manifest
                                          profile-derivation))
  #:use-module ((guix inferior) #:select (cached-channel-instance))
  #:use-module ((gnu packages package-management) #:select (guix))
  #:use-module ((guix channels) #:select (%channel-profile-hooks))
  #:use-module ((guix packages) #:select (package))
  #:export (guix-for-cached-channels))

(define (guix-for-cached-channels channels)
  (define drv
    (mlet %store-monad
        ((cached ((store-lift cached-channel-instance) channels)))
      (profile-derivation (profile-manifest cached)
                          #:hooks %channel-profile-hooks
                          #:format-version 3)))
  (package
    (inherit guix)
    (source drv)
    (build-system raw-build-system)
    (arguments '())))
