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

(define-module (sss openpgp)
  #:use-module (gnu)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu home services gnupg))

(define-public sss-openpgp-conf
  (service home-gpg-agent-service-type
           (home-gpg-agent-configuration (pinentry-program (file-append
                                                            pinentry-emacs
                                                            "/bin/pinentry-emacs"))
                                         (ssh-support? #t))))
