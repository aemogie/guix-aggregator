(define-module (misako home-environments look sops)
  #:use-module (sops secrets)
  #:use-module (guix gexp)
  #:use-module (misako utils)
  #:export (aerc
            aerc-keys
            senpai
            senpai-keys))

(define common
  (string-append secrets-dir "/common.yaml"))

(define (common-sops-secret keys)
  (map (lambda (key)
         (sops-secret
           (key key)
           (file (local-file common))
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

(define aerc (common-sops-secret aerc-keys))
(define senpai (common-sops-secret senpai-keys))
