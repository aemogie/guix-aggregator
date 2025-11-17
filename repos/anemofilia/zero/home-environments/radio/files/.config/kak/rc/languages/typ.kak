hook -group config global WinSetOption filetype=typst %{
  add-highlighter window/ column 80 StatusLine
  remove-highlighter shared/typst/regex_\s\*[^\*]+\*\B_0:+b
  remove-highlighter shared/typst/regex_\b_.*?_\b_0:+i
  set-option buffer auto_pairs ( ) [ ] { } '"' '"' $ $ * *
}
