;; my additions to (gnu packages admin)
(define-module (aetheria packages admin)
  #:use-module ((guix packages) #:select (this-package-native-input
                                          package))
  #:export (shepherd-with-propagated-fibers))

(define (shepherd-with-propagated-fibers shepherd)
  (package
    (inherit shepherd)
    (propagated-inputs (list (this-package-native-input "guile-fibers")))))
