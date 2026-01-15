;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (rosenthal))

(define %os
  (load "default.scm"))

(operating-system
  (inherit %os)
  (services
   (modify-services (operating-system-user-services %os)
     (console-font-service-type
      _ => (map (lambda (num)
                  (let* ((path "/share/consolefonts/ter-132n")
                         (font (file-append (specification->package "font-terminus") path))
                         (tty (string-append "tty" (number->string num))))
                    (cons tty font)))
                (iota 6 1))))))
