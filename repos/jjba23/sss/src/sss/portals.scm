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

(define-module (sss portals)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss prelude)
  #:export (portals-capability))

(define* (portals-capability #:key (portals '((default . "gnome;gtk")
                                              (org.freedesktop.impl.portal.Access . gtk)
                                              (org.freedesktop.impl.portal.Notification . gtk)
                                              (org.freedesktop.impl.portal.Secret . gnome-keyring)
                                              (org.freedesktop.impl.portal.FileChooser . gtk)
                                              (org.freedesktop.impl.portal.ScreenCast . gnome)
                                              (org.freedesktop.impl.portal.Settings . "gtk;gnome"))))
  `((".config/xdg-desktop-portal/portals.conf" ,(plain-file "portals.conf"
                                                            (string-append
                                                             "[preferred]\n"
                                                             (mk-kv-conf-lines
                                                              portals))))))

