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

rust-mode rust-ts-mode

(if "if " p " {" n> q n "}" > q)

(el "if " p " {" n> p n "} else {" >n> p n "}" > q)

(elif "if " p " {" n> p n "} else if " p " {" >n> p n "}" > q)

(fn "fn " p "(" p ") {" n> p n "}" q)

(fnr "fn " p "(" p ") -> " p " {" n> p n "}" q)

(crt "extern crate " q ";")

(drv & "#[derive(" p ")]" q)

(d "dbg!(" p ")" q)

(lp "loop {" n> q n "}" > q)
