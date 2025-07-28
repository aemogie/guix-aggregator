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

scheme-mode

(package...
 "(define-public " (s name)
 n> "(package"
 n  > "(name \"" (s name) "\")"
 n  > "(version \"" p "\")"
 n  > "(source origin...)"
 n  > "(build-system " (p "gnu") "-build-system)"
 n  > "(home-page \"" p "\")"
 n  > "(synopsis \"" p "\")"
 n  > "(description \"" p "\")"
 n  > "(license license:" (p "unknown") ")))" n)

(origin...
 "(origin"
 n> "(method " (p "url-fetch" method) ")"
 n> "(uri " (cl-case (and method (intern method))
              (git-fetch "git-reference...")
              (svn-fetch "svn-reference...")
              (hg-fetch  "hg-reference...")
              (cvs-fetch "cvs-reference...")
              (bzr-fetch "bzr-reference...")
              (otherwise "\"https://...\""))
 ")"
 n>
 (cl-case (and method (intern method))
   (git-fetch
    (insert "(file-name (git-file-name name version))")
    (newline)
    (indent-according-to-mode))
   (hg-fetch
    (insert "(file-name (hg-file-name name version))")
    (newline)
    (indent-according-to-mode))
   (svn-fetch
    (insert "(file-name (string-append name \"-\" version \"-checkout\"))")
    (newline)
    (indent-according-to-mode))
   (cvs-fetch
    (insert "(file-name (string-append name \"-\" version \"-checkout\"))")
    (newline)
    (indent-according-to-mode))
   (bzr-fetch
    (insert "(file-name (string-append name \"-\" version \"-checkout\"))")
    (newline)
    (indent-according-to-mode))
   (t          ""))
 > "(sha256"
 n > "(base32 \""
 ;; hash of an empty directory
 (p "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5") "\")))")

(git-reference...
 "(git-reference"
 n> "(url \"" p "\")"
 n> "(commit " (p "commit") "))")

(svn-reference...
 "(svn-reference"
 n> "(url \"" p "\")"
 n> "(revision " (p "revision") "))")

(cvs-reference...
 "(cvs-reference"
 n> "(root-directory \"" p "\")"
 n> "(module \"" p "\")"
 n> "(revision \"" p "\"))")

(hg-reference...
 "(hg-reference"
 n> "(url \"" p "\")"
 n> "(changeset " (p "changeset") "))")

(bzr-reference...
 "(bzr-reference"
 n> "(url \"" p "\")"
 n> "(revision " (p "revision") "))")

(:phases\ "#:phases (modify-phases %standard-phases"
          n> p ")")
(:phases~\ "#:phases"
           n> "#~(modify-phases %standard-phases"
           n> p ")")

(add-before\ "(add-before '" (p "next") " '" (p "previous")
             n > p ")")
(add-after\ "(add-after '" (p "previous") " '" (p "next")
            n > p ")")
(replace\ "(replace '" (p "old") " " p ")")
