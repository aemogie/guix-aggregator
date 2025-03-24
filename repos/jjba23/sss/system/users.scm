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

(use-modules (gnu)
             (guix)
             (gnu system privilege)
             (gnu services)
             (guix packages))

(use-package-modules shells)

;; User account for Josep Bigorra
(define sss-joe-user-account
  (user-account
    (name "joe")
    (group "users")
    (supplementary-groups '("wheel" "netdev" "audio" "video" "input" "libvirt"))
    (comment "Josep Bigorra's account")
    (home-directory "/home/joe")))

;; User account for Manon van den Bout
(define sss-manon-user-account
  (user-account
    (name "manon")
    (group "users")
    (supplementary-groups '("wheel" "netdev" "audio" "video" "input" "libvirt"))
    (comment "Manon van den Bout's account")
    (home-directory "/home/manon")))

(define-public sss-users
  (cons* sss-joe-user-account sss-manon-user-account %base-user-accounts))
