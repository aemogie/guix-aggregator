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

(define-module (sss git)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss prelude)
  #:export (gitignore-global gitconfig-personal gitconfig-work gitconfig
                             git-capability))

(define gitignore-global
  `("bloop" ".bloop"
    ".metals"
    ".stack-work"
    "target"
    "metals.sbt"
    ".direnv"
    "dist-newstyle"))

(define gitconfig-personal
  `((user (name . "Josep Bigorra")
          (email . "jjbigorra@gmail.com")
          (signingkey . "24F46738CE114AF6"))))

(define gitconfig-work
  `((user (name . "Josep Bigorra")
          (email . "josepbigorraalgaba@vandebron.nl")
          (signingkey . "3B6D20502E380697"))))

(define gitconfig
  `((core (editor . "emacsclient")
          (excludesfile . "~/.gitignore-global"))
    (commit (gpgsign . "true"))
    (format (thread . "shallow"))
    (sendemail (thread . "no"))
    (pull (rebase . "false"))
    ("includeIf \"gitdir:~/work/\"" ("  path" . "~/.gitconfig-work"))
    ("includeIf \"gitdir:~/hacking/\"" ("  path" . "~/.gitconfig-personal"))
    ("includeIf \"gitdir:~/fork/\"" ("  path" . "~/.gitconfig-personal"))
    ("includeIf \"gitdir:~/scratch/\"" ("  path" . "~/.gitconfig-personal"))))

(define* (git-capability #:key (gitconfig gitconfig)
                         (gitconfig-personal gitconfig-personal)
                         (gitconfig-work gitconfig-work)
                         (gitignore-global gitignore-global))
  `( ;Global Git configuration
     (".gitconfig" ,(plain-file "gitconfig.ini"
                                (mk-rec-kv-conf-lines gitconfig
                                                      #:template
                                                      spaced-equal-conf-pair)))
    ;; Personal Git configuration
    (".gitconfig-personal" ,(plain-file "gitconfig-personal.ini"
                                        (mk-rec-kv-conf-lines
                                         gitconfig-personal
                                         #:template spaced-equal-conf-pair)))
    ;; Work Git configuration
    (".gitconfig-work" ,(plain-file "gitconfig-work.ini"
                                    (mk-rec-kv-conf-lines gitconfig-work
                                     #:template spaced-equal-conf-pair)))

    ;; Global Git ignore
    (".gitignore-global" ,(plain-file "gitignore-global"
                                      (mk-lines gitignore-global)))))

