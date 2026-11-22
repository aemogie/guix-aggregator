;; DO NOT MODIFY!
;; instead, make your changes to channels.scm, then run `make update-lockfile`

(list (channel
       (name 'nonguix)
       (url "https://gitlab.com/nonguix/nonguix")
       (branch "master")
       (commit "57b156aa003e2b6eacf979cac377e4b585bf3a19")
       (introduction
        (make-channel-introduction
         "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
         (openpgp-fingerprint
          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
      (channel
       (name 'guix-science)
       (url "https://codeberg.org/guix-science/guix-science.git")
       (branch "master")
       (commit "a3d17a7021738bfb6ff150b1c2c30506ecbe7deb")
       (introduction
        (make-channel-introduction
         "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
         (openpgp-fingerprint
          "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
      (channel
       (name 'guix)
       (url "https://git.guix.gnu.org/guix.git")
       (branch "master")
       (commit "34948c0650b689423e2e42730c4f93ca944aef29")
       (introduction
        (make-channel-introduction
         "9edb3f66fd807b096b48283debdcddccfea34bad"
         (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))
