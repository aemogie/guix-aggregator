let b:dispatch = guix_binary . ' build ' . guix_build_options . ' <cword> '
" We might be working on a go program
set wildignore-=*.go
