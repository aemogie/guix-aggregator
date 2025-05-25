(define-module (misako home-environments look sops)
  #:use-module (sops secrets)
  #:use-module (guix gexp)
  #:use-module (misako utils)
  #:export (aerc
            aerc-keys
            senpai
            senpai-keys))

(define (look-sops-secret keys)
  (map (lambda (key)
         (sops-secret
           (key key)
           (file (local-file (string-append look-sops-dir "/look.yaml")))
           (permissions #o400)))
       keys))

(define aerc-keys
  (list '("aerc" "primary"   "name")
        '("aerc" "primary"   "user")
        '("aerc" "primary"   "url")
        '("aerc" "primary"   "email")
        '("aerc" "primary"   "password")
        '("aerc" "secondary" "name")
        '("aerc" "secondary" "user")
        '("aerc" "secondary" "url")
        '("aerc" "secondary" "email")
        '("aerc" "secondary" "password")))

(define senpai-keys
  (list '("senpai" "sourcehut" "password")))

(define aerc (look-sops-secret aerc-keys))
(define senpai (look-sops-secret senpai-keys))
