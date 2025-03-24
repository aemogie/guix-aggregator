hook global WinSetOption filetype=zig %{
  add-highlighter window/ column 80 StatusLine
  set-option window formatcmd 'zig fmt --stdin'
  set-option window lintcmd 'zig fmt --color off --ast-check 2>&1'
  set-option window makecmd 'zig build --summary all'
  hook window -group format BufWritePre .* lsp-formatting-sync
  set-register pipe "fmt -w 99 -p '///'"
}
