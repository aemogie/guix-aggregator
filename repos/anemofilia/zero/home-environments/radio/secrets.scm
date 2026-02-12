(define-module (home-environments radio secrets)
  #:use-module (home-environments radio)
  #:use-module ((home-environments radio files) #:prefix file:)
  #:use-module (sops secrets)
  #:use-module (guix gexp)
  #:export (aerc senpai secrets-dir))

(define (common-sops-secrets . keys)
  (map (lambda (key)
         (sops-secret
           (key (map symbol->string key))
           (file file:common.yaml)
           (permissions #o400)))
       keys))

(define aerc
  (common-sops-secrets
    '(aerc disroot lgcoelho user)
    '(aerc disroot lgcoelho password)
    '(aerc disroot anemofilia user)
    '(aerc disroot anemofilia password)))

(define senpai
  (common-sops-secrets
    '(senpai sourcehut password)))
