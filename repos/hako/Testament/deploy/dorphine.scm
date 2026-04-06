(use-modules (common)
             (gnu machine)
             (gnu machine ssh))

(define %os
  (load (in-vicinity testament-path "tangled/dorphine/dorphine.scm")))

(list
 (machine
   (operating-system %os)
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "dorphine")
      (system "x86_64-linux")
      (user "deploy")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsyytSPRGw89e4YrWeLemUs16dgFB1vTnNLPwupqN+B")))))
