hook -group config global WinSetOption filetype=sh %{
  add-highlighter window/ column 80 StatusLine
  set-option window formatcmd 'shfmt'
  set-option window lintcmd 'shellharden'
  set-option window comment_line '#'
  set-option window comment_block_begin "<<'####'"
  set-option window comment_block_end '###'
}
