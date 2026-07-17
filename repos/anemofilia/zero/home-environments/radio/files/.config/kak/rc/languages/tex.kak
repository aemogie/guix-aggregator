hook -group config global WinSetOption filetype=latex %{
  add-highlighter window/ column 80 StatusLine
  # set-option -add global lsp_server_configuration texlab.build.onSave=true
  # set-option -add global lsp_server_configuration texlab.build.forwardSearchAfter=true
  # set-option -add global lsp_server_configuration texlab.build.args=["-pdf","-new-viewer-","-pdflatex\=pdflatex","-silent","-shell-escape","%f"]
  set-option window auto_pairs ( ) [ ] { } '"' '"' $ $
  set-option window indentwidth 2
  set-option window formatcmd "fmt"
}
