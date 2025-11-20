#|Diff between buffers|#
define-command diff-buffers -override -params 2 \
  -docstring 'show the diff of two buffers' %{
  evaluate-commands %sh{
    file1=$(mktemp)
    file2=$(mktemp)
    echo "
      evaluate-commands -buffer '$1' write -force $file1
      evaluate-commands -buffer '$2' write -force $file2
      edit! -scratch *diff-buffers*
      set buffer filetype diff
      set-register | 'diff -u $file1 $file2; rm $file1 $file2'
      execute-keys !<ret>gg
    "
  }
}
complete-command diff-buffers buffer

#|Buffer picker|#
define-command -override open-buffer-picker \
  -docstring 'open-buffer-picker: Opens buffer picker.' %{
  prompt buffer: -buffer-completion %{ buffer %val{text} }
}
#|Toggle readonly in current buffer|#
define-command -override toggle-readonly \
  -docstring 'changes buffer readonly option current state' %{
   set-option buffer readonly %sh{ "$kak_opt_readonly" && echo false || echo true }
}

#|Buffer navigation|#
try %{ declare-user-mode buffer }
map global normal <esc> ': enter-user-mode buffer<ret>' \
  -docstring 'enter buffer user mode'

map global buffer h ': buffer-previous<ret>' \
  -docstring 'move to the previous buffer in the list'

map global buffer l ': buffer-next<ret>' \
  -docstring 'move to the next buffer in the list'

map global buffer q ': delete-buffer<ret>' \
  -docstring 'delete current buffer'

map global buffer Q ': delete-buffer!<ret>' \
  -docstring 'delete current buffer (force)'

map global buffer <space> ': open-buffer-picker<ret>' \
  -docstring 'open buffer picker'
