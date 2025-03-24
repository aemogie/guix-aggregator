(define-module (misako substitute-keys)
  #:use-module (guix gexp)
  #:export (guix.pub
            bordeaux.pub
            nonguix.pub
            inria.pub
            buer.pub
            yumiko.pub
            yuria.pub
            genenetwork.pub
            boiledscript.pub))

(define guix.pub
  (plain-file "guix.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #8D156F295D24B0D9A86FA5741A840FF2D24F60F7B6C4134814AD55625971B394#)))"))

(define bordeaux.pub
  (plain-file "bordeaux.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #7D602902D3A2DBB83F8A0FB98602A754C5493B0B778C8D1DD4E0F41DE14DE34F#)))"))

(define nonguix.pub
  (plain-file "nonguix.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(define inria.pub
  (plain-file "inria.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #89FBA276A976A8DE2A69774771A92C8C879E0F24614AAAAE23119608707B3F06#)))"))

(define buer.pub
  (plain-file "buer.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #E2E2E6DB03AC62403691C5BDF285BB79D660957801184905870F3CF5EE940B52#)))"))

(define yumiko.pub
  (plain-file "yumiko.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #EBD4DD318A84F9F0AD13300D8A2ACF022F16088DA59B57E539F6DC3BD9C33A52#)))"))

(define yuria.pub
  (plain-file "yuria.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #D5D0C1203D294B410DA106DDC1713B74CBB27353D53F4EE3D9D26972E8687424#)))"))

(define genenetwork.pub
  (plain-file "genenetwork.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #9578AD6CDB23BA51F9C4185D5D5A32A7EEB47ACDD55F1CCB8CEE4E0570FBF961#)))"))

(define boiledscript.pub
  (plain-file "boiledscript.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))"))
