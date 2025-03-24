(define-module (misako operating-systems base opendoas)
  #:use-module (radix services admin)
  #:use-module (radix utils)
  #:export (general
            power-management
            service-management))

(define general
  (list
    (permit
      (identity ":wheel")
      (setenv `(("GUILE_LOAD_PATH" . #t)
                ("SSL_CERT_FILE" . #t)
                ("SSL_CERT_DIR" . #t)))
      (persist? #t))))

(define power-management
  (map (lambda (cmd)
         (permit
           (identity ":wheel")
           (command cmd)
           (nopass? #t)
           (args '())))
       `("halt" "reboot")))

(define service-management
  (append
    (map (lambda (action)
           (permit
             (identity ":wheel")
             (nopass? #t)
             (command "herd")
             (args (list action))))
         `("status" "detailed-status"))
    (flat-map (lambda (service action)
                (permit
                  (identity ":wheel")
                  (nopass? #t)
                  (command "herd")
                  (args (map symbol->string
                             (list action service)))))
              '(networking)
              '(restart status))))
