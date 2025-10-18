(cons* (channel
         (name 'mrh)
         (url "https://codeberg.org/mrh/guix-channel.git")
         (branch "trunk")
         (introduction
          (make-channel-introduction
           "2a79d9f12341857c8071e0cfc45489d7587ee596"
           (openpgp-fingerprint
            "1F5C 5723 E950 62A7 085E  0757 6C7C 794F 4A82 8B59"))))
       (channel
         (name 'nonguix)
         (url "https://gitlab.com/nonguix/nonguix")
         (branch "master")
         (introduction
          (make-channel-introduction
           "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
           (openpgp-fingerprint
            "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
       %default-channels)
