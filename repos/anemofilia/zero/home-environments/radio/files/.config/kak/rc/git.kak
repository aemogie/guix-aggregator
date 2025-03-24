#|Git operations|#
try %{ declare-user-mode git }
map global user g ': enter-user-mode git<ret>' \
  -docstring 'enter git user mode'

map global git l ': git log<ret>' \
  -docstring 'log'

map global git c ': git commit<ret>' \
  -docstring 'commit'

map global git d ': git diff<ret>' \
  -docstring 'diff'

map global git s ': git status<ret>' \
  -docstring 'status'

map global git h ': git show-diff<ret>' \
  -docstring 'show diff'

map global git H ': git-hide-diff<ret>' \
  -docstring 'hide diff'
