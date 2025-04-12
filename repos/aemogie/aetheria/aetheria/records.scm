(define-module (aetheria records)
  #:use-module ((srfi srfi-1) #:select (fold
                                        concatenate))
  #:use-module ((srfi srfi-11) #:select (let-values))
  #:use-module ((srfi srfi-34) #:select (raise))
  #:use-module ((srfi srfi-35) #:select (define-condition-type
                                          condition))
  #:use-module ((ice-9 match) #:select (match-let*))
  #:use-module ((ice-9 exceptions) #:select (&implementation-restriction))
  #:use-module ((guix records) #:select (define-record-type*))
  #:export (<fold-strategy>
            fold-strategy
            make-fold-strategy
            fold-strategy-default
            fold-strategy-reduce
            &bad-fold-strategy

            conflict-strategy
            &record-fold-conflict
            append-strategy
            lines-strategy

            &foldable-record-error
            &multiple-fold-strategies-error
            &default-not-allowed-error
            &missing-fold-strategy-error

            define-foldable-record-type
             define-foldable-wrapper-type))

(define-condition-type &bad-fold-strategy &implementation-restriction
  bad-fold-strategy?)

(define-record-type* <fold-strategy>
  fold-strategy make-fold-strategy
  fold-strategy?
  (default fold-strategy-default)       ; any
  (reduce fold-strategy-reduce          ; procedure (x acc) => acc
          (sanitize
           (lambda (proc)
             (match-let* ((good-proc? (procedure? proc))
                          ((required optional rest?) (procedure-minimum-arity proc))
                          (good-arity? (or rest? (<= required 2 (+ required optional)))))
               (if (and good-proc? good-arity?) proc
                   (raise (condition (&bad-fold-strategy)))))))))

(define-condition-type &record-fold-conflict &implementation-restriction
  record-fold-conflict?
  (first record-fold-conflict-first)
  (second record-fold-conflict-second))

(define conflict-strategy
  (fold-strategy
   (default *unspecified*)
   (reduce (lambda (x acc)
             (cond ((and (not (unspecified? acc))
                         (not (unspecified? x))
                         (not (equal? x acc)))
                    (raise (condition (&record-fold-conflict
                                       (first acc)
                                       (second x)))))
                   ;; order doesnt matter, since we have concluded that either
                   ;; only one is unspecified or both are equal
                   ((unspecified? acc) x)
                   ((unspecified? x) acc))))))

(define append-strategy
  (fold-strategy
   (default '())
   (reduce append)))

(define lines-strategy
  (fold-strategy
   (default "")
   (reduce (lambda (x acc)
             (cond ((string-null? x) acc)
                   ((string-null? acc) (string-append x "\n"))
                   (else (string-append acc x "\n")))))))

;; top-level supertype of any errors from this macro
(define-condition-type &foldable-record-error &implementation-restriction
  foldadble-record-error?)

(define-record-type* <processed-properties>
  processed-properties make-processed-properties
  processed-properties?
  (strategy processed-properties-strategy ; syntax object of <fold-strategy>
            (default *unspecified*))
  (forwarded processed-properties-forwarded ; list of syntax objects
             (default '())))

(define (merge-processed-properties a b)
  (processed-properties
   (strategy (cond ((and (not (unspecified? (processed-properties-strategy a)))
                         (not (unspecified? (processed-properties-strategy b))))
                    (raise (condition (&multiple-fold-strategies-error
                                       (first (syntax->datum
                                               (processed-properties-strategy a)))
                                       (second (syntax->datum
                                                (processed-properties-strategy b)))))))
                   ((not (unspecified? (processed-properties-strategy a)))
                    (processed-properties-strategy a))
                   ((not (unspecified? (processed-properties-strategy b)))
                    (processed-properties-strategy b))))
   (forwarded (append (processed-properties-forwarded a)
                      (processed-properties-forwarded b)))))

(define-condition-type &multiple-fold-strategies-error &foldable-record-error
  multiple-fold-strategies-error?
  (first multiple-fold-strategies-error-first)
  (second multiple-fold-strategies-error-second))

(define-condition-type &default-not-allowed-error &foldable-record-error
  default-not-allowed-error?
  (property default-not-allowed-error-property))

(define-condition-type &missing-fold-strategy-error &foldable-record-error
  missing-fold-strategy-error?)

(define (process-properties properties acc)
  (syntax-case properties (fold default)
    (((fold strategy*) rest ...)        ; (fold)
     (process-properties #'(rest ...)
                         (merge-processed-properties
                          (processed-properties
                           (strategy #'strategy*)
                           (forwarded #'((default (fold-strategy-default strategy*)))))
                          acc)))
    (((default value) rest ...)         ; (default)
     (raise (condition (&default-not-allowed-error
                        (property (syntax->datum #'(default value)))))))
    ((next rest ...)                    ; (*)
     (process-properties #'(rest ...)
                         (merge-processed-properties
                          (processed-properties
                           (forwarded #'(next)))
                          acc)))
                                        ; done
    (() (unspecified? (processed-properties-strategy acc))
     (raise (condition (&missing-fold-strategy-error))))
    (() acc)))

(define-record-type* <processed-fields>
  processed-fields make-processed-fields
  processed-fields?
  (strategies processed-fields-strategies
              (default '())) ; partial syntax object for the body of a syntactict-ctor
  (forwarded processed-fields-forwarded
             (default '()))) ; list of syntax objects

(define (merge-processed-fields a b)
  (processed-fields
   (strategies (append (processed-fields-strategies a)
                       (processed-fields-strategies b)))
   (forwarded (append (processed-fields-forwarded a)
                      (processed-fields-forwarded b)))))

(define (process-fields fields x-id acc-id acc)
  (with-syntax ((x-id x-id)
                (acc-id acc-id))
    (syntax-case fields ()
      (((field get properties ...) rest ...)
       (let ((processed (process-properties #'(properties ...) (processed-properties))))
         (with-syntax ((strategy (processed-properties-strategy processed))
                       ((props ...) (processed-properties-forwarded processed)))
           (process-fields #'(rest ...) #'x-id #'acc-id
                           (merge-processed-fields
                            (processed-fields
                             (strategies #'((field ((fold-strategy-reduce strategy)
                                                    (get x-id) (get acc-id)))))
                             (forwarded #'((field get props ...))))
                            acc)))))
      (() acc))))

(define-syntax define-foldable-record-type
  (lambda (syn)
    (syntax-case syn ()
      ((_ type syntactic-ctor ctor pred
          merge-proc fold-proc
          (field get properties ...) ...)
       #'(define-foldable-record-type type syntactic-ctor ctor pred
           merge-proc fold-proc
           this-record
           (field get properties ...) ...))
      ((_ type syntactic-ctor ctor pred
          merge-proc fold-proc
          this-identifier
          (field get properties ...) ...)
       (with-syntax ((x-id (datum->syntax syn 'x))
                     (acc-id (datum->syntax syn 'acc)))
         (let ((new-fields (process-fields #'((field get properties ...) ...)
                                           #'x-id #'acc-id
                                           (processed-fields))))
           (with-syntax (((strategies ...) (processed-fields-strategies new-fields))
                         ((forwarded-fields ...) (processed-fields-forwarded new-fields)))
             #'(begin
                 (define-record-type* type syntactic-ctor ctor pred
                   this-identifier
                   forwarded-fields ...)
                 (define (merge-proc x-id acc-id)
                   (syntactic-ctor
                    strategies ...))
                 (define (fold-proc lst)
                   (fold merge-proc (syntactic-ctor) lst))))))))))
