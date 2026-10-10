(use-modules (gnu machine)
             (gnu machine ssh))

(define %os
  (load "../tangled/chapra/chapra.scm"))

(list
 (machine
   (operating-system %os)
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "chapra")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABRu2ARsDnuGIrO/UGwgECgpxPo7RCoM22PAH3tr82h")
      (system "x86_64-linux")
      (user "deploy")
      (allow-downgrades? #t)))))
