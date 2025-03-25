(define-module (kids_manifest))
(use-modules (guix profiles)
             (gnu packages))

(packages->manifest
 (map (compose list specification->package+output)
      (list
        "font-dejavu"
        "font-terminus"
        "gcompris-qt"
        "glibc-locales"
        "gnujump"
        "icecat"
        "kodi"
        "ktouch"
        "quadrapassel"
        "supertux"
        "supertuxkart"
        "tuxmath")))
