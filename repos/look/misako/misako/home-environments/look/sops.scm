(define-module (misako home-environments look sops)
  #:use-module (sops secrets)
  #:use-module (guix gexp)
  #:use-module (misako utils)
  #:export (aerc
            aerc-keys
            senpai
            senpai-keys
            shadow
            shadow-keys))

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

(define shadow-keys
  (list '("ssh" "shadow-primary" "name")
        '("ssh" "shadow-primary" "host-name")
        '("ssh" "shadow-primary" "port")
        '("ssh" "shadow-primary" "user")
        '("ssh" "shadow-secondary" "name")
        '("ssh" "shadow-secondary" "host-name")
        '("ssh" "shadow-secondary" "port")
        '("ssh" "shadow-secondary" "user")))

(define aerc (look-sops-secret aerc-keys))
(define senpai (look-sops-secret senpai-keys))
(define shadow (look-sops-secret shadow-keys))
