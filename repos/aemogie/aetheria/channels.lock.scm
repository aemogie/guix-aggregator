;; DO NOT MODIFY!
;; instead, make your changes to channels.scm, then run `make update-lockfile`
(use-modules
  ((guix channels)
   #:select
   (channel
     make-channel-introduction
     openpgp-fingerprint
     %default-guix-channel)))

(list (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (branch "master")
        (commit
          "c075e3ae214ca6e773c69142ede754e7cf4ae799")
        (introduction
          (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
              "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
      (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (branch "master")
        (commit
          "8166de494751dc2f3e1a44a59e4aedca9af7e624")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))
