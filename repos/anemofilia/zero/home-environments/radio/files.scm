(define-module (home-environments radio files)
  #:use-module (sops secrets)
  #:use-module (guix gexp)
  #:export (common.yaml sops.yaml))

(define files.scm
  (search-path %load-path (module-filename (current-module))))

(define secrets-dir
  (string-append (dirname files.scm) "/secrets"))

(define common.yaml
  (local-file (string-append secrets-dir "/common.yaml")))

(define sops.yaml
  (local-file (string-append secrets-dir "/.sops.yaml")
              "sops.yaml"))
