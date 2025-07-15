(define-module (home services emacs)
  ; #:use-module (daviwil packages emacs)
  #:use-module (guix gexp)
  #:use-module (guix transformations)

  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages rust-apps)

  #:use-module (gnu home services)

  #:use-module (gnu services)
  #:use-module (gnu services configuration) 

  #:export (home-emacs-config-service-type))

(define (home-emacs-config-profile-service config)
  (list
    ;; crafted completion packages
   emacs-cape
   emacs-consult
   emacs-corfu
   emacs-corfu-terminal
   emacs-embark
   emacs-embark-consult
   emacs-marginalia
   emacs-orderless
   emacs-vertico))

(define home-emacs-config-service-type
  (service-type (name 'home-emacs-config)
                (description "Applies my personal Emacs configuration.")
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        home-emacs-config-profile-service)))
                (default-value #f)))
