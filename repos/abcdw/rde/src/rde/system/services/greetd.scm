;;; rde --- Reproducible development environment.
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;; SPDX-FileCopyrightText: 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde system services greetd)
  #:use-module (gnu services)
  #:use-module ((gnu services base)
                #:select (greetd-configuration
                          greetd-terminal-configuration
                          greetd-user-session
                          greetd-agreety-session
                          greetd-gtkgreet-sway-session))
  #:use-module ((gnu services base) #:prefix upstream:)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (srfi srfi-1)
  #:export (greetd-service-type
            greetd-greeter-service-type
            greetd-greeter-configuration
            greetd-greeter-configuration?
            greetd-greeter-configuration-terminal
            greetd-greeter-configuration-make-greeter-command
            greetd-greeter-configuration-sessions
            greetd-login-session
            greetd-login-session?
            greetd-login-session-name
            greetd-login-session-command
            greetd-login-session-command-args
            greetd-login-session-extra-env
            greetd-login-session-xdg-session-type
            greetd-login-session-xdg-env?
            greetd-login-session-with-dbus
            make-gtkgreet-greeter-command)
  #:re-export (greetd-configuration
               greetd-terminal-configuration
               greetd-user-session
               greetd-agreety-session
               greetd-gtkgreet-sway-session))


;;;
;;; Extensible greetd.
;;;

(define upstream-greetd-terminals
  (record-accessor
   (record-type-descriptor (greetd-configuration))
   'terminals))

(define (extend-greetd-configuration config terminals)
  (greetd-configuration
   (inherit config)
   (terminals (append (upstream-greetd-terminals config) terminals))))

(define greetd-service-type
  (service-type
   (inherit upstream:greetd-service-type)
   (compose concatenate)
   (extend extend-greetd-configuration)))


;;;
;;; Generic graphical greeter.
;;;

;; The wrapper around greetd-user-session with extra name field
(define-record-type* <greetd-login-session>
  greetd-login-session make-greetd-login-session greetd-login-session?
  (name greetd-login-session-name)
  (command greetd-login-session-command)
  (command-args greetd-login-session-command-args (default '()))
  (extra-env greetd-login-session-extra-env (default '()))
  (xdg-session-type greetd-login-session-xdg-session-type (default "wayland"))
  (xdg-env? greetd-login-session-xdg-env? (default #t)))

(define (greetd-login-session-path session)
  (string-append "/etc/greetd/sessions/" (greetd-login-session-name session)))

(define (greetd-login-session-command-file session)
  (greetd-user-session
   (command (greetd-login-session-command session))
   (command-args (greetd-login-session-command-args session))
   (extra-env (greetd-login-session-extra-env session))
   (xdg-session-type (greetd-login-session-xdg-session-type session))
   (xdg-env? (greetd-login-session-xdg-env? session))))

(define (greetd-login-session-with-dbus session dbus)
  "Return SESSION wrapped in @command{dbus-run-session} from DBUS package."
  (let* ((session-name (greetd-login-session-name session))
         (command (greetd-login-session-command session))
         (command-args (greetd-login-session-command-args session))
         (dbus-run-session (file-append dbus "/bin/dbus-run-session"))
         (session-wrapper
          (program-file
           (format #f "~a-with-dbus" session-name)
           #~(apply execl #$dbus-run-session #$dbus-run-session
                    (append (list "--" #$command)
                            (list #$@command-args))))))
    (greetd-login-session
     (inherit session)
     (command session-wrapper)
     (command-args '()))))

(define (greetd-greeter-environments-file sessions)
  (if (null? sessions)
      (plain-file "greetd-environments" "")
      (apply mixed-text-file
             "greetd-environments"
             (append-map (lambda (session)
                           (list (greetd-login-session-path session) "\n"))
                         sessions))))

(define (make-gtkgreet-greeter-command session-paths)
  (greetd-gtkgreet-sway-session
   (command (if (null? session-paths)
                (greetd-user-session)
                (car session-paths)))))

(define-record-type* <greetd-greeter-configuration>
  greetd-greeter-configuration make-greetd-greeter-configuration
  greetd-greeter-configuration?
  (terminal greetd-greeter-configuration-terminal
            (default (greetd-terminal-configuration
                       (terminal-vt "7")
                       (terminal-switch #t))))
  (make-greeter-command greetd-greeter-configuration-make-greeter-command
                        (default make-gtkgreet-greeter-command))
  (sessions greetd-greeter-configuration-sessions (default '())))

(define (greetd-greeter-greetd-extension config)
  (let* ((terminal (greetd-greeter-configuration-terminal config))
         (sessions (greetd-greeter-configuration-sessions config))
         (session-paths (map greetd-login-session-path sessions))
         (make-greeter-command
          (greetd-greeter-configuration-make-greeter-command config)))
    (list
     (greetd-terminal-configuration
      (inherit terminal)
      (default-session-command (make-greeter-command session-paths))))))

(define (greetd-greeter-etc-service config)
  (let ((sessions (greetd-greeter-configuration-sessions config)))
    `(("greetd/environments"
       ,(greetd-greeter-environments-file sessions))
      ,@(map (lambda (session)
               `(,(string-append "greetd/sessions/"
                                 (greetd-login-session-name session))
                 ,(greetd-login-session-command-file session)))
             sessions))))

(define (extend-greetd-greeter-configuration config sessions)
  (greetd-greeter-configuration
   (inherit config)
   (sessions (append (greetd-greeter-configuration-sessions config)
                     sessions))))

(define greetd-greeter-service-type
  (service-type
   (name 'greetd-greeter)
   (extensions
    (list (service-extension greetd-service-type
                             greetd-greeter-greetd-extension)
          (service-extension etc-service-type
                             greetd-greeter-etc-service)))
   (compose concatenate)
   (extend extend-greetd-greeter-configuration)
   (default-value (greetd-greeter-configuration))
   (description "\
Configure a graphical greetd greeter terminal and provide selectable login
sessions.")))
