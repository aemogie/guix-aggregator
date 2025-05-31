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

(define-module (sss packages font)
  #:declarative? #t
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (nongnu packages fonts)
  #:export (font-packages))

(define font-packages
  (make-parameter (list font-adwaita
                        font-awesome
                        font-dejavu
                        font-fira-code
                        font-google-noto
                        font-google-noto-emoji
                        font-google-roboto
                        font-liberation
                        font-microsoft-web-core-fonts
                        fontconfig)))
