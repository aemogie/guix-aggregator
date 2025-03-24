(define-module (misako operating-systems yuria file-systems)
  #:use-module (gnu system file-systems)
  #:export (%ext4-file-systems))

(define guix-root-part
  (file-system-label "guix-root"))

(define guix-home-part
  (file-system-label "guix-home"))

(define guix-boot-part
  (file-system-label "guix-boot"))

(define root
  (file-system
    (device guix-root-part)
    (mount-point "/")
    (type "ext4")))

(define home
  (file-system
    (device guix-home-part)
    (mount-point "/home")
    (type "ext4")))

(define boot
  (file-system
    (device guix-boot-part)
    (mount-point "/boot/efi")
    (type "vfat")))

(define tmp
  (file-system
    (device "none")
    (mount-point "/tmp")
    (type "tmpfs")
    (check? #f)))

(define run
  (file-system
    (device "none")
    (mount-point "/run")
    (type "tmpfs")
    (options "mode=0755")
    (needed-for-boot? #t)
    (check? #f)))

(define var-run
  (file-system
    (device "none")
    (mount-point "/var/run")
    (type "tmpfs")
    (options "mode=0755")
    (needed-for-boot? #t)
    (check? #f)))

(define %ext4-file-systems
  (cons* root
         home
         boot
         tmp
         run
         var-run
         (delete %debug-file-system
                 %base-file-systems)))
