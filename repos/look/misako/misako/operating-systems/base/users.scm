(define-module (misako operating-systems base users)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages shells)
  #:use-module (gnu system accounts)
  #:use-module (guix gexp)
  #:use-module (misako utils)
  #:export (look
            root))

(define look
  (user-account
    (name "look")
    (password "$6$abcds$VKYeQ3Zd5x6WO45Jniq1nOr5eWOBOoaup19xIjQtXBZujNoyUwnPBla6pUwD0aqw1lHUGGVJsBU19IjoYjy7D.")
    (home-directory "/home/look")
    (shell (file-append fish "/bin/fish"))
    (uid 1000)
    (group "users")
    (supplementary-groups
      (list* "audio"
             "seat"
             "input"
             "video"
             "wheel"
             "kvm"
             (yumiko?* "tablet"
                       "usb")))))

(define root
  (user-account
    (name "root")
    (password "$6$abcdk$EUmJC3KLnuXaW3vOHZcec4ogcPG.NqpV/AXHz.h.5Ul5ruLCZ91E696Q0rRzQnBaT.srJXXyp2zH5fqR.IG0F.")
    (home-directory "/root")
    (shell (file-append bash "/bin/bash"))
    (uid 0)
    (group "root")))
