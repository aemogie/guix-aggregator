(use-modules (gnu machine)
             (gnu machine ssh))

(list
 (machine
   (operating-system (load "../tangled/chapra/chapra.scm"))
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "chapra")
      (system "x86_64-linux")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABRu2ARsDnuGIrO/UGwgECgpxPo7RCoM22PAH3tr82h")))))
