(define-module (home-environments radio timers)
  #:use-module (radix home services shepherd)
  #:use-module (guix gexp)

  #:export (alarm))

(define alarm
  (shepherd-timer
   (name 'alarm)
   (event #~(calendar-event #:hours '(5) #:minutes '(0)))
   (action #~(lambda ()
               (spawn-shell-command
                 "notify-send \"$(rem)\" --expire-time 0; \
                  herd spawn transient \
                             --environment-variable=WAYLAND_DISPLAY=wayland-1 \
                             --service-name=kew \
                             -- foot kew all")))))
