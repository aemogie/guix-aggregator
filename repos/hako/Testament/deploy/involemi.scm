(use-modules (gnu machine)
             (gnu machine ssh))

(define %os
  (load "../tangled/involemi/involemi.scm"))

(list
 (machine
   (operating-system %os)
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "involemi")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTFVQG6ZfybNjGzm4p8J3QvDkXsBmlCIo5N2u2hORMs")
      (system "x86_64-linux")
      (user "deploy")))))
