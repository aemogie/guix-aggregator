(define-module (operating-systems buer rules)
  #:use-module (radix services admin)
  #:use-module (radix utils)
  #:export (general
            text-editors
            power-management
            service-management))

(define general
  (list (permit (identity ":wheel")
                (setenv
                  `(("GUILE_LOAD_PATH" . #t)
                    ("GUILE_LOAD_COMPILED_PATH" . #t)
                    ("TERM" . "linux"))))))

(define text-editors
  (list (permit (identity ":wheel")
                 (keepenv? #t)
                 (command "kak"))))

(define power-management
  (map (lambda (cmd)
         (permit (identity ":wheel")
                 (nopass? #t)
                 (command cmd)
                 (args '())))
       `("zzz" "halt" "reboot")))

(define service-management
  (append (map (lambda (action)
                 (permit (identity ":wheel")
                         (nopass? #t)
                         (command "herd")
                         (args (list action))))
               `("status" "detailed-status"))
          (map (lambda (action)
                 (permit (identity ":wheel")
                         (nopass? #t)
                         (command "herd")
                         (args `(,action "snapshot-/home"))))
               `("doc" "status" "trigger"))
          (map (lambda (action)
                 (permit (identity ":wheel")
                         (nopass? #t)
                         (command "herd")
                         (args `(,action "iwd"))))
               `("start" "stop" "restart" "status" "enable" "disable" "doc"))))
