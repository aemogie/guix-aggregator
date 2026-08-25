;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; SPDX-FileCopyrightText: 2023, 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde serializers lisp-test)
  #:use-module (ares suitbl definitions)
  #:use-module (guix gexp)
  #:use-module (guix read-print)
  #:use-module (rde api store)
  #:use-module (rde serializers lisp))

(define (serialize-config config)
  "Returns a string representing serialized config."
  (evaluate-gexp-local (serialize-sexp-config #f config)))

(define (serialize-and-read-config config)
  "Returns a list of forms read from serialized config."
  (call-with-input-string (serialize-config config)
    (lambda (port) (read-with-comments/sequence port))))

(define-suite (basic-types-tests)
  (test "symbols" ()
    (is (equal? '(hello there)
                (serialize-and-read-config `(hello there)))))

  (test "numbers" ()
    (is (equal? '(1 1/3 4.5)
                (serialize-and-read-config `(1 1/3 4.5)))))

  (test "booleans" ()
    (is (equal? '(#f #t)
                (serialize-and-read-config `(#f #t)))))

  (test "strings" ()
    (is (equal? '("hello" "there")
                (serialize-and-read-config `("hello" "there"))))))

(define-suite (reader-macros-tests)
  (test "quote" ()
    (is (equal? "'(hello there)\n"
                (serialize-config `('(hello there))))))

  (test "quasiquote and unquote" ()
    (is (equal? "`(hello ,there)\n"
                (serialize-config `(`(hello ,there))))))

  ;; TODO: Move it to an elisp serializer test.
  (test "square brackets" ()
    'metadata '((expected-failure? . #t))
    (is (equal? "[hello there]\n"
                (serialize-config `([hello there])))))

  ;; We should update pretty-printer used in serialization code or workaround
  ;; it some other way.  Now, it's impossible to use this construction with
  ;; emacs-lisp.
  (test "syntax" ()
    'metadata '((expected-failure? . #t))
    (is (equal? "#'symbol\n"
                (serialize-config `(#'symbol))))))

(define-suite (gexps-tests)
  (test "newlines and comments" ()
    (is (equal? "
;;; Hello there

;; more comments here
"
                (serialize-config `(,#~""
                                    ,#~";;; Hello there"
                                    ,#~""
                                    ,#~";; more comments here")))))

  (test "top-level gexp eval" ()
    (is (equal? ";; hello there\n"
                (serialize-config `(,#~(format #f ";; hello there"))))))

  ;; Due to incomplete implementation of the serializer this test fails.  A
  ;; more accurate implementation should pass this test.
  (test "nested gexp eval" ()
    'metadata '((expected-failure? . #t))
    (is (equal? "(message \"message\")\n"
                (serialize-config
                 `((message ,#~(format #f "~s" "message"))))))))
