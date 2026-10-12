(define-module (operating-systems buer rules)
  #:use-module (gnu services admin)
  #:use-module (radix utils)
  #:export (general
            text-editors
            power-management
            service-management))

(define general
  (list (opendoas-permit-rule
          (identity ":wheel")
          (setenv
            `(("GUILE_LOAD_PATH" . #t)
              ("GUILE_LOAD_COMPILED_PATH" . #t)
              ("TERM" . "linux"))))))

(define text-editors
  (list (opendoas-permit-rule
          (identity ":wheel")
          (keepenv? #t)
          (command "kak"))))

(define power-management
  (map (lambda (cmd)
         (opendoas-permit-rule
           (identity ":wheel")
           (nopass? #t)
           (command cmd)
           (args '())))
       `("zzz" "halt" "reboot")))

(define service-management
  (append (map (lambda (action)
                 (opendoas-permit-rule
                   (identity ":wheel")
                   (nopass? #t)
                   (command "herd")
                   (args (list action))))
               `("status" "detailed-status"))
          (map (lambda (action)
                 (opendoas-permit-rule
                   (identity ":wheel")
                   (nopass? #t)
                   (command "herd")
                   (args `(,action "snapshot-/home"))))
               `("doc" "status" "trigger"))
          (map (lambda (action)
                 (opendoas-permit-rule
                   (identity ":wheel")
                   (nopass? #t)
                   (command "herd")
                   (args `(,action "iwd"))))
               `("start" "stop" "restart" "status" "enable" "disable" "doc"))))
