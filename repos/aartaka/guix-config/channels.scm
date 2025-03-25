(cons*
 (channel
  (name 'guile-gsl)
  (url "https://github.com/aartaka/guile-gsl.git")
  (branch "master"))
 (channel
  (name 'guile-lmdb)
  (url "https://github.com/aartaka/guile-lmdb.git")
  (branch "master"))
 (channel
  (name 'guile-lapack)
  (url "https://github.com/aartaka/guile-lapack.git")
  (branch "master"))
 (channel
  (name 'mgamma)
  (url "https://github.com/aartaka/mgamma.git")
  (branch "master"))
 (channel
  (name 'nonguix)
  (url "https://gitlab.com/nonguix/nonguix")
  ;; Enable signature verification:
  (introduction
   (make-channel-introduction
    "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
    (openpgp-fingerprint
     "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
 (channel
  (name 'guix-gaming-games)
  (url "https://gitlab.com/guix-gaming-channels/games.git")
  ;; Enable signature verification:
  (introduction
   (make-channel-introduction
    "c23d64f1b8cc086659f8781b27ab6c7314c5cca5"
    (openpgp-fingerprint
     "50F3 3E2E 5B0C 3D90 0424  ABE8 9BDC F497 A4BB CC7F"))))
 %default-channels)
