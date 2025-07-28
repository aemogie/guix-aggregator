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

js-base-mode typescript-ts-base-mode

(if "if (" p ") {" n> q n "}" >)
(el "if (" p ") {" n> p n "} else { " > n> q n "}" >)
(elif "else if (" p ") {" n> q n "}" >)
(else "else {" n> q n "}" >)
(cop "( " p ") ? " p " : " q";")

(switch "switch (" p ") {" n> "case " p ":" n> p n> "default:" n> q n "}" >)
(case "case " p ":" n> q)

(while "while (" p ") {" n> q n "}" >)
(dowhile "do {" n> p n> "} while (" q ");")

(for "for (" p "; " p "; " p ") {" n> q n "}" >)
(fin "for (" p " in " p ") {" n> q n "}" >)
(fof "for (" p " of " p ") {" n> q n "}" >)

(func "function " p "(" p ") {" n> q n "}" >)
(fexp "let " p " = function(" p ") {" n> q n "};" >)

(imp "import {" p "} from \"" q "\";")
(impas "import {" p " as " p "} from \"" q "\";")
