(define-module (aetheria records)
  #:use-module ((srfi srfi-1) #:select (fold))
  #:use-module ((guix records) #:select (define-record-type*))
  #:export (define-foldable-record-type
             define-foldable-wrapper-type))

(define-syntax define-foldable-record-type
  (lambda (syn)
    (define (process-properties err properties processed fold-variant default)
      (syntax-case properties (fold conflict list custom default)
        ((rest ... (fold _)) (and fold-variant)
         (err "multiple duplicate fold variants"))

        ;; list/conflict
        ((rest ... (fold conflict)) (not default)
         (process-properties err #'(rest ...) processed
                             'conflict (datum->syntax syn #'*unspecified*)))
        ((rest ... (fold list)) (not default)
         (process-properties err #'(rest ...) processed
                             'list (datum->syntax syn #''())))
        ((rest ... (default value)) (member fold-variant '(conflict list))
         (err "cannot set default value on ~a variant" fold-variant))
        ((rest ... (default value))
         (process-properties err #'(rest ...) processed
                             fold-variant #'value))

        ;; custom fold, remember to validate
        ((rest ... (fold custom proc-unchecked))
         (process-properties err #'(rest ...) processed
                             #'proc-unchecked default))

        ((rest ... (fold _ ...))
         (err "invalid fold variant"))

        ((rest ... next)
         (begin
           (process-properties err #'(rest ...) (cons #'next processed)
                               fold-variant default)))
        (() (not fold-variant)
         (err "missing (fold <variant>)"))
        (() (not default)
         (err "missing (default <value>)"))
        (()
         (values fold-variant default (append processed #`((default #,default)))))))
    (define (process-fields err fields fold-parts defaults processed)
      (syntax-case fields ()
        ((rest ... (field get properties ...))
         (call-with-values (lambda () (process-properties err #'(properties ...) #'() #f #f))
           (lambda (variant default cleaned-properties)
             (process-fields err #'(rest ...)
                             (cons (lambda (record x acc)
                                     (make-fold-part record x acc #'field #'get variant))
                                   fold-parts)
                             (cons #`(field #,default) defaults)
                             (cons #`(field get #,@cleaned-properties) processed)))))
        (()
         (values fold-parts defaults processed))))
    (define (make-fold-part record x acc field get variant)
      (syntax-case (list record x acc field get variant) (conflict list)
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
             (process-fields err #'((field get properties ...) ...) '() #'() #'()))
         (lambda (fold-parts defaults fields)
           (with-syntax
               ((x (datum->syntax #'fold-proc 'x))
                (acc (datum->syntax #'fold-proc 'acc))
                ((field ...) fields))
             #`(begin
                  (define-record-type* type syntactic-ctor ctor pred
                    this-identifier
                    field ...)
                  (define* (fold-proc lst #:optional (init (syntactic-ctor #,@defaults)))
                    (fold (lambda (x acc)
                            (syntactic-ctor
                             #,@(map (lambda (fn) (fn #'type #'x #'acc)) fold-parts)))
                          init
                          lst))))))))))

(define-syntax define-foldable-wrapper-type
  (lambda (syn)
    (define (id . parts)
      (datum->syntax syn (apply symbol-append (map syntax->datum parts))))
    (define (process-fields name in out defaults)
      (syntax-case in (fold list conflict custom)
        ((rest ... (field list))
         (with-syntax ((get (id name #'- #'field)))
           (process-fields name #'(rest ...)
                           (cons #'(field get (fold list)) out)
                           (acons #'field #''() defaults))))
        ((rest ... (field conflict))
         (with-syntax ((get (id name #'- #'field)))
           (process-fields name #'(rest ...)
                           (cons #'(field get (fold conflict)) out)
                           (acons #'field #'*unspecified* defaults))))
        ((rest ... (field custom proc default*))
         (with-syntax ((get (id name #'- #'field)))
           (process-fields name #'(rest ...)
                           (cons #'(field get (fold custom proc) (default default*)) out)
                           (acons #'field #'default* defaults))))
        (() (cons out defaults))))
    (syntax-case syn (%default)
      ((me name wrapped (%default default) (field-name rest ...) ...)
       (let ((processed-fields (process-fields #'name #'((field-name rest ...) ...) #'() '())))
         (with-syntax ((type (id #'< #'name #'>))
                       (syntactic-ctor (id #'name))
                       (ctor (id #'make- #'name))
                       (pred (id #'name #'?))
                       (fold-proc (id #'fold- #'name))
                       (unwrap (id #'unwrap- #'name))
                       ((processed-field ...) (car processed-fields))
                       (unwrap:our (id #'our))
                       (unwrap:their-default (id #'%default)))
           #`(begin
               (define-foldable-record-type
                 type syntactic-ctor ctor pred fold-proc
                 processed-field ...)
               (define (unwrap unwrap:our)
                 (define unwrap:their-default default)
                 (wrapped
                  #,@(map
                      (lambda (field-name)
                        (with-syntax ((field field-name)
                                      (get:our (id #'name #'- field-name))
                                      (get:their (id #'wrapped #'- field-name)))
                          #`(field (if (equal? (get:our unwrap:our)
                                               #,(cdr (assoc #'field (cdr processed-fields))))
                                       (get:their unwrap:their-default)
                                       (get:our unwrap:our)))))
                      #'(field-name ...)))))))))))
