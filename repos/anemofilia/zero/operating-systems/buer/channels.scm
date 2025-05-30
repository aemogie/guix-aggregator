(define-module (operating-systems buer channels)
  #:use-module (guix channels)
  #:use-module (gnu packages package-management)

  #:export (guix radix shepherd))

(define guix
  (channel
    (name 'guix)
    (url "https://git.guix.gnu.org/guix.git")
    (branch "master")
    (introduction
      (make-channel-introduction
        "9edb3f66fd807b096b48283debdcddccfea34bad"
        (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(define radix
  (channel
    (name 'radix)
    (url "https://codeberg.org/anemofilia/radix.git")
    (branch "main")
    (introduction
      (make-channel-introduction
        "f9130e11e35d2c147c6764ef85542dc58dc09c4f"
        (openpgp-fingerprint
          "F164 709E 5FC7 B32B AEC7  9F37 1F2E 76AC E3F5 31C8")))))

(define shepherd
   (channel
     (name 'shepherd)
     (url "https://git.savannah.gnu.org/git/shepherd.git")
     (branch "main")
     (introduction
      (make-channel-introduction
       "788a6d6f1d5c170db68aa4bbfb77024fdc468ed3"
       (openpgp-fingerprint
        "3CE464558A84FDC69DB40CFB090B11993D9AEBB5")))))
