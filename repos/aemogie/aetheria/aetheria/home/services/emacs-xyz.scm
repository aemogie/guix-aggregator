(define-module (aetheria home services emacs-xyz)
  #:use-module ((srfi srfi-1) #:select (concatenate))
  #:use-module ((gnu services) #:select (service-type
                                          service-extension))
  #:use-module ((gnu packages emacs-xyz) #:select (emacs-vertico
                                                   emacs-marginalia
                                                   emacs-orderless))
  #:use-module ((aetheria home services emacs) #:select (home-emacs-service-type
                                                         home-emacs-configuration))
  #:export (aetheria-home-emacs-ui-service-type))

(define aetheria-home-emacs-ui-service-type
  (service-type
    (name 'aetheria-home-emacs-vertico)
    (description "aetheria emcas vertico configuration")
    (extensions (list (service-extension home-emacs-service-type identity)))
    (compose concatenate)
    (extend cons)
    (default-value
      (home-emacs-configuration
       (extra-packages (list emacs-vertico emacs-marginalia emacs-orderless))
       (extra-code "(vertico-mode 1) (marginalia-mode 1)")))))
