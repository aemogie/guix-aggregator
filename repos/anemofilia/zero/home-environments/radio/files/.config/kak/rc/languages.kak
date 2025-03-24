#|Highlighters|#
hook global BufOpenFile .* %{
  add-highlighter buffer/ wrap -word -marker '↩'
  add-highlighter buffer/ show-whitespaces -indent '' -tab '→'
}

#|Language Server Protocol|#
try %{ eval %sh{kak-lsp} }
hook global WinSetOption filetype=(c|cpp|css|haskell|html|json|scheme|sh|typst|latex|zig) %{
  set-option window lsp_snippet_support false
  set-option window lsp_hover_max_lines 20
  lsp-enable-window
  lsp-auto-signature-help-enable
  lsp-auto-hover-insert-mode-disable
}
map global user l ': enter-user-mode lsp<ret>' \
  -docstring 'enter lsp user mode'

#|Comments|#
map global user c ': comment-line<ret>' \
  -docstring 'comment-line'

map global user C ': comment-block<ret>' \
  -docstring 'comment-block'

#|Auto pairs|#
evaluate-commands enable-auto-pairs

#|Rainbow delimiters|#
set-option global rainbow_mode 0
set-option global background_rainbow_colors \
  "rgb:000000" "rgb:000000" "rgb:000000" \
  "rgb:000000" "rgb:000000" "rgb:000000"

set-option global rainbow_colors \
  "rgb:a790d3" "rgb:ff7f50" "rgb:6cdae0" \
  "rgb:ffea8c" "rgb:eba4d4" "rgb:83dcaf"

#|Language specific settings|#
source "%val{config}/rc/languages/c.kak"
source "%val{config}/rc/languages/cpp.kak"
source "%val{config}/rc/languages/hs.kak"
source "%val{config}/rc/languages/kak.kak"
source "%val{config}/rc/languages/scm.kak"
source "%val{config}/rc/languages/sh.kak"
source "%val{config}/rc/languages/tex.kak"
source "%val{config}/rc/languages/typ.kak"
source "%val{config}/rc/languages/zig.kak"
