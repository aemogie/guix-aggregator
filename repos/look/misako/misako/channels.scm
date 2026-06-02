(define-module (misako channels)
  #:use-module (guix channels)
  #:export (%misako-channels))

(define-public guix
  (channel
    (name 'guix)
    (url "https://codeberg.org/guix/guix")
    (branch "master")
    (commit "f4ee072046cdb76d7eafd00b1ac08ee9362f737c")
    (introduction
      (make-channel-introduction
        "9edb3f66fd807b096b48283debdcddccfea34bad"
        (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(define-public saayix
  (channel
    (name 'saayix)
    (url "https://codeberg.org/look/saayix.git")
    (branch "entropy")
    (commit "080e99c47c8b7d8a1ec5dd0ac51d16c6a9c17b51")
    (introduction
      (make-channel-introduction
        "12540f593092e9a177eb8a974a57bb4892327752"
        (openpgp-fingerprint
          "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB")))))

(define-public saayix-nonfree
  (channel
    (name 'saayix-nonfree)
    (branch "main")
    (url "https://codeberg.org/look/saayix-nonfree")
    (commit "81bb663512cd3f162dc2143ca0823a92c32b362c")
    (introduction
      (make-channel-introduction
        "8a0caf3d1dbcd0c9257a23f8b251b5d5ff153c97"
        (openpgp-fingerprint
          "8B37 296F CE5C 4910 4737  3BAA 3BF5 14F5 84DC 25AD")))))

(define-public nonguix
  (channel
    (name 'nonguix)
    (url "https://gitlab.com/nonguix/nonguix")
    (branch "master")
    (commit "3ed7c207c59dde11a97db483cad4c96eae1a10c4")
    (introduction
      (make-channel-introduction
        "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
        (openpgp-fingerprint
          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define-public radix
  (channel
    (name 'radix)
    (url "https://codeberg.org/anemofilia/radix.git")
    (branch "main")
    (commit "02aa96f0c3075a8b8fb168ecc9249067edb14ac9")
    (introduction
      (make-channel-introduction
        "f9130e11e35d2c147c6764ef85542dc58dc09c4f"
        (openpgp-fingerprint
          "F164 709E 5FC7 B32B AEC7  9F37 1F2E 76AC E3F5 31C8")))))

(define-public sops-guix
  (channel
    (name 'sops-guix)
    (url "https://github.com/fishinthecalculator/sops-guix")
    (branch "main")
    (commit "c53e27e533836ea8595626ba6796dee5362f8c4a")
    (introduction
      (make-channel-introduction
        "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
        (openpgp-fingerprint
          "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2")))))

(define-public %misako-channels
  (list guix
        nonguix
        saayix
        saayix-nonfree
        radix
        sops-guix))

%misako-channels
