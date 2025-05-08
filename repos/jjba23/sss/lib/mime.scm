;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

(define-module (sss mime)
  #:use-module (gnu))

;; SSS implementation of the XDG mimeapps standard
;;
;; The XDG MIME Applications specification builds upon the shared MIME database and desktop entries to provide default applications.
;; Added Associations indicates that the applications support opening that MIME type.
;; For example:
;; bar.desktop and baz.desktop can open JPEG images.
;; This might affect the application list you see when right-clicking a file in a file browser.
;;
;; Removed Associations indicates that the applications do not support that MIME type.
;; For example, baz.desktop cannot open H.264 video.
;;
;; Default Applications indicates that the applications should be the default choice for opening that MIME type.
;; For example, JPEG images should be opened with foo.desktop. This implicitly adds an association between the application and the MIME type.
;; If there are multiple applications, they are tried in order.

(define-public sss-mime-added-associations
  '())

(define-public sss-mime-removed-associations
  '())

(define-public sss-mime-default-applications
  '((application/pdf org.gnome.Evince firefox google-chrome-beta)
    (text/html firefox google-chrome-beta emacsclient)
    (text/plain emacsclient geany)
    (text/xml emacsclient geany)
    (x-scheme-handler/http firefox google-chrome-beta)
    (x-scheme-handler/https firefox google-chrome-beta)
    (image/png org.gnome.gThumb firefox google-chrome-beta feh)
    (image/jpg org.gnome.gThumb firefox google-chrome-beta feh)
    (image/jpeg org.gnome.gThumb firefox google-chrome-beta feh)))

(begin
  (define (make-mime-row r)
    (format #f "~a=~a"
            (car r)
            (string-join (map (lambda (y)
                                (format #f "~a.desktop" y))
                              (cdr r)) ";")))

  (define (mime-renderer xs)
    (string-join (map (lambda (x)
                        (make-mime-row x)) xs) "\n"))

  (define* (sss-mimeapps-list-file #:key (added-associations '())
                                   (removed-associations '())
                                   (default-applications '()))
    (string-join `("[Added Associations]" ,(mime-renderer added-associations)
                   "[Removed Associations]"
                   ,(mime-renderer removed-associations)
                   "[Default Applications]"
                   ,(mime-renderer default-applications)) "\n"))
  (export sss-mimeapps-list-file))

(begin
  (define* (sss-mime-svc #:key (added-associations sss-mime-added-associations)
                         (removed-associations sss-mime-removed-associations)
                         (default-applications sss-mime-default-applications))
    `((".config/mimeapps.list" ,(plain-file "mimeapps.list"
                                            (sss-mimeapps-list-file
                                             #:added-associations
                                             added-associations
                                             #:removed-associations
                                             removed-associations
                                             #:default-applications
                                             default-applications)))))
  (export sss-mime-svc))
