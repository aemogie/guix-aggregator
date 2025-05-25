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

(define-module (sss channels)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (gnu home services)
  #:use-module (gnu home services guix)
  #:use-module (guix channels)
  #:export (sss-channels-service))

(define guix-gaming-games-channel
  (channel
    (name 'guix-gaming-games)
    (url "https://gitlab.com/guix-gaming-channels/games.git")
    (introduction
     (make-channel-introduction "c23d64f1b8cc086659f8781b27ab6c7314c5cca5"
                                (openpgp-fingerprint
                                 "50F3 3E2E 5B0C 3D90 0424  ABE8 9BDC F497 A4BB CC7F")))))

(define nonguix-channel
  (channel
    (name 'nonguix)
    (url "https://gitlab.com/nonguix/nonguix")
    (introduction
     (make-channel-introduction "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                (openpgp-fingerprint
                                 "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5")))))

;; WIP
(define iter-vitae-channel
  (channel
    (name 'iter-vitae)
    (url "https://codeberg.org/jjba23/iter-vitae.git")
    (branch "trunk")
    (introduction
     (make-channel-introduction "738a940f72e9a0053272c75e550cb06b6726a5e0"
                                (openpgp-fingerprint
                                 "83BC 6E1C 8726 B8C2 97F8 D16E 24F4 6738 CE11 4AF6")))))

(define sss-channels-service
  (simple-service 'sss-channels-service home-channels-service-type
                  (list nonguix-channel guix-gaming-games-channel)))

