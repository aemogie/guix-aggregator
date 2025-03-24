hook -group config global WinSetOption filetype=cpp %{
  add-highlighter window/ column 80 StatusLine
  set-option window formatcmd 'clang-format'
}
