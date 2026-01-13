(define-module (home-environments radio channels)
  #:use-module (guix channels)
  #:use-module (gnu packages package-management)

  #:export (guix radix saayix nonguix sops-guix shepherd))

(define guix
  (channel
    (name 'guix)
    (url "https://git.guix.gnu.org/guix")
    (branch "master")
    (introduction
      (make-channel-introduction
        "9edb3f66fd807b096b48283debdcddccfea34bad"
        (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(define radix
  (channel
    (name 'radix)
    (url "https://codeberg.org/anemofilia/radix")
    (branch "main")
    (introduction
      (make-channel-introduction
        "f9130e11e35d2c147c6764ef85542dc58dc09c4f"
        (openpgp-fingerprint
          "F164 709E 5FC7 B32B AEC7  9F37 1F2E 76AC E3F5 31C8")))))

(define saayix
  (channel
    (name 'saayix)
    (url "https://codeberg.org/look/saayix")
    (branch "entropy")
    (introduction
      (make-channel-introduction
        "12540f593092e9a177eb8a974a57bb4892327752"
        (openpgp-fingerprint
          "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB")))))

(define sops-guix
  (channel
    (name 'sops-guix)
    (url "https://github.com/fishinthecalculator/sops-guix")
    (branch "main")
    (introduction
      (make-channel-introduction
        "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
        (openpgp-fingerprint
          "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2")))))

(define shepherd
   (channel
     (name 'shepherd)
     (url "https://git.savannah.gnu.org/git/shepherd")
     (branch "main")
     (introduction
      (make-channel-introduction
       "788a6d6f1d5c170db68aa4bbfb77024fdc468ed3"
       (openpgp-fingerprint
        "3CE464558A84FDC69DB40CFB090B11993D9AEBB5")))))

(define nonguix
  (channel
   (name 'nonguix)
   (url "https://gitlab.com/nonguix/nonguix")
   (branch "master")
   (introduction
    (make-channel-introduction
     "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
     (openpgp-fingerprint
      "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
