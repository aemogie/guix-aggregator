(provide define-public)

(define-syntax define-public
  (syntax-rules ()
    [(define-public (name args ...) body ...)
     (begin
       (define (name args ...) body ...)
       (provide name))]
    [(define-public name expr)
     (begin
       (define name expr)
       (provide name))]))
