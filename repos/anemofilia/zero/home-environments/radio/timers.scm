(define-module (home-environments radio timers)
  #:use-module (radix home services shepherd)
  #:use-module (guix gexp)

  #:export (alarm remind))

(define alarm
  (shepherd-timer
   (name 'alarm)
   (event #~(calendar-event #:hours '(5) #:minutes '(0)))
   (action #~(lambda ()
               (spawn-command
                 "herd spawn transient --service-name=mpv \
                  -- mpv --shuffle ~/media/music/by-artist")))))

(define remind
  (shepherd-timer
   (name 'remind)
   (event #~(calendar-event #:hours '(5) #:minutes '(0)))
   (action #~(command "notify-send" "\"$(rem)\"" "--expire-time" "0"))))
