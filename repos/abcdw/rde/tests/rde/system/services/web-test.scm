;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; SPDX-FileCopyrightText: 2023, 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde system services web-test)
  #:use-module (ares suitbl definitions)
  #:use-module (guix gexp)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system accounts)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages web)
  #:use-module (rde serializers nginx)
  #:use-module (rde system services web)
  #:use-module (rde api store)
  #:use-module (srfi srfi-1)
  #:use-module ((ice-9 exceptions)
                #:select (make-assertion-failure
                          make-exception-with-message))
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex))

(define (serialize-config config)
  (evaluate-gexp-local (nginx-serialize config)))

(define (hardening-settings host)
  `((harden ,host please)
    (harden very much)))

(define base-services
  (list
   (service system-service-type '())
   (service etc-service-type '())
   ;; (service shepherd-root-service-type)
   (service profile-service-type '())
   ;; (service user-processes-service-type)
   (service boot-service-type #f)
   (service activation-service-type #f)
   (service account-service-type '())))

(define (services->config-string services)
  (serialize-config
   (nginx-configuration-nginx-conf
    (service-value (fold-services
                    (instantiate-missing-services
                     (append base-services services))
                    #:target-type nginx-service-type)))))

(define (drop-nth-line s n)
  (let ((lines (string-split s #\newline)))
    (when (not (<= 0 n (1- (length lines))))
      (raise-exception
       (make-exception
        (make-assertion-failure)
        (make-exception-with-message
         (format #f "n should be in a range [~a, ~a]" 0 (1- (length lines)))))))
    (string-join
     (append
      (take lines n)
      (take-right lines (- (length lines) n 1)))
     "\n")))

(define-suite (nginx-basic-config-tests)
  (define services
    (list
     (service
      nginx-service-type
      (nginx-configuration
       (nginx-conf
        `((load_module ,(file-append nginx-rtmp-module
                                     "/etc/nginx/modules/ngx_rtmp_module.so"))
          ,#~""
          (events (,#~""))
          (http
           ((server
             ((listen 80)
              (listen 443 ssl)
              ,@(hardening-settings 'trop.in)
              (ssl_protocols TLSv1.2)
              (server_name trop.in *.trop.in)
              (location /one (,#~""))))))

          ,#~""
          (rtmp (,#~"# The content of rtmp context will be appended here"))))))

     (simple-service
      'simple-nginx-extension
      nginx-service-type
      (nginx-extension
       (nginx-conf
        `((rtmp
           ((server (,@(hardening-settings 'rtmp.trop.in)
                     (,#~(format #f "list~a" "en") 1935)))))
          (http
           ((server trop.in ((location /one ((c d)))
                             (location /two ((e f)))))))))))))

  (define pattern
    "\
user nginx nginx;
pid /var/run/nginx/pid;

load_module /gnu/store/19apmplkgpmnvn963cfydgjhhnvpf9fs-nginx-rtmp-module-1.2.2/etc/nginx/modules/ngx_rtmp_module.so;

events {

}
http {
  server {
    listen 80;
    listen 443 ssl;
    harden trop.in please;
    harden very much;
    ssl_protocols TLSv1.2;
    server_name trop.in *.trop.in;
    location /one {

    }
  }
  server trop.in {
    location /one {
      c d;
    }
    location /two {
      e f;
    }
  }
}

rtmp {
# The content of rtmp context will be appended here
  server {
    harden rtmp.trop.in please;
    harden very much;
    listen 1935;
  }
}
")

  ;; Should start failing once configuration check implemented.
  (test "service, simple-service http+rtmp contexts" ()
    (is (equal? (drop-nth-line pattern 3)
                (drop-nth-line (services->config-string services) 3)))))
