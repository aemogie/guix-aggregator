(define-module (yggdrasil system services dns)
  #:use-module (ice-9 match)

  #:use-module (guix gexp)
  #:use-module (guix packages)

  #:use-module (gnu system shadow)

  #:use-module (gnu packages dns)
  #:use-module (gnu packages admin)

  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services configuration)

  #:export (knot-resolver-configuration
            knot-resolver-service-type))

(define %kresd.conf
  (plain-file "kresd.conf" "-- -*- mode: lua -*-
trust_anchors.add_file('/var/cache/knot-resolver/root.keys')
net = { '127.0.0.1', '::1' }
user('knot-resolver', 'knot-resolver')
modules = { 'hints > iterate', 'stats', 'predict' }
cache.size = 100 * MB
"))

(define-configuration/no-serialization knot-resolver-configuration
  (package (package knot-resolver) "")
  (config (file-like %kresd.conf) "")
  (garbage-collection-interval (integer 1000) ""))

(define %knot-resolver-accounts
  (list (user-group
         (name "knot-resolver")
         (system? #t))
        (user-account
         (name "knot-resolver")
         (group "knot-resolver")
         (system? #t)
         (home-directory "/var/cache/knot-resolver")
         (shell (file-append shadow "/sbin/nologin")))))

(define (knot-resolver-activation config)
  #~(begin
      (use-modules (guix build utils))
      (let ((rundir "/var/cache/knot-resolver")
            (owner (getpwnam "knot-resolver")))
        (mkdir-p rundir)
        (chown rundir (passwd:uid owner) (passwd:gid owner)))))

(define knot-resolver-shepherd-services
  (match-lambda
    (($ <knot-resolver-configuration> _ package config gc-interval)
     (list
      (shepherd-service
       (provision '(kresd))
       (requirement '(networking))
       (documentation "Run the Knot Resolver daemon.")
       (start #~(make-forkexec-constructor
                 (list (string-append #$package "/sbin/kresd")
                       (string-append "--config=" #$config)
                       "--verbose"
                       "--noninteractive")
                 #:log-file "/var/log/kresd.log"
                 #:directory "/var/cache/knot-resolver"))
       (stop #~(make-kill-destructor)))
      (shepherd-service
       (provision '(kres-cache-gc))
       (requirement '(user-processes))
       (documentation "Run the Knot Resolver Garbage Collector daemon.")
       (start #~(make-forkexec-constructor
                 (list (string-append #$package "/sbin/kres-cache-gc")
                       "-c" "/var/cache/knot-resolver"
                       "-d" #$(number->string gc-interval))
                 #:log-file "/var/log/kresgc.log"
                 #:user "knot-resolver"
                 #:group "knot-resolver"))
       (stop #~(make-kill-destructor)))))))

(define knot-resolver-service-type
  (service-type
   (name 'knot-resolver)
   (extensions
    (list (service-extension
           shepherd-root-service-type
           knot-resolver-shepherd-services)
          (service-extension
           activation-service-type
           knot-resolver-activation)
          (service-extension
           account-service-type
           (const %knot-resolver-accounts))))
   (default-value (knot-resolver-configuration))
   (description "Run the Knot DNS Resolver.")))
