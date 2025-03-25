(define-module (yggdrasil system services networking)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)

  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)

  #:use-module (guix gexp)
  #:use-module (guix store)
  #:use-module (guix monads)
  #:use-module (guix records)
  #:use-module (guix packages)
  #:use-module (guix import utils)

  #:use-module (gnu packages dns)
  #:use-module (gnu packages base)
  #:use-module (gnu packages connman)
  #:use-module (gnu packages networking)

  #:use-module (gnu services)
  #:use-module (gnu services dbus)
  #:use-module (gnu services base)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services configuration)

  #:use-module ((gnu home-services-utils)
                #:select (ini-config?
                          maybe-object->string
                          generic-serialize-ini-config))
  #:export (iwd-service-type
            iwd-configuration
            connman-service-type
            connman-configuration))

(define (serialize-ini-config config)
  (define (serialize-val val)
    (cond
     ((boolean? val) (if val "true" "false"))
     ((list? val) (string-join (map serialize-val val) ","))
     ((or (number? val) (symbol? val)) (maybe-object->string val))
     (else val)))

  (define (serialize-field key val)
    (let ((val (serialize-val val))
          (key (symbol->string key)))
      (list key " = " val "\n")))

  (generic-serialize-ini-config
   #:combine-ini (compose flatten interpose)
   #:combine-alist list
   #:combine-section-alist cons
   #:serialize-field serialize-field
   #:fields config))

(define-configuration/no-serialization iwd-configuration
  (package (package iwd) "")
  (config (ini-config '()) ""))

(define (iwd-shepherd-service cfg)
  (match-record cfg <iwd-configuration>
    (package)
    (let ((environment #~(list (string-append
                                "PATH="
                                (string-append #$openresolv "/sbin")
                                ":"
                                (string-append #$coreutils "/bin")))))
      (list
       (shepherd-service
        (documentation "Run iwd")
        (provision '(iwd))
        (requirement '(user-processes dbus-system loopback))
        (start #~(make-forkexec-constructor
                  (list (string-append #$package "/libexec/iwd"))
                  #:log-file "/var/log/iwd.log"
                  #:environment-variables #$environment))
        (stop #~(make-kill-destructor)))))))

(define (iwd-etc-service cfg)
  (match-record cfg <iwd-configuration>
    (config)
    `(("iwd/main.conf"
       ,(apply mixed-text-file
               "main.conf"
               (serialize-ini-config config))))))

(define add-iwd-package (compose list iwd-configuration-package))

(define iwd-service-type
  (service-type
   (name 'iwd)
   (extensions
    (list
     (service-extension shepherd-root-service-type iwd-shepherd-service)
     (service-extension dbus-root-service-type add-iwd-package)
     (service-extension etc-service-type iwd-etc-service)
     (service-extension profile-service-type add-iwd-package)))
   (default-value (iwd-configuration))
   (description "")))

(define-configuration/no-serialization connman-configuration
  (package (package connman) "")
  (main (ini-config '()) "")
  (vpn (ini-config '()) "")
  (vpn-provisioning-files (list '()) ""))

(define (provisioning-configs->file-likes configs)
  (map (match-lambda
         ((k . v)
          (let ((fname (string-append (symbol->string k) ".config")))
            (list
             fname
             (apply mixed-text-file fname (serialize-ini-config v))))))
       configs))

(define (connman-activation cfg)
  (match-record cfg <connman-configuration>
    (vpn-provisioning-files)
    (let* ((files (provisioning-configs->file-likes vpn-provisioning-files))
           (vpn-dir (file-union "connman-vpn" files)))
      (with-imported-modules '((guix build utils))
        #~(begin
            (use-modules (guix build utils)
                         (ice-9 ftw))
            (mkdir-p "/var/lib/connman")
            (false-if-exception (delete-file "/var/lib/connman-vpn"))
            (symlink #$vpn-dir "/var/lib/connman-vpn"))))))

(define (connman-shepherd-service cfg)
  (match-record cfg <connman-configuration>
    (package main vpn)
    (list
     (shepherd-service
      (documentation "Run Connman")
      (provision '(networking))
      (requirement
       '(user-processes dbus-system loopback iwd))
      (start #~(make-forkexec-constructor
                (list (string-append #$package "/sbin/connmand")
                      "--nodaemon"
                      #;"--nodnsproxy"
                      "--wifi=iwd_agent"
                      (string-append
                       "--config="
                       #$(apply mixed-text-file
                                "main.conf"
                                (serialize-ini-config main))))
                #:log-file "/var/log/connman.log"))
      (stop #~(make-kill-destructor)))
     (shepherd-service
      (documentation "Run Connman VPN")
      (provision '(connman-vpn))
      (requirement '(networking))
      (start #~(make-forkexec-constructor
                (list (string-append #$package "/sbin/connman-vpnd")
                      "--nodaemon"
                      (string-append
                       "--config="
                       #$(apply mixed-text-file
                                "connman-vpn.conf"
                                (serialize-ini-config vpn))))
                #:log-file "/var/log/connman-vpn.log"))
      (stop #~(make-kill-destructor))))))

(define add-connman-package (compose list connman-configuration-package))

(define (add-vpn-provisioning-files cfg)
  (match-record cfg <connman-configuration>
    (vpn-provisioning-files)
    (let* ((files (provisioning-configs->file-likes vpn-provisioning-files))
           (vpn-dir (file-union "connman-vpn" files)))
      (with-monad %store-monad
        (return
         `(("var/lib/connman-vpn" ,vpn-dir)))))))

(define connman-service-type
  (service-type
   (name 'connman)
   (extensions
    (list
     (service-extension shepherd-root-service-type connman-shepherd-service)
     (service-extension polkit-service-type add-connman-package)
     (service-extension dbus-root-service-type add-connman-package)
     (service-extension activation-service-type connman-activation)
     (service-extension profile-service-type add-connman-package)
     (service-extension system-service-type add-vpn-provisioning-files)))
   (default-value (connman-configuration))
   (description
    "Run @url{https://01.org/connman,Connman},
a network connection manager.")))

#;(define (kebab->camel-case sym)
  (chain sym
    (symbol->string _)
    (string-split _ #\-)
    (map string-capitalize! _)
    (string-join _ "")
    (string->symbol _)))
