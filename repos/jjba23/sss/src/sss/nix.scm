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

(define-module (sss nix)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss process))

(begin
  (define* (sss-nix-svc)
    `((".config/nix/nix.conf" ,(plain-file "nix.conf"
                                           (mk-rec-kv-conf-lines `((experimental-features . "nix-command flakes"))
                                            #:template spaced-equal-conf-pair)))
      
      (".config/nixpkgs/config.nix" ,(plain-file "nixpkgs.nix"
                                                 "\n{\nallowUnfree = true;\n}\n"))))
  (export sss-nix-svc))
