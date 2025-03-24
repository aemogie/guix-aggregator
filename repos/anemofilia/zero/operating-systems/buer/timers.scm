(define-module (operating-systems buer timers)
  #:use-module (radix services shepherd)
  #:use-module (guix gexp)

  #:export (guix-gc))

(define guix-gc
  (shepherd-timer
   (name 'guix-gc)
   (event #~(calendar-event #:hours '(6) #:minutes '(0)))
   (action #~(command '("guix" ("gc" "-F" "20G"))))))
