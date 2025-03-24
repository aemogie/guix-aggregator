;;; Channels

(cons*
 ;; Divya-Lambda
 (channel
  (name 'divya-lambda)
  (url "https://codeberg.org/divyaranjan/divya-lambda.git")
  (branch "master")
  (introduction
   (make-channel-introduction
    "fe2010125fcbe003de42436b1a73ab53cc5e8288"
    (openpgp-fingerprint
     "F0B3 1A69 8006 8FB8 096A  2F12 B245 10C6 108C 8D4A"))))

 ;; Guix Science
 (channel
  (name 'guix-science)
  (url "https://codeberg.org/guix-science/guix-science.git")
  (introduction
   (make-channel-introduction
    "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
    (openpgp-fingerprint
     "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))

 ;; Nonguix
 (channel
  (name 'nonguix)
  (url "https://gitlab.com/nonguix/nonguix")
  ;; Enable signature verification:
  (introduction
   (make-channel-introduction
    "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
    (openpgp-fingerprint
     "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))

 ;; Sergio’s Channel
 (channel
  (name 'omega)
  (branch "main")
  (url "https://codeberg.org/pastor/omega")
  (introduction
   (make-channel-introduction
    "042885d79802985c004135b2717296cb925cb9fb"
    (openpgp-fingerprint
     "A7FA 7CD2 683C B26D 6E6C  6C08 3B2E 9703 D480 1F04"))))
 %default-channels)
