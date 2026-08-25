;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; SPDX-FileCopyrightText: 2023, 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde features-test)
  #:use-module (ares suitbl definitions)
  #:use-module (rde features))


(define feature-1
  (feature
   (values '((a . b)
             (c . d)))
   (home-services-getter (lambda (x) '(ha hb)))
   (system-services-getter (lambda (x) '(sa sb)))))

(define feature-2
  (feature
   (values '((e . f)
             (g . h)))
   (home-services-getter (lambda (x) '(hc hd)))
   (system-services-getter (lambda (x) '(sc sd)))))

(define super-feature
  (merge-features (list feature-1 feature-2)))

(define-suite (merged-features-tests)
  (test "values are combined" ()
    (is (equal? '((a . b)
                  (c . d)
                  (e . f)
                  (g . h))
                (feature-values super-feature))))

  (test "home services are combined" ()
    (is (equal? '(ha hb hc hd)
                ((feature-home-services-getter super-feature) #f))))

  (test "system services are combined" ()
    (is (equal? '(sa sb sc sd)
                ((feature-system-services-getter super-feature) #f)))))
