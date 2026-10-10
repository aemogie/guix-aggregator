(use-modules (gnu machine)
             (gnu machine ssh))

(define %os
  (load "../tangled/dorphine/dorphine.scm"))

(list
 (machine
   (operating-system %os)
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "dorphine")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsyytSPRGw89e4YrWeLemUs16dgFB1vTnNLPwupqN+B")
      (system "x86_64-linux")
      (user "deploy")
      (allow-downgrades? #t)))))
