;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; SPDX-FileCopyrightText: 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde suitbl schedulers)
  #:use-module ((srfi srfi-1) #:select (filter))
  #:export (exclude-expected-failures))

(define (test-metadata test)
  (or (assoc-ref test 'test/compound-metadata)
      (assoc-ref test 'test/metadata)
      '()))

(define (exclude-expected-failures tests _state)
  (filter (lambda (test)
            (not (assoc-ref (test-metadata test) 'expected-failure?)))
          tests))
