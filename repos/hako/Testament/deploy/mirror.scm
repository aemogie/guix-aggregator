(use-modules (gnu machine)
             (gnu machine ssh))

(define %os
  (load "../tangled/mirror/mirror.scm"))

(define* (mirror #:key mirror-name host-name system ssh-host-key (bios-boot #f))
  (machine
    (operating-system (%os mirror-name bios-boot))
    (environment managed-host-environment-type)
    (configuration
     (machine-ssh-configuration
       (host-name
        (or host-name
            (string-append mirror-name ".guix.moe")))
       (host-key ssh-host-key)
       (system system)
       (user "deploy")))))

(list (mirror
       #:mirror-name "cache-sg"
       #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7LUCU7btbuvWNMvS3WnM6lAZLB8AwH/O9LdYhae9Eo"
       #:system "x86_64-linux"
       #:bios-boot "/dev/vda")
      (mirror
       #:mirror-name "cache-us-lax"
       #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIymKc9HG2Gr+4r2mG3zVdRsCewZ9WuVrOJZipbMWHrl"
       #:system "x86_64-linux"
       #:bios-boot "/dev/vda"))
