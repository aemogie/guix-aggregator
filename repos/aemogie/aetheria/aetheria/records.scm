(define-module (aetheria records)
  #:use-module ((srfi srfi-1) #:select (fold
                                        concatenate))
  #:use-module ((srfi srfi-11) #:select (let-values))
  #:use-module ((srfi srfi-34) #:select (raise))
  #:use-module ((srfi srfi-35) #:select (define-condition-type
                                          condition))
  #:use-module ((ice-9 match) #:select (match-let*))
  #:use-module ((ice-9 exceptions) #:select (&implementation-restriction))
  #:use-module ((guix records) #:select (define-record-type*
                                          this-record))
  #:export (<merge-strategy>
            merge-strategy
            make-merge-strategy
            merge-strategy-default
            merge-strategy-merge
            &bad-merge-strategy

            conflict-strategy
            &record-fold-conflict
            append-strategy
            lines-strategy

            define-record-type2))

(define-condition-type &bad-merge-strategy &implementation-restriction
  bad-merge-strategy?)

(define-record-type* <merge-strategy>
  merge-strategy make-merge-strategy
  merge-strategy?
  (default merge-strategy-default)       ; any
  (merge merge-strategy-merge          ; procedure (x acc) => acc
          (sanitize
           (lambda (proc)
             (match-let* ((good-proc? (procedure? proc))
                          ((required optional rest?) (procedure-minimum-arity proc))
                          (good-arity? (or rest? (<= required 2 (+ required optional)))))
               (if (and good-proc? good-arity?) proc
                   (raise (condition (&bad-merge-strategy)))))))))

(define-condition-type &record-fold-conflict &implementation-restriction
  record-fold-conflict?
  (first record-fold-conflict-first)
  (second record-fold-conflict-second))

(define conflict-strategy
  (merge-strategy
   (default *unspecified*)
   (merge (lambda (a b)
             (cond ((and (not (unspecified? a))
                         (not (unspecified? b))
                         (not (equal? a b)))
                    (raise (condition (&record-fold-conflict
                                       (first a)
                                       (second b)))))
                   ;; order doesnt matter, since we have concluded that either
                   ;; only one is unspecified or both are equal
                   ((not (unspecified? a)) b)
                   ((not (unspecified? b)) b))))))

(define append-strategy
  (merge-strategy
   (default '())
   (merge append)))

(define lines-strategy
  (merge-strategy
   (default "")
   (merge (lambda (a b)
             ;; not foolproof, maybe make more robust
             (define a* (if (string-null? a) a
                            (if (string-suffix? "\n" a) a (string-append a "\n"))))
             (define b* (if (string-null? b) b
                            (if (string-suffix? "\n" b) b (string-append b "\n"))))
             (string-append a* b*)))))

(define-syntax define-record-type2
  (lambda (syn)
    (define (attrs-loop merges? attrs-syn forward strategy)
      (syntax-case attrs-syn (merge default)
        ((rest ... (merge strategy)) merges?
         (attrs-loop merges? #'(rest ...)
                     (cons #'(default (merge-strategy-default strategy)) forward)
                     #'strategy))
        ((rest ... (default value)) merges?
         (syntax-violation #f "default not allowed" syn #'(default value)))
        ((rest ... next)
         (attrs-loop merges? #'(rest ...)
                     (cons #'next forward)
                     strategy))
        (() (and merges? (not strategy))
         (syntax-violation #f "no merge strategy" syn))
        (() (cons forward strategy))))

    (define (field-loop name a-id b-id merges? fields-syn forward fields strategies)
      ;; (field ((merge-strategy-merge strategy) (get a-id) (get b-id)))
      (syntax-case fields-syn ()
        ((rest ... (field (attr ...) ...))
         (let* ((get (symbol-append name '- (syntax->datum #'field)))
                (attrs (attrs-loop merges? #'((attr ...) ...) '() #f)))
           (with-syntax ((get (datum->syntax #'field get))
                         (((attr ...) ...) (car attrs))
                         (strategy (cdr attrs))
                         (a-id a-id)
                         (b-id b-id))
             (field-loop name #'a-id #'b-id merges?
                         #'(rest ...)
                         (cons #'(field get (attr ...) ...) forward)
                         (cons #'(cons 'field get) fields)
                         (cons #'(field ((merge-strategy-merge strategy) (get a-id) (get b-id)))
                               strategies)))))
        ((rest ... (field get (attr ...) ...))
         (let* ((attrs (attrs-loop merges? #'((attr ...) ...) '() #f)))
           (with-syntax ((((attr ...) ...) (car attrs))
                         (strategy (cdr attrs))
                         (a-id a-id)
                         (b-id b-id))
             (field-loop name #'a-id #'b-id merges?
                         #'(rest ...)
                         (cons #'(field get (attr ...) ...) forward)
                         (cons #'(cons 'field get) fields)
                         (cons #'(field ((merge-strategy-merge strategy) (get a-id) (get b-id)))
                               strategies)))))
        ;; (cons car (cons cadr cddr))
        (() (cons forward (cons fields strategies)))))
    (syntax-case syn ()
      ((_ name* args ...)
       (let ((name (syntax->datum #'name*)))
         (let loop ((args #'(args ...))
                    (type #f)
                    (syntactic-ctor #f)
                    (ctor #f)
                    (pred #f)
                    (this-identifier #f)
                    (fields-list #f)
                    (merge-proc #f)
                    (fold-proc #f))
           (syntax-case args ()
             ((#:type type* rest ...)
              (loop #'(rest ...)
                    #'type*
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc))
             ((#:syntactic-ctor syntactic-ctor* rest ...)
              (loop #'(rest ...)
                    type
                    #'syntactic-ctor*
                    ctor
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc))
             ((#:ctor ctor* rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    #'ctor*
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc))
             ((#:pred pred* rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    #'pred*
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc))
             ((#:this-identifier this-identifier* rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    #'this-identifier*
                    fields-list
                    merge-proc
                    fold-proc))
             ((#:fields-list fields-list* rest ...) (symbol? (syntax->datum #'fields-list*))
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    #'fields-list*
                    merge-proc
                    fold-proc))
             ((#:fields-list rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    (datum->syntax #'name* (symbol-append 'fields- name))
                    merge-proc
                    fold-proc))
             ((#:merge merge-proc* rest ...) (symbol? (syntax->datum #'merge-proc*))
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    #'merge-proc*
                    fold-proc))
             ((#:merge rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    (datum->syntax #'name* (symbol-append 'merge- name))
                    fold-proc))
             ((#:fold fold-proc* rest ...) (symbol? (syntax->datum #'fold-proc*))
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    (if merge-proc merge-proc (datum->syntax #'name* (gensym)))
                    #'fold-proc*))
             ((#:fold rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    (if merge-proc merge-proc (datum->syntax #'name* (gensym)))
                    (datum->syntax #'name* (symbol-append 'fold- name))))
             (((fields* ...) ...)
              (let* ((a-id (datum->syntax syn (gensym)))
                     (b-id (datum->syntax syn (gensym)))
                     (fields (field-loop name a-id b-id merge-proc
                                         #'((fields* ...) ...) '() '() '())))
                (with-syntax
                    ((type            (if type type
                                          (datum->syntax #'name* (symbol-append '< name '>))))
                     (syntactic-ctor  (if syntactic-ctor syntactic-ctor
                                          (datum->syntax #'name* name)))
                     (ctor            (if ctor ctor
                                          (datum->syntax #'name* (symbol-append 'make- name))))
                     (pred            (if pred pred
                                          (datum->syntax #'name* (symbol-append name '?))))
                     (this-identifier #'this-record)
                     ((fields-forward ...) (car fields))
                     ((fields ...) (cadr fields))
                     ((fields-merge ...) (cddr fields))
                     (a-id a-id)
                     (b-id b-id))
                  (let ((fields-list (if fields-list
                                         #`((define #,fields-list (list fields ...)))
                                         '()))
                        (merge-fields (if merge-proc
                                          #`((define (#,merge-proc a-id b-id)
                                               (syntactic-ctor fields-merge ...)))
                                          '()))
                        (fold-fields (if fold-proc
                                         #`((define (#,fold-proc ls)
                                              (fold #,merge-proc (syntactic-ctor) (reverse ls))))
                                         '())))

                    #`(begin
                        (define-record-type* type
                          syntactic-ctor ctor pred
                          this-identifier
                          fields-forward ...)
                        #,@fields-list
                        #,@merge-fields
                        #,@fold-fields))))))))))))
