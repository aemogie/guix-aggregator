(define-module (misako build-machines)
  #:use-module ((misako ssh-keys) #:prefix ssh-key:)
  #:use-module (guix gexp)
  #:export (yumiko))

(define yumiko
  #~(build-machine
      (name "yumiko.local")
      (systems (list "x86_64-linux"))
      (host-key (ungexp ssh-key:yumiko.pub))
      (private-key "/etc/ssh/look")
      (user "look")
      (port 2222)
      (parallel-builds 1)
      (speed 1.)))
