(define-module (prelude curry)
  #:use-module (srfi srfi-1)
  #:export (define-curry))

(define-syntax define-curry
  (λ (stx)
    (syntax-case stx ()
      ((_ (name args ...) body body* ...)
       (with-syntax
           (((case-clauses ...)
             (map (λ (i)
                    (with-syntax
                        (((case-args lambda-args)
                          (call-with-values (λ () (split-at #'(args ...) i))
                            list)))
                      #'(case-args (λ lambda-args (name args ...)))))
                  (iota (length #'(args ...))))))
         #'(define name
             (case-lambda
               case-clauses ...
               ((args ...) body body* ...))))))))
