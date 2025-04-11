(define-module (aetheria records)
  #:use-module ((srfi srfi-1) #:select (fold))
  #:use-module ((guix records) #:select (define-record-type*))
  #:export (define-foldable-record-type
             define-foldable-wrapper-type))

(define-syntax define-foldable-record-type
  (lambda (syn)
    (define (process-properties err properties processed fold-variant default-found?)
      (syntax-case properties (fold default
                                    conflict
                                    list
                                    lines
                                    custom)
        ((rest ... (fold _)) (and fold-variant)
         (err "multiple duplicate fold variants"))

        ;; default handling. should be disallowed on conflict/list variants
        ((rest ... (default value)) (member fold-variant '(conflict list))
         (err "cannot set default value on ~a variant" fold-variant))
        ((rest ... (fold conflict)) default-found?
         (err "cannot set default value on coflict variant"))
        ((rest ... (fold list)) default-found?
         (err "cannot set default value on list variant"))
        ((rest ... (fold lines)) default-found?
         (err "cannot set default value on lines variant"))
        ((rest ... (default default-found?))
         (process-properties err #'(rest ...) (cons #'(default default-found?) processed)
                             fold-variant #'default-found?))

        ;; conflict/list
        ((rest ... (fold conflict))
         (process-properties err #'(rest ...) (cons #'(default *unspecified*) processed)
                             'conflict (datum->syntax syn #'*unspecified*)))
        ((rest ... (fold list))
         (process-properties err #'(rest ...) (cons #'(default '()) processed)
                             'list (datum->syntax syn #''())))
        ((rest ... (fold lines))
         (process-properties err #'(rest ...) (cons #'(default *unspecified*) processed)
                             'lines (datum->syntax syn #'*unspecified*)))

        ;; custom fold, remember to validate
        ((rest ... (fold custom proc-unchecked))
         (process-properties err #'(rest ...) processed
                             #'proc-unchecked default-found?))

        ((rest ... (fold _ ...))
         (err "invalid fold variant"))

        ((rest ... next)
         (begin
           (process-properties err #'(rest ...) (cons #'next processed)
                               fold-variant default-found?)))
        (() (not fold-variant)
         (err "missing (fold <variant>)"))
        (() (not default-found?)
         (err "missing (default <value>)"))
        (()
         (values fold-variant processed))))
    (define (process-fields err fields fold-parts processed)
      (syntax-case fields ()
        ((rest ... (field get properties ...))
         (call-with-values (lambda () (process-properties err #'(properties ...) #'() #f #f))
           (lambda (variant cleaned-properties)
             (process-fields err #'(rest ...)
                             (cons (lambda (record x acc)
                                     (make-fold-part record x acc #'field #'get variant))
                                   fold-parts)
                             (cons #`(field get #,@cleaned-properties) processed)))))
        (()
         (values fold-parts processed))))
    (define (make-fold-part record x acc field get variant)
      (syntax-case (list record x acc field get variant)
          (conflict list lines)
        ((record x acc field get list)
         #'(field (append (get acc) (get x))))
        ((record x acc field get conflict)
         (let* ((msg (format #f "multiple conflicting definitions for ~a"
                             (syntax->datum #'field)))
                (conflict-case #`(and (not (unspecified? (get acc)))
                                      (not (equal? (get x) (get acc))))))
           #`(field (cond
                     (#,conflict-case (error 'record #,msg acc x))
                     ((not (unspecified? (get acc))) (get acc))
                     ((not (unspecified? (get x))) (get x))))))
        ((record x acc field get lines)
         #`(field (cond
                   ((unspecified? (get acc)) (get x))
                   ((unspecified? (get x)) (get acc))
                   (else (string-append (get acc) "\n" (get x))))))
        ((record x acc field get custom)
         #'(field (let* ((custom* custom)
                         (arity (procedure-minimum-arity custom*)))
                    (unless (procedure? custom*)
                      (error 'record "custom fold wasn't a valid procedure"))
                    (unless (<= (car arity) 2 (+ (car arity) (cadr arity)))
                      (error 'record "custom fold has invalid arity"))
                    (custom* (get x) (get acc)))))))
    (syntax-case syn ()
      ((me type syntactic-ctor ctor pred fold-proc
           (field get properties ...) ...)
       #'(me type syntactic-ctor ctor pred fold-proc
             this-record
             (field get properties ...) ...))
      ((me type syntactic-ctor ctor pred fold-proc
           this-identifier
           (field get properties ...) ...)
       (call-with-values
           (lambda ()
             (define (err fmt . args)
               (syntax-violation (syntax->datum #'me) (apply format #f fmt args) syn))
             (process-fields err #'((field get properties ...) ...) '() #'()))
         (lambda (fold-parts fields)
           #`(begin
               (define-record-type* type syntactic-ctor ctor pred
                 this-identifier
                 #,@fields)
               (define (fold-proc lst default)
                 (fold #,(with-syntax
                             ((x (datum->syntax #'fold-proc 'x))
                              (acc (datum->syntax #'fold-proc 'acc)))
                           #`(lambda (x acc)
                               (syntactic-ctor #,@(map (lambda (fn) (fn #'type #'x #'acc))
                                                       fold-parts))))
                       default
                       lst)))))))))

(define-syntax define-foldable-wrapper-type
  (lambda (syn)
    (define (id . parts)
      (datum->syntax syn (apply symbol-append (map syntax->datum parts))))
    (define (process-fields name in out)
      (syntax-case in (fold list conflict lines custom)
        ((rest ... (field list))
         (with-syntax ((get (id name #'- #'field)))
           (process-fields name #'(rest ...)
                           (cons #'(field get (fold list)) out))))
        ((rest ... (field conflict))
         (with-syntax ((get (id name #'- #'field)))
           (process-fields name #'(rest ...)
                           (cons #'(field get (fold conflict)) out))))
        ((rest ... (field lines))
         (with-syntax ((get (id name #'- #'field)))
           (process-fields name #'(rest ...)
                           (cons #'(field get (fold lines)) out))))
        ((rest ... (field custom proc default*))
         (with-syntax ((get (id name #'- #'field)))
           (process-fields name #'(rest ...)
                           (cons #'(field get (fold custom proc) (default default*)) out))))
        (() out)))
    (syntax-case syn ()
      ((me name
           #:wraps wrapped
           #:wrapped-default default
           (field-name rest ...) ...)
       (let ((processed-fields (process-fields #'name #'((field-name rest ...) ...) #'())))
         (with-syntax ((type (id #'< #'name #'>))
                       (syntactic-ctor (id #'name))
                       (ctor (id #'make- #'name))
                       (pred (id #'name #'?))
                       (fold-proc (id #'fold- #'name))
                       (unwrap (id #'unwrap- #'name))
                       ((processed-field ...) processed-fields)
                       (unwrap:self (id #'self))
                       (unwrap:our-default (id #'our-default))
                       (unwrap:their-default (id #'their-default)))
           #`(begin
               (define-foldable-record-type
                 type syntactic-ctor ctor pred fold-proc
                 processed-field ...)
               (define (unwrap unwrap:self)
                 (define unwrap:our-default (syntactic-ctor))
                 (define unwrap:their-default default)
                 (wrapped
                  #,@(map
                      (lambda (field-name)
                        (with-syntax ((field field-name)
                                      (get:our (id #'name #'- field-name))
                                      (get:their (id #'wrapped #'- field-name)))
                          #`(field (if (equal? (get:our unwrap:self)
                                               (get:our unwrap:our-default))
                                       (get:their unwrap:their-default)
                                       (get:our unwrap:self)))))
                      #'(field-name ...)))))))))))
