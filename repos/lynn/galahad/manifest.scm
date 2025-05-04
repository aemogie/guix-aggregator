(use-modules (guix)
             (guix packages)
             (gnu packages guile))

(packages->manifest (list guile-next))
