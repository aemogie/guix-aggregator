(use-modules (guix channels)
             (guix gexp)

             (gnu packages curl)
             (gnu packages package-management)
             (gnu packages version-control)
             (gnu packages text-editors)

             (gnu services)
             (gnu services base)

             (gnu system)
             (gnu system install)

             (nongnu packages linux))

(define %signing-key
  (plain-file "nonguix.pub" "\
(public-key
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(define %channels
  (cons* (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
         %default-channels))

(operating-system
  (inherit installation-os)
  (kernel linux)
  (firmware (list linux-firmware))

  (packages
   (cons* curl git mg (operating-system-packages installation-os)))

  (services
   (cons* (simple-service 'channels-file etc-service-type
						  `(("channels" ,(local-file "channels.scm"))))
		  (modify-services (operating-system-user-services installation-os)
			(guix-service-type
			 config => (guix-configuration
						(inherit config)
						(guix (guix-for-channels %channels))
						(authorized-keys
						 (cons* %signing-key
								%default-authorized-guix-keys))
						(substitute-urls
						 `(,@%default-substitute-urls
						   "https://substitutes.nonguix.org"))
						(channels %channels)))))))
