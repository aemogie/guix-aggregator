(define-module (misako operating-systems base users)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages shells)
  #:use-module (gnu system accounts)
  #:use-module (guix gexp)
  #:use-module (misako utils)
  #:export (look))

(define look
  (user-account
    (name "look")
    (password "9nQFJ2Nui/G5U")
    (shell (file-append fish "/bin/fish"))
    (uid 1000)
    (group "users")
    (supplementary-groups
      (glist "audio"
             "seat"
             "input"
             "video"
             "wheel"
             "kvm"
             (yumiko?* "tablet"
                       "usb")))))
