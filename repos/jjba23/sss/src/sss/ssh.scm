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

(define-module (sss ssh)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (gnu home services ssh))

(define joe-ssh-hosts
  (list (openssh-host (name "wolk-jjba")
                      (user "joe")
                      (host-name "37.60.232.48")
                      (port 2323)
                      (identity-file "~/.ssh/wolk-jjba"))
        (openssh-host (name "personal.github.com")
                      (user "joe")
                      (host-name "github.com")
                      (identity-file "~/.ssh/gitlab_prive"))
        (openssh-host (name "gitlab.com")
                      (user "joe")
                      (host-name "gitlab.com")
                      (identity-file "~/.ssh/gitlab_prive"))
        (openssh-host (name "codeberg.org")
                      (user "joe")
                      (host-name "codeberg.org")
                      (identity-file "~/.ssh/gitlab_prive"))
        (openssh-host (name "work.github.com")
                      (user "joe")
                      (host-name "github.com")
                      (identity-file "~/.ssh/work_id"))))

;; Define a SSH configuration service for a SSS user
(begin
  (define* (sss-ssh-service #:key (hosts joe-ssh-hosts)
                            (authorized-keys '()))
    (service home-openssh-service-type
             (home-openssh-configuration (hosts hosts)
                                         (authorized-keys authorized-keys))))
  (export sss-ssh-service))
