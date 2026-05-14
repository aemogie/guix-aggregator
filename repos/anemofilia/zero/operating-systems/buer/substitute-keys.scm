(define-module (operating-systems buer substitute-keys)
  #:use-module (gnu)
  #:export (berlin.pub
            genenetwork.pub
            inria.pub
            moe.pub
            yumiko.pub
            yuria.pub))

(define berlin.pub
  (plain-file "berlin.pub"
    "(public-key
      (ecc
       (curve Ed25519)
       (q #8D156F295D24B0D9A86FA5741A840FF2D24F60F7B6C4134814AD55625971B394#)
      )
     )"))

(define genenetwork.pub
  (plain-file "genenetwork.pub"
    "(public-key
      (ecc
       (curve Ed25519)
       (q #9578AD6CDB23BA51F9C4185D5D5A32A7EEB47ACDD55F1CCB8CEE4E0570FBF961#)
      )
     )"))

(define inria.pub
  (plain-file "inria.pub"
    "(public-key
      (ecc
       (curve Ed25519)
       (q #89FBA276A976A8DE2A69774771A92C8C879E0F24614AAAAE23119608707B3F06#)
      )
     )"))

(define moe.pub
  (plain-file "moe.pub"
    "(public-key
      (ecc
       (curve Ed25519)
       (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)
      )
     )"))

(define yumiko.pub
  (plain-file "yumiko.pub"
    "(public-key
      (ecc
       (curve Ed25519)
       (q #EBD4DD318A84F9F0AD13300D8A2ACF022F16088DA59B57E539F6DC3BD9C33A52#)
      )
     )"))

(define yuria.pub
  (plain-file "yuria.pub"
    "(public-key
      (ecc
       (curve Ed25519)
       (q #D5D0C1203D294B410DA106DDC1713B74CBB27353D53F4EE3D9D26972E8687424#)
      )
     )"))
