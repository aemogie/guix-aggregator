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
            &record-merge-conflict
            append-strategy
            lines-strategy
            source-location-strategy
            &record-source-location-merge

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

(define-condition-type &record-merge-conflict &implementation-restriction
  record-merge-conflict?
  (first record-merge-conflict-first)
  (second record-merge-conflict-second))

(define conflict-strategy
  (merge-strategy
   (default *unspecified*)
   (merge (lambda (a b)
             (cond ((and (not (unspecified? a))
                         (not (unspecified? b))
                         (not (equal? a b)))
                    (raise (condition (&record-merge-conflict
                                       (first a)
                                       (second b)))))
                   ;; order doesnt matter, since we have concluded that either
                   ;; only one is unspecified or both are equal
                   ((not (unspecified? a)) a)
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

(define-condition-type &record-source-location-merge &implementation-restriction
  record-source-location-merge?)

(define source-location-strategy
  (merge-strategy
   (default #f)
   (merge (lambda (a b)
            (and (or a b)
                 (raise (condition (&record-source-location-merge))))))))

(define-syntax define-record-type2
  (lambda (syn)
    (define (attrs-loop merges? attrs-syn forward strategy default-value)
      (syntax-case attrs-syn (merge default)
        ((rest ... (merge strategy)) merges?
         (attrs-loop merges? #'(rest ...)
                     (cons #'(default (merge-strategy-default strategy)) forward)
                     #'strategy
                     #'(merge-strategy-default strategy)))
        ((rest ... (default value)) merges?
         (syntax-violation #f "default not allowed" syn #'(default value)))
        ((rest ... (default value))
         (attrs-loop merges? #'(rest ...)
                     (cons #'(default value) forward)
                     strategy
                     #'value))
        ((rest ... next)
         (attrs-loop merges? #'(rest ...)
                     (cons #'next forward)
                     strategy
                     default-value))
        (() (and merges? (not strategy))
         (syntax-violation #f "no merge strategy" syn))
        (() (list forward strategy default-value))))

    (define (field-loop name a-id b-id merges? fields-syn forward fields strategies)
      ;; (field ((merge-strategy-merge strategy) (get a-id) (get b-id)))
      (syntax-case fields-syn ()
        ((rest ... (field (attr ...) ...))
         (let* ((get (symbol-append name '- (syntax->datum #'field)))
                (attrs (attrs-loop merges? #'((attr ...) ...) '() #f #f)))
           (with-syntax ((get (datum->syntax #'field get))
                         (((attr ...) ...) (list-ref attrs 0))
                         (strategy (list-ref attrs 1))
                         (default (list-ref attrs 2))
                         (a-id a-id)
                         (b-id b-id))
             (field-loop name #'a-id #'b-id merges?
                         #'(rest ...)
                         (cons #'(field get (attr ...) ...) forward)
                         (cons (if #'default
                                   #'(list 'field get default)
                                   #'(list 'field get))
                               fields)
                         (cons #'(field ((merge-strategy-merge strategy) (get a-id) (get b-id)))
                               strategies)))))
        ((rest ... (field get (attr ...) ...))
         (let* ((attrs (attrs-loop merges? #'((attr ...) ...) '() #f #f)))
           (with-syntax ((((attr ...) ...) (list-ref attrs 0))
                         (strategy (list-ref attrs 1))
                         (default (list-ref attrs 2))
                         (a-id a-id)
                         (b-id b-id))
             (field-loop name #'a-id #'b-id merges?
                         #'(rest ...)
                         (cons #'(field get (attr ...) ...) forward)
                         (cons (if #'default
                                   #'(list 'field get default)
                                   #'(list 'field get))
                               fields)
                         (cons #'(field ((merge-strategy-merge strategy) (get a-id) (get b-id)))
                               strategies)))))
        (() (list forward fields strategies))))
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
                    (fold-proc #f)
                    (unwrap #f))
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
                    fold-proc
                    unwrap))
             ((#:syntactic-ctor syntactic-ctor* rest ...)
              (loop #'(rest ...)
                    type
                    #'syntactic-ctor*
                    ctor
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc
                    unwrap))
             ((#:ctor ctor* rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    #'ctor*
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc
                    unwrap))
             ((#:pred pred* rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    #'pred*
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc
                    unwrap))
             ((#:this-identifier this-identifier* rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    #'this-identifier*
                    fields-list
                    merge-proc
                    fold-proc
                    unwrap))
             ((#:fields-list fields-list* rest ...) (symbol? (syntax->datum #'fields-list*))
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    #'fields-list*
                    merge-proc
                    fold-proc
                    unwrap))
             ((#:fields-list rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    (datum->syntax #'name* (symbol-append 'fields- name))
                    merge-proc
                    fold-proc
                    unwrap))
             ((#:merge merge-proc* rest ...) (symbol? (syntax->datum #'merge-proc*))
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    #'merge-proc*
                    fold-proc
                    unwrap))
             ((#:merge rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    (datum->syntax #'name* (symbol-append 'merge- name))
                    fold-proc
                    unwrap))
             ((#:fold fold-proc* rest ...) (symbol? (syntax->datum #'fold-proc*))
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    #'fold-proc*
                    unwrap))
             ((#:fold rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    (datum->syntax #'name* (symbol-append 'fold- name))
                    unwrap))
             ((#:unwrap (config ...) rest ...)
              (loop #'(rest ...)
                    type
                    syntactic-ctor
                    ctor
                    pred
                    this-identifier
                    fields-list
                    merge-proc
                    fold-proc
                    (syntax-case #'(config ...) ()
                      ((type default)
                       (list (datum->syntax #'name* (symbol-append 'unwrap- name))
                             #'type #'default))
                      ((name type default)
                       (list #'name #'type #'default)))))
             (((fields* ...) ...)
              (let* ((a-id (datum->syntax syn (gensym)))
                     (b-id (datum->syntax syn (gensym)))
                     (fields (field-loop name a-id b-id (or merge-proc fold-proc)
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
                     (source-location-get (datum->syntax #'name*
                                                         (symbol-append name '-source-location)))
                     ((fields-forward ...) (list-ref fields 0))
                     ((fields ...) (list-ref fields 1))
                     ((fields-merge ...) (list-ref fields 2))
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
                                              (fold (lambda (b-id a-id) ;; reverse
                                                      (syntactic-ctor fields-merge ...))
                                                    (syntactic-ctor)
                                                    ls)))
                                         '()))
                        (unwrap-fields
                         (if unwrap
                             (with-syntax ((unwrap-proc (list-ref unwrap 0))
                                           (wrapped-type (list-ref unwrap 1))
                                           (wrapped-base (list-ref unwrap 2)))
                               #'((define (unwrap-proc self)
                                    ;; to not depend on `#:fields-list`
                                    (define fields-list (list fields ...))
                                    (define rtd wrapped-type)
                                    (define rtd-base wrapped-base)
                                    (apply (record-type-constructor rtd)
                                           (map (lambda (field-name)
                                                  (let* ((field (assoc-ref fields-list
                                                                           field-name))
                                                         (get (list-ref field 0))
                                                         (value (get self))
                                                         (unset? (and (= 2 (length field))
                                                                      (eq? value
                                                                           (list-ref field 1)))))
                                                    (if unset?
                                                        ((record-accessor rtd field-name) rtd-base)
                                                        value)))
                                                (record-type-fields rtd))))))
                             '())))

                    #`(begin
                        (define-record-type* type
                          syntactic-ctor ctor pred
                          this-identifier
                          fields-forward ...)
                        #,@fields-list
                        #,@merge-fields
                        #,@fold-fields
                        #,@unwrap-fields))))))))))))
