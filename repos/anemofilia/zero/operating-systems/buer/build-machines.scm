(define-module (operating-systems buer build-machines)
  #:use-module ((operating-systems buer ssh-keys) #:prefix ssh-key:)
  #:use-module (guix gexp)

  #:export (yumiko))

(define yumiko
  #~(build-machine
      (name "yumiko")
      (systems (list "x86_64-linux"))
      (host-key #$(plain-file-content ssh-key:yumiko.pub))
      (private-key "/root/.ssh/id_ed25519")
      (user "radio")
      (port 2222)))
