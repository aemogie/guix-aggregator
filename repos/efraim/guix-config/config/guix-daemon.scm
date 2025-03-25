(define-module (config guix-daemon)
  #:use-module (guix gexp)
  #:use-module (gnu services base)
  #:export (%guix-configuration
            %substitute-urls
            %authorized-keys
            %extra-options))

(define %substitute-urls
  (list "https://bordeaux.guix.gnu.org"
        "https://ci.guix.gnu.org"
        ;"https://4zwzi66wwdaalbhgnix55ea3ab4pvvw66ll2ow53kjub6se4q2bclcyd.onion"
        "https://cuirass.genenetwork.org"
        "http://guix.genenetwork.org"
        "https://guix.tobias.gr"))

(define %authorized-keys
  (list (local-file "../Extras/3900XT_publish.pub")
        (local-file "../Extras/E5400_publish.pub")
        (local-file "../Extras/pinebookpro_publish.pub")
        (local-file "../Extras/pine64_publish.pub")
        (local-file "../Extras/rock64-1.pub")
        (local-file "../Extras/X1.pub")
        (local-file "../Extras/rpi5b.pub")
        (local-file "../Extras/g4_publish.pub")
        (local-file "../Extras/unmatched_publish.pub")
        (local-file "../Extras/starfive-vision1.pub")
        (local-file "../Extras/starfive-vision2.pub")
        (local-file "../Extras/ci.guix.gnu.org.pub")
        (local-file "../Extras/bordeaux.guix.gnu.org.pub")
        (local-file "../Extras/cuirass.genenetwork.org.pub")
        (local-file "../Extras/guix.genenetwork.org.pub")
        (local-file "../Extras/guix.tobias.gr.pub")))

(define %extra-options
  (list "--gc-keep-derivations=yes"
        "--gc-keep-outputs=yes"))

(define %guix-configuration
  (guix-configuration
    (inherit guix-configuration)
    (substitute-urls %substitute-urls)
    (authorized-keys %authorized-keys)
    (extra-options %extra-options)))
