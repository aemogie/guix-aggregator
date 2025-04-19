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

(define-module (sss containers)
  #:use-module (gnu)
  #:use-module (json))

(begin
  (define* (sss-containers-svc)
    `((".config/containers/registries.conf" ,(plain-file "registries.conf"
                                              "unqualified-search-registries = [
       'docker.io',
       'registry.fedoraproject.org',
       'registry.access.redhat.com',
       'registry.centos.org']"))
      
      (".config/containers/policy.json" ,(plain-file "policy.json"
                                                     (scm->json-string `((default . #(((type . insecureAcceptAnything))))))))))
  (export sss-containers-svc))
