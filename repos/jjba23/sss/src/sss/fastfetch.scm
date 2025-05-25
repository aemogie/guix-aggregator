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

(define-module (sss fastfetch)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (json)
  #:use-module (ice-9 string-fun)
  #:use-module (sss process)
  #:export (sss-fastfetch-conf sss-fastfetch-svc))

(define* (sss-fastfetch-conf #:key clone-dir)
  `(($schema . "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json")
    (logo . "GNU")
    (modules . #(title separator os host kernel uptime packages shell display wm wmtheme theme icons terminal cpu gpu memory disk battery locale break colors))))

(define* (sss-fastfetch-svc #:key clone-dir)
  `((".config/fastfetch/config.jsonc" ,(plain-file "config.jsonc"
                                                   (scm->json-string (sss-fastfetch-conf
                                                                      #:clone-dir
                                                                      clone-dir)
                                                                     #:pretty
                                                                     #t)))))

