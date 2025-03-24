(define-module (misako operating-systems yumiko cuirass)
  #:use-module (guix gexp)
  #:use-module ((misako channels) #:prefix channel:)
  #:export (%cuirass-specs))

(define %cuirass-specs
  #~(list
      (specification
        (name "saayix")
        (build '(channels saayix))
        (priority 0)
        (period 0)
        (channels
          (list (channel
                  (name 'saayix)
                  (url "https://codeberg.org/look/saayix.git")
                  (branch "entropy")
                  (introduction
                    (make-channel-introduction
                      "12540f593092e9a177eb8a974a57bb4892327752"
                      (openpgp-fingerprint
                        "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB"))))
                (channel
                  (name 'guix)
                  (url "https://git.savannah.gnu.org/git/guix.git")
                  (branch "master")
                  (introduction
                    (make-channel-introduction
                      "9edb3f66fd807b096b48283debdcddccfea34bad"
                      (openpgp-fingerprint
                        "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))))))
