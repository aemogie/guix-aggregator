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

sh-base-mode

(! & "#!/usr/bin/env bash" n q)

(if "if [ " p " ]" n "  then " p n "fi" q)

(ife "if [ " p " ]" n "  then " p n "else" p n "fi" q)

(cs "case " p " in" n> p " )" n> p n> ";;" n> q n "esac")

(fr "for " p " in " p n "do" n> q n "done")
