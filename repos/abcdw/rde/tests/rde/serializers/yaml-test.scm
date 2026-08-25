;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; SPDX-FileCopyrightText: 2023 Miguel Ángel Moreno <mail@migalmoreno.com>
;;; SPDX-FileCopyrightText: 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde serializers yaml-test)
  #:use-module (ares suitbl checks)
  #:use-module (ares suitbl definitions)
  #:use-module (guix gexp)
  #:use-module ((ice-9 exceptions)
                #:select (exception-message
                          exception-with-message?))
  #:use-module (rde serializers yaml)
  #:use-module (rde api store))

(define (serialize-yaml config)
  (evaluate-gexp-local (yaml-serialize config)))


(define-suite (yaml-basic-values-tests)
  (test "number" ()
    (is (equal? "123" (serialize-yaml-term 123))))

  (test "string" ()
    (is (equal? "\"string here\""
                (serialize-yaml-term "string here"))))

  (test "symbol" ()
    (is (equal? "symbol_here"
                (serialize-yaml-term 'symbol_here))))

  (test "gexp" ()
    (is (gexp? (serialize-yaml-term #~"gexp"))))

  (test "true" ()
    (is (equal? "true" (serialize-yaml-term #t))))

  (test "false" ()
    (is (equal? "false" (serialize-yaml-term #f))))

  (test "list" ()
    (is (throws-exception? (serialize-yaml-term '(a b c)))))

  (test "vector" ()
    (is (throws-exception? (serialize-yaml-term #(a b c))))))

(define-suite (yaml-lists-tests)
  (test "basic list" ()
    (is (equal? "[a, b, c]"
                (serialize-yaml '(a b c))))))

(define-suite (yaml-alists-tests)
  (test "basic alist" ()
    (is (equal? "a: b"
                (serialize-yaml '((a . b))))))

  (test "nested alist" ()
    (is (equal? "logging: \

  print_level: debug"
                (serialize-yaml
                 '((logging . ((print_level . debug))))))))

  (test "invalid key" ()
    (is (throws-exception?
         (serialize-yaml-config #f '((1 . test)))
         (lambda (exception)
           (and (yaml-invalid-key-exception? exception)
                (equal? 1 (yaml-invalid-key-exception-key exception))
                (exception-with-message? exception)
                (equal? "\
YAML key should be symbol or string. Provided key is:
 1"
                        (exception-message exception))))))))

(define-suite (yaml-vectors-tests)
  (test "basic vector" ()
    (is (equal? "
- a
- b
- c"
                (serialize-yaml #(a b c)))))

  (test "nested alist" ()
    (is (equal? "
- names: [client, federation]
  compress: false"
                (serialize-yaml #(((names . (client federation))
                                   (compress . #f)))))))

  (test "nested list" ()
    (is (throws-exception? (serialize-yaml #(()))))))

(define-suite (yaml-example-config-tests)
  (test "full length example" ()
    (is (equal? "\
server_name: \"matrix.org\"
public_base_url: \"https://matrix.org\"
media_store_path: \"/var/lib/matrix-synapse/media_store\"
max_upload_size: \"50M\"
enable_registration: false
report_stats: true
database: \

  name: psycopg2
  allow_unsafe_locale: true
  args: \

    user: \"matrix-synapse\"
    database: \"matrix-synapse\"
    host: localhost
    port: 5432
    cp_min: 5
    cp_max: 10
listeners: \

  - port: 8008
    tls: false
    type: http
    x_forwarded: true
    bind_addresses: \

      - \"::1\"
      - \"127.0.0.1\"
    resources: \

      - names: [client, federation]
        compress: false
trusted_key_servers: \

  - server_name: \"matrix.org\""
      (serialize-yaml
       '((server_name . "matrix.org")
         (public_base_url . "https://matrix.org")
         (media_store_path . "/var/lib/matrix-synapse/media_store")
         (max_upload_size . "50M")
         (enable_registration . #f)
         (report_stats . #t)
         (database . ((name . psycopg2)
                      (allow_unsafe_locale . #t)
                      (args . ((user . "matrix-synapse")
                               (database . "matrix-synapse")
                               (host . localhost)
                               (port . 5432)
                               (cp_min . 5)
                               (cp_max . 10)))))
         (listeners . #(((port . 8008)
                         (tls . #f)
                         (type . http)
                         (x_forwarded . true)
                         (bind_addresses . #("::1" "127.0.0.1"))
                         (resources . #(((names . (client federation))
                                         (compress . #f)))))))
         (trusted_key_servers . #(((server_name . "matrix.org"))))))))))
