(use-modules
 ((guix profiles) #:select (packages->manifest))
 ((gnu packages base) #:select (gnu-make)))

(packages->manifest (list gnu-make))
