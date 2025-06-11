(define-module (misako channels)
  #:use-module (guix channels)
  #:export (guix
            saayix
            nonguix
            radix
            sops-guix
            rosenthal
            sakura
            guixpkgs))

(define guix
  (channel
    (name 'guix)
    (url "https://codeberg.org/guix/guix")
    (branch "master")
    (introduction
      (make-channel-introduction
        "9edb3f66fd807b096b48283debdcddccfea34bad"
        (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(define saayix
  (channel
    (name 'saayix)
    (url "https://codeberg.org/look/saayix.git")
    (branch "entropy")
    (introduction
      (make-channel-introduction
        "12540f593092e9a177eb8a974a57bb4892327752"
        (openpgp-fingerprint
          "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB")))))

(define nonguix
  (channel
    (name 'nonguix)
    (url "https://gitlab.com/look7/nonguix")
    (branch "nonguix-hacks")
    (introduction
      (make-channel-introduction
        "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
        (openpgp-fingerprint
          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

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

(define rosenthal
  (channel
    (name 'rosenthal)
    (url "https://codeberg.org/hako/rosenthal.git")
    (branch "trunk")
    (introduction
      (make-channel-introduction
        "7677db76330121a901604dfbad19077893865f35"
        (openpgp-fingerprint
          "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7")))))

(define sakura
  (channel
    (name 'sakura)
    (url "https://g.freya.cat/freya/sakura.git")
    (branch "main")
    (introduction
      (make-channel-introduction
        "8fb2f9c2fa414754c41c1c73665e3e73e12693ab"
        (openpgp-fingerprint
          "3CD3 65F0 373C EB13 853A  F568 9FBC 6FFD 6D2D BF17")))))

(define guixpkgs
  (channel
    (name 'guixpkgs)
    (url "http://forgejo.yuria:3000/guixpkgs/guixpkgs.git")
    (branch "main")
    (introduction
      (make-channel-introduction
        "5dd51367dd00d47058e0009fa2260e65edc6f01e"
        (openpgp-fingerprint
          "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB")))))
