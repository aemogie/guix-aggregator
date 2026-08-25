;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; SPDX-FileCopyrightText: 2023, 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde serializers nginx-test)
  #:use-module (ares suitbl checks)
  #:use-module (ares suitbl definitions)
  #:use-module (guix gexp)
  #:use-module (rde serializers nginx)
  #:use-module (rde api store)
  #:use-module (ice-9 match))

(define (serialize-config config)
  (evaluate-gexp-local (nginx-serialize config)))


;;; Tests

(define-suite (nginx-terms-tests)
  (test "number" ()
    (is (equal? "123" (serialize-nginx-term 123))))

  (test "string" ()
    (is (equal? "\"string here\""
                (serialize-nginx-term "string here"))))

  (test "symbol" ()
    (is (equal? "symbol-here"
                (serialize-nginx-term 'symbol-here))))

  (test "gexp" ()
    (is (gexp? (serialize-nginx-term #~"gexp"))))

  (test "file-like" ()
    (is (file-like?
         (serialize-nginx-term (plain-file "name" "content")))))

  (test "true" ()
    (is (throws-exception? (serialize-nginx-term #t))))

  (test "false" ()
    (is (throws-exception? (serialize-nginx-term #f))))

  (test "list" ()
    (is (throws-exception? (serialize-nginx-term '(a b c)))))

  (test "vector" ()
    (is (throws-exception? (serialize-nginx-term #(a b c))))))

(define-suite (nginx-vectors-tests)
  (test "vector with a few terms" ()
    (is (match (serialize-nginx-vector
                `#(symbol "string" 123 ,#~(format #f "gexp")))
          (("(" "symbol" " " "\"string\"" " " "123" " " (? gexp? _) ")") #t)
          (_ #f))))

  (test "nested list" ()
    (is (throws-exception? (serialize-nginx-vector #(())))))

  (test "nested vector" ()
    (is (throws-exception? (serialize-nginx-vector #(#()))))))


(define-suite (nginx-contexts-tests)
  (test "simple nested config" ()
    (is (match (serialize-nginx-context
                `((a b ((c d)))))
          (("" "a" " " "b" " {\n"
            "  " "c" " " "d" ";" "\n"
            "" "}\n") #t)
          (_ #f))))

  (test "empty subcontext" ()
    (is (match (serialize-nginx-context
                `((a b ())))
          (("" "a" " " "b" " {\n"
            "" "}\n") #t)
          (_ #f))))

  (test "double nested config" ()
    (is (match (serialize-nginx-context
                `((a ((b ((c d)))))))
          (("" "a" " {\n"
            "  " "b" " {\n"
            "    " "c" " " "d" ";" "\n"
            "  " "}\n"
            "" "}\n") #t)
          (_ #f))))

  (test "double nested config with vector" ()
    (is (match (serialize-nginx-context
                `((a ((b #() ((c)))))))
          (("" "a" " {\n"
            "  " "b" " " "(" ")" " {\n"
            "    " "c" ";" "\n"
            "  " "}\n"
            "" "}\n") #t)
          (_ #f)))))

(define-suite (basic-config-tests)
  (test "key-value pairs" ()
    (is (equal? "\
a b;
c d;
"
                (serialize-config '((a b)
                                    (c d))))))

  (test "nested context" ()
    (is (equal? "\
a b {
  c d;
}
"
                (serialize-config '((a b ((c d))))))))

  (test "simple if statement" ()
    (is (equal? "\
if (a ~ b) {
  c d;
}
"
                (serialize-config '((if #(a ~ b) ((c d)))))))))

(define-suite (gexps-tests)
  (test "simple gexps" ()
    (is (equal? "\
a hehe;
"
                (serialize-config
                 `((a ,#~(format #f "hehe")))))))

  (test "simple identation of gexps" ()
    (is (equal? "\
a {
# gexp
}
"
                (serialize-config
                 `((a (,#~"# gexp")))))))

  (test "advanced identation of gexps" ()
    (is (equal? "\
a {
  a gexp-generated value;
# unindented
  # indented again;
}
"
                (serialize-config
                 `((a ((a ,#~"gexp-generated" value)
                       ,#~"# unindented"
                       (,#~"# indented again")))))))))

(define-suite (example-config-tests)
  (test "location with nested if and empty body" ()
    (is (equal? "\
location ~* ^/if-and-alias/(?<file>.*) {
  alias /tmp/$file;
  set $true 1;
  if ($true) {
    # nothing;
  }
}
"
                (serialize-config
                 `((location ~*
                             #{^/if-and-alias/(?<file>.*)}# ; guile symbol read syntax
                             ;; ,#~"^/if-and-alias/(?<file>.*)"
                             ((alias /tmp/$file)
                              (set $true 1)
                              (if #($true) ((,#~"# nothing"))))))))))

  (test "location with nested if 2" ()
    (is (equal? "\
location / {
  error_page 418 = @other;
  recursive_error_pages on;
  if ($something) {
    return 418;
  }
}
"
                (serialize-config
                 '((location / ((error_page 418 = @other)
                                (recursive_error_pages on)
                                (if #($something)
                                    ((return 418)))))))))))

(define-suite (nginx-config-merge-tests)
  (define gexp-l #~"l")
  (define gexp-m #~"m")

  (test "simple merge" ()
    (is (equal? `((a ((b c)))
                  (j k)
                  ,gexp-l
                  (,gexp-m)
                  (d ((e f)))
                  (g ((h i))))
                (nginx-merge `((a ((b c)))
                               (j k)
                               ,gexp-l
                               (,gexp-m))
                             '((d ((e f))))
                             '((g ((h i))))))))

  (test "empty context merge" ()
    (is (equal? '((a b ((e f))))
                (nginx-merge '((a b ()))
                             '((a b ((e f))))))))

  (test "advanced merge" ()
    (is (equal? '((a b ((b c)
                        (e f)
                        (h i))))
                (nginx-merge '((a b ((b c))))
                             '((a b ((e f))))
                             '((a b ((h i))))))))

  ;; It will require some parametrization of merge function.
  ;; For example providing a list of keys to override.
  (test "merge with override" ()
    'metadata '((expected-failure? . #t))
    (is (equal? '((user c d)
                  (a ((b ((c f))))))
                (nginx-merge '((user a b)
                               (a ((b ((c d))))))
                             '((user c d)
                               (a ((b ((c f))))))))))

  ;; It will require some parametrization of merge function as well.  Maybe
  ;; a list of nested keys to use for equal comparison or maybe some
  ;; hardcoded merge logic.

  ;; There is a potential problem with gexp-generated content, as it won't
  ;; be equal to plain strings/symbols.
  (test "merge a few server blocks" ()
    'metadata '((expected-failure? . #t))
    (is (equal? '((http ((server ((listen 80)
                                  (server_name a)
                                  (listen 443 ssl)))
                         (server ((listen 80)
                                  (server_name b))))))
                (nginx-merge '((http ((server ((listen 80)
                                               (server_name a))))))
                             '((http ((server ((listen 443 ssl)
                                               (server_name a))))))
                             '((http ((server ((listen 80)
                                               (server_name b))))))))))

  (test "deep merge" ()
    (is (equal? '((a ((b ((c d)
                          (e f)
                          (g h)))
                      (i j))))
                (nginx-merge '((a ((b ((c d))))))
                             '((a ((b ((e f))))))
                             '((a ((b ((g h)))
                                   (i j))))))))

  (test "deep merge + gexps" ()
    (is (equal? `((a ((b ((c d)
                          (,gexp-l) ;; Check that equality compared correctly
                          ,gexp-m
                          (g h)))
                      (i j))))
                (nginx-merge '((a ((b ((c d))))))
                             `((a ((b ((,gexp-l)
                                       ,gexp-m)))))
                             '((a ((b ((g h)))
                                   (i j)))))))))

(define-suite (nginx-config-predicate-tests)
  (test "valid: simple case" ()
    (is (nginx-config? `((if #(ho) ((b c)))
                         ,#~"# heh"))))

  ;; Current implementation doesn't traverse the data structure and doesn't
  ;; check elements of nginx expression.
  (test "not valid: two subcontexts" ()
    'metadata '((expected-failure? . #t))
    (is (not (nginx-config? '((a ((e f)) ((b c))))))))

  ;; Current implementation doesn't traverse the data structure and checks
  ;; only the top level context.
  (test "not valid: incorrect subcontext" ()
    'metadata '((expected-failure? . #t))
    (is (not (nginx-config? '((a (c))))))))

;; if ($http_user_agent ~ MSIE) {
;;     rewrite ^(.*)$ /msie/$1 break;
;; }

;; if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
;;     set $id $1;
;; }

;; if ($request_method = POST) {
;;     return 405;
;; }

;; if ($slow) {
;;     limit_rate 10k;
;; }

;; if ($invalid_referer) {
;;     return 403;
;; }

;; location ~* ^/if-and-alias/(?<file>.*) {
;;     alias /tmp/$file;
;;     set $true 1;
;;     if ($true) {
;;         # nothing
;;     }
;; }

;; if ($args ~ post=140){
;;   rewrite ^ http://example.com/ permanent;
;; }

;; https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts
;; https://stackoverflow.com/questions/2936260/what-language-are-nginx-conf-files
;; https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/
