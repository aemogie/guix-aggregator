(define-module (misako operating-systems base privileged)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu system privilege)
  #:use-module (saayix packages binaries)
  #:use-module (guix gexp)
  #:export (authentication
            file-systems
            network))

(define authentication
  (list (privileged-program
          (program (file-append shadow "/bin/passwd"))
          (setuid? #t))
        (privileged-program
          (program (file-append shadow "/bin/chfn"))
          (setuid? #t))
        (privileged-program
          (program (file-append shadow "/bin/sg"))
          (setuid? #t))
        (privileged-program
          (program (file-append shadow "/bin/su"))
          (setuid? #t))
        (privileged-program
          (program (file-append shadow "/bin/newgrp"))
          (setuid? #t))
        (privileged-program
          (program (file-append shadow "/bin/newuidmap"))
          (setuid? #t))
        (privileged-program
          (program (file-append shadow "/bin/newgidmap"))
          (setuid? #t))))

(define file-systems
  (list (privileged-program
          (program (file-append fuse "/bin/fusermount3"))
          (setuid? #t))
        (privileged-program
          (program (file-append fuse-2 "/bin/fusermount"))
          (setuid? #t))
        (privileged-program
          (program (file-append util-linux "/bin/mount"))
          (setuid? #t))
        (privileged-program
          (program (file-append util-linux "/bin/umount"))
          (setuid? #t))))

(define network
  (list (privileged-program
          (program (file-append inetutils "/bin/ping"))
          (capabilities "cap_net_raw=ep"))
        (privileged-program
          (program (file-append espanso-wayland "/bin/espanso"))
          (capabilities "cap_dac_override+p"))
        (privileged-program
          (program (file-append inetutils "/bin/ping6"))
          (capabilities "cap_net_raw=ep"))))
