(define-module (misako operating-systems install)
  #:use-module (guix channels)
  #:use-module (guix gexp)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu system)
  #:use-module (gnu system install)
  #:use-module (nongnu packages linux)
  #:use-module (saayix packages text-editors)
  #:use-module (saayix services system rfkill)
  #:export (installation-os-misako))

(define %nonguix-key
  (plain-file "nonguix.pub"
              "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(define %channels
  (list (channel
          (name 'guix)
          (url "https://git.savannah.gnu.org/git/guix.git")
          (branch "master")
          (introduction
            (make-channel-introduction
              "9edb3f66fd807b096b48283debdcddccfea34bad"
              (openpgp-fingerprint
                "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
        (channel
          (name 'saayix)
          (url "https://codeberg.org/look/saayix.git")
          (branch "entropy")
          (introduction
            (make-channel-introduction
              "12540f593092e9a177eb8a974a57bb4892327752"
              (openpgp-fingerprint
                "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB"))))
        (channel
          (name 'nonguix)
          (url "https://gitlab.com/look7/nonguix")
          (branch "nvidia")
          (introduction
            (make-channel-introduction
              "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
              (openpgp-fingerprint
                "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
        (channel
          (name 'radix)
          (url "https://codeberg.org/anemofilia/radix.git")
          (branch "main")
          (introduction
            (make-channel-introduction
              "f9130e11e35d2c147c6764ef85542dc58dc09c4f"
              (openpgp-fingerprint
                "F164 709E 5FC7 B32B AEC7  9F37 1F2E 76AC E3F5 31C8"))))
        (channel
          (name 'sops-guix)
          (url "https://git.sr.ht/~look/sops-guix")
          (branch "main")
          (introduction
            (make-channel-introduction
              "e6f0a2c93504eca47c018303ec66e0a3e82e4826"
              (openpgp-fingerprint
                "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB"))))
        (channel
          (name 'rosenthal)
          (url "https://codeberg.org/hako/rosenthal.git")
          (branch "trunk")
          (introduction
            (make-channel-introduction
              "7677db76330121a901604dfbad19077893865f35"
              (openpgp-fingerprint
                "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7"))))))

(define installation-os-misako
  (operating-system
    (inherit installation-os)
    (kernel linux)
    (firmware (list linux-firmware))
    (packages
      (cons* curl
             git
             helix
             (operating-system-packages installation-os)))
    (services
      (cons* (service rfkill-service-type)
             (modify-services (operating-system-user-services installation-os)
               (guix-service-type
                 config => (guix-configuration
                             (inherit config)
                             (guix (guix-for-channels %channels))
                             (authorize-key? #t)
                             (authorized-keys
                               (cons* %nonguix-key
                                      %default-authorized-guix-keys))
                             (substitute-urls
                               '("https://ci.guix.gnu.org"
                                 "https://substitutes.nonguix.org"
                                 "https://bordeaux.guix.gnu.org"))
                             (channels %channels)
                             (extra-options '("--max-jobs=6"
                                              "--cores=0")))))))))

installation-os-misako
