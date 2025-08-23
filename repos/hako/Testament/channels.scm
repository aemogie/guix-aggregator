;;; SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(cons* (channel
         (name 'guixcn)
         (url "https://codeberg.org/guixcn/guix-channel.git")
         (introduction
          (make-channel-introduction
           "993d200265630e9c408028a022f32f34acacdf29"
           (openpgp-fingerprint
            "7EBE A494 60CE 5E2C 0875  7FDB 3B5A A993 E1A2 DFF0"))))
       (channel
         (name 'nonguix)
         (url "https://gitlab.com/nonguix/nonguix")
         (introduction
          (make-channel-introduction
           "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
           (openpgp-fingerprint
            "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
       (channel
         (name 'rosenthal)
         (url "https://codeberg.org/hako/rosenthal.git")
         (branch "trunk")
         (introduction
          (make-channel-introduction
           "7677db76330121a901604dfbad19077893865f35"
           (openpgp-fingerprint
            "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7"))))
       (channel
         (name 'sops-guix)
         (url "https://github.com/fishinthecalculator/sops-guix")
         (branch "main")
         (introduction
          (make-channel-introduction
           "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
           (openpgp-fingerprint
            "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2"))))
       %default-channels)
