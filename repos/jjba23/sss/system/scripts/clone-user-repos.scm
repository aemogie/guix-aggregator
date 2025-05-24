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

(use-modules (ice-9 popen)
             (ice-9 textual-ports))

(define-public (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define sss-joe-clone-repos
  '(byggsteg carvoeiro-water-fun
             cloud-infra
             dagboek.el
             free-alacarte
             git-riddance.el
             haskell-rank
             hygguile
             iter-vitae
             jointhefreeworld
             keuringsdienst
             kracht
             lucidplan
             modusregel
             orgwebalchemy
             pop-server
             pop-test
             private-notes
             pingwing
             rostob
             scala-rank
             social-media-jjba
             static-assets
             tekengrootte.el
             web-welkomscherm
             welkomscherm.el
             wikimusic
             wolk-jjba
             zzspec))

(display "\n>>= cloning personal repos...\n")

(for-each (lambda (x)
            (syscall (format #f
                             (string-join '("[ -d $HOME/hacking/~a ] || "
                                            "git clone git@codeberg.org:jjba23/~a.git $HOME/hacking/~a"))
                             x x x))) sss-joe-clone-repos)
