set-option -add global lsp_server_configuration texlab.build.onSave=true
set-option -add global lsp_server_configuration texlab.build.forwardSearchAfter=true
set-option -add global lsp_server_configuration texlab.build.args=["-pdf","-new-viewer-","-pdflatex\=pdflatex","-silent","-shell-escape","%f"]

hook -group config global BufSetOption filetype=latex %{
  add-highlighter window/ column 80 StatusLine
  set-option window auto_pairs ( ) [ ] { } '"' '"' $ $
  set-option window indentwidth 2
}
