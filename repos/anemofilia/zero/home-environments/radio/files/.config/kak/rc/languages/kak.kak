hook -group config global WinSetOption filetype=kak %{
  add-highlighter window/ column 80 StatusLine
  set-option buffer indentwidth 2
}

#|Set kakrc's filetype to kak|#
hook -group config global WinCreate '.*/(\.)?kakrc' %{
  set-option buffer filetype kak
}

#|Source kakrc on save|#
hook global BufWritePost ".*/.config/kak/kakrc" %{
  source "%val{buffile}"
}
