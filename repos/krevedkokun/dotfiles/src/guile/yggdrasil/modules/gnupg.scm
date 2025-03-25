(define-module (yggdrasil modules gnupg)
  #:use-module (gnu home services)
  #:use-module ((gnu home-services gnupg)
                #:select (home-gnupg-service-type
                          home-gnupg-configuration
                          home-gpg-agent-configuration
                          home-gpg-configuration))
  #:use-module ((gnu home-services version-control)
                #:select (home-git-service-type
                          home-git-extension))
  #:use-module ((gnu packages gnupg) #:select (gnupg))
  #:use-module ((gnu packages security-token)
                #:select (libfido2 python-yubikey-manager))
  #:use-module (gnu services)
  #:use-module ((gnu services base) #:select (udev-rules-service))
  #:use-module ((gnu services security-token) #:select (pcscd-service-type))
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((rde home services shells)
                #:select (home-bash-service-type
                          home-bash-extension)))

(define (home-services)
  (list
   (simple-service 'gnupg-packages
     home-profile-service-type
     (list python-yubikey-manager
           (@ (gnu packages qt) qtwayland-5)))
   (service
    home-gnupg-service-type
    (home-gnupg-configuration
     (gpg-agent-config
      (home-gpg-agent-configuration
       (ssh-agent? #t)
       (pinentry-flavor 'qt)
       (ssh-keys '(("B0922A971719E1CB253E38DC4357F5C6084DBA3C")))))
     (gpg-config
      (home-gpg-configuration
       (extra-config
        '((cert-digest-algo . SHA512)
          (default-preference-list
            SHA512 SHA384 SHA256 AES256
            AES192 AES ZLIB BZIP2 ZIP Uncompressed)
          (personal-cipher-preferences AES256 AES192 AES)
          (personal-digest-preferences SHA512 SHA384 SHA256)
          (personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed)
          (keyserver . "keys.openpgp.org")
          (keyid-format . long)
          (with-subkey-fingerprint . #t)
          (with-keygrip . #t)))))))

   (simple-service 'gnupg-updatestartuptty
     home-bash-service-type
     (home-bash-extension
      (bash-profile
       (list
        #~(format #f "~a updatestartuptty /bye > /dev/null"
                  #$(file-append gnupg "/bin/gpg-connect-agent"))))))

   (simple-service 'git-gpg-config
     home-git-service-type
     (home-git-extension
      (config
       `((gpg
          ((program . ,(file-append gnupg "/bin/gpg"))))
         (commit
          ((gpgsign . #t)))
         (tag
          ((gpgsign . #t)))))))))

(define (system-services)
  (list
   (service pcscd-service-type)
   (udev-rules-service 'fido2-udev libfido2 #:groups '("plugdev"))))
