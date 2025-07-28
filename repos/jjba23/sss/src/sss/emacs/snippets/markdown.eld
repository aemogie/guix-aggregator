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

markdown-mode

(gitcollapse & "## " (p "Heading") n n "<details>" n n
             "<summary>" (p "Sub Heading")  "</summary>" n n
             (r "Insert Link or comments") n n "</details>")
(bolditalics "***" p "***")
(srcblock (call-interactively #'markdown-insert-gfm-code-block))
(src "'" p "'")
(unorderlist & "- " (p "First") n> "- " (p "Second") n> "- " (p "Third"))
(orderlist & "1. " (p "First") n> "2. " (p "Second") n> "3. " (p "Third"))
(insertimage (call-interactively #'markdown-insert-image))
(insertlink (call-interactively #'markdown-insert-link))
(hugotitle & "+++" n "title = " (p "title") n "date = " (format-time-string "%Y-%m-%d") n "tags = [ " (p "tag1, tag2 ") "]" n "draft = false" n "+++")
(h1 & "# " p " #")
(h2 & "## " p " ##")
(h3 & "### " p " ###")
(h4 & "#### " p " ####")
(inserttable (call-interactively #'markdown-insert-table))
