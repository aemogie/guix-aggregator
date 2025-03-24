hook global BufOpenFile .*\.typ %{
  set-option buffer filetype typst
}

hook -group config global BufSetOption filetype=typst %{
  add-highlighter window/ column 80 StatusLine
  set-option buffer auto_pairs ( ) [ ] { } '"' '"' $ $ * *
}
