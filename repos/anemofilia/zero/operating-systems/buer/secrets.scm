(define-module (operating-systems buer secrets)
  #:use-module (gnu)
  #:export (%radio-password %root-password))

(define %radio-password
  (string-append "$6$abc$YPieZeEBpa7oUo62ytkieOKzTNso/iGRSeB.GvH"
                 "9A3qM78WRGWIiQlK9gImWrLJw0ll18pjVgDNNamGeUV44G/"))

(define %root-password
  (string-append "$6$adsfc$51FzeGnMnVnyYiVotX8siJKUPFj8Na4aQRI7Ri"
                 "LXfttd5CrX8Ut1M5iteLWlEtNNDMlmFIuKTEegoR5L9avOA1"))
