
;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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

(load "./palette.scm")

(define-module (sss labwc)
  #:use-module (gnu)
  #:use-module (sss palette))

(define-public labwc-rc
  (local-file "./labwc/rc.xml"))
(define-public labwc-menu
  (local-file "./labwc/menu.xml"))

(begin
  (define* (labwc-autostart #:key (extra-startups '()))
    (plain-file "autostart"
                (string-join (append extra-startups
                                     '("lxsession >/dev/null 2>&1 &"
                                       "mako >/dev/null 2>&1 &"
                                       "dbus-update-activation-environment --all >/dev/null 2>&1 &"
                                       "transmission-daemon >/dev/null 2>&1 &"
                                       "waybar >/dev/null 2>&1 &"
                                       "swww-daemon >/dev/null 2>&1 &"
                                       "sleep 1 && swww img $HOME/Ontwikkeling/Persoonlijk/sss/resources/wallpapers/h2mp9dpdlpee1.jpeg --transition-step 10 --transition-fps 30 --transition-type center >/dev/null 2>&1 &"))
                             "\n")))

  (export labwc-autostart))

(begin
  (define* (sss-labwc-svc #:key extra-startups)
    `((".config/labwc/rc.xml" ,labwc-rc)
      (".config/labwc/menu.xml" ,labwc-menu)
      (".config/labwc/autostart" ,(labwc-autostart #:extra-startups
                                                   extra-startups))))
  (export sss-labwc-svc))
