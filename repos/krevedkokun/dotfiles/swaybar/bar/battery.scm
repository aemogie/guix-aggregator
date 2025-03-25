(define-module (bar battery)
  #:use-module (d-bus protocol connections)
  #:use-module (d-bus protocol messages)
  #:use-module (d-bus protocol signatures)
  #:use-module (srfi srfi-43))

(define-syntax-rule (comment _ ...) #f)

(define* (mk-msg #:key path dest sig interface member body)
  (let* ((headers (list
                   (and path (header-PATH path))
                   (and dest (header-DESTINATION dest))
                   (and interface (header-INTERFACE interface))
                   (and sig (header-SIGNATURE sig))
                   (and member (header-MEMBER member))))
         (headers (filter identity headers))
         (headers (list->vector headers)))
    (make-d-bus-message MESSAGE_TYPE_METHOD_CALL 0 #f '() headers body)))

(define (read-msg bus serial)
  (let* ((msg (d-bus-read-message bus))
         (headers (d-bus-message-headers msg))
         (reply-serial (d-bus-headers-ref headers 'REPLY_SERIAL)))
    (if (eqv? serial reply-serial) msg (read-msg bus serial))))

(define (hello bus)
  (let ((msg (mk-msg #:path "/org/freedesktop/DBus"
                     #:dest "org.freedesktop.DBus"
                     #:interface "org.freedesktop.DBus"
                     #:member "Hello")))
    (d-bus-write-message bus msg)))

(define (enumerate-devs bus)
  (let ((msg (mk-msg #:path "/org/freedesktop/UPower"
                     #:dest "org.freedesktop.UPower"
                     #:interface "org.freedesktop.UPower"
                     #:member "EnumerateDevices")))
    (d-bus-write-message bus msg)))

(define (read-property bus path prop)
  (let ((msg (mk-msg #:path path
                     #:dest "org.freedesktop.UPower"
                     #:interface "org.freedesktop.DBus.Properties"
                     #:member "Get"
                     #:sig "ss"
                     #:body (list "org.freedesktop.UPower.Device" prop))))
    (d-bus-write-message bus msg)))

(define (read-properties bus path)
  (let ((msg (mk-msg #:path path
                     #:dest "org.freedesktop.UPower"
                     #:interface "org.freedesktop.DBus.Properties"
                     #:member "GetAll"
                     #:sig "s"
                     #:body '("org.freedesktop.UPower.Device"))))
    (d-bus-write-message bus msg)))

(comment
 (use-modules (ice-9 pretty-print))
 (define dbus (d-bus-connect (d-bus-system-bus-address)))
 (hello dbus)
 (enumerate-devs dbus)
 (read-property dbus "/org/freedesktop/UPower/devices/battery_BAT1" "Percentage")
 (read-properties dbus "/org/freedesktop/UPower/devices/battery_BAT1")
 (read-properties dbus "/org/freedesktop/UPower/devices/keyboard_dev_F4_ED_CD_A0_C4_BE")
 (pretty-print
  (vector->list (car (d-bus-message-body (read-msg dbus 18)))))


 )
