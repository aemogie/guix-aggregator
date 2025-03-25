#!/usr/bin/env -S guile \\
-e main -s
!#
(use-modules
 (fibers channels)
 (fibers operations)
 (fibers timers)
 (fibers)
 (ice-9 hash-table)
 (ice-9 match)
 (srfi srfi-180)
 (srfi srfi-197))

(define-syntax-rule (comment _ ...) #f)

(use-modules (d-bus protocol connections))

(define dbus
  (chain (d-bus-system-bus-address)
    (d-bus-connect _)
    (make-parameter _)))

(define (make-header)
  `((version 1)))

(define* (make-block #:key name full-text)
  `((name . ,name)
    (full_text . ,full-text)))

(define (push ch proc delay)
  (lambda ()
    (while #t
      (put-message ch (proc))
      (sleep delay))))

(define (time-data)
  (lambda ()
    (let ((time (strftime "%T" (localtime (current-time)))))
      `(time . ,time))))

(define (increment-data)
  (let ((n 0))
    (lambda ()
      (set! n (1+ n))
      `(increment . ,n))))

(use-modules (bar battery))

(define (battery-data)
  (let ((percentage ))
    `(battery . ,percentage)))

(define (main . args)
  (run-fibers
   (lambda ()
     (let ((ch (make-channel))
           (acc (make-hash-table)))
       (spawn-fiber (push ch (increment-data) 30))
       (spawn-fiber (push ch (time-data) 1))
       (while #t
         (match-let (((name . val) (get-message ch)))
           (hash-set! acc name val)
           (chain acc
             (hash-fold (lambda (k v acc)
                          (let ((k (symbol->string k)))
                            (cons (make-block #:name k #:full-text v) acc)))
                        '()
                        _)
             (list->vector _)
             (json-write _))
           (newline)))))))

(comment
 (main)

 )

;; Local Variables:
;; eval: (put 'while 'scheme-indent-function 'defun)
;; eval: (put 'chain 'scheme-indent-function 'defun)
;; End:
