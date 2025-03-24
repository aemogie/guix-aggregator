"Setting Encoding
set encoding=utf-8

set autoread
"This was for setting up Vundle
set nocompatible
set lazyredraw
let mapleader=" "
filetype off
set shellslash
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')

"Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Fancy Autocompletion

Plugin 'lifepillar/vim-mucomplete'
"Plugin 'ycm-core/YouCompleteMe'
"Plugin 'ackyshake/VimCompletesMe'
"Plugin 'liuchengxu/vim-clap'
"Plugin 'godlygeek/tabular'
"Plugin 'preservim/vim-markdown'
Plugin 'preservim/nerdtree'
"Plugin 'dylanaraps/wal.vim'
Plugin 'lervag/vimtex'
Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/fzf.vim'
"Plugin 'vimwiki/vimwiki'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
"Plugin 'vim-airline/vim-airline'
Plugin 'vim-ctrlspace/vim-ctrlspace'
"Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-rmarkdown'
"Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'sirver/UltiSnips'
"Plugin 'weirongxu/plantuml-previewer.vim'
"Plugin 'tyru/open-browser.vim'
"Plugin 'aklt/plantuml-syntax'
Plugin 'ryanoasis/vim-devicons'
Plugin 'donRaphaco/neotex'
Plugin 'kovisoft/slimv'
Plugin 'ap/vim-css-color'
Plugin 'chriskempson/base16-vim'
Plugin 'lgalke/vim-compiler-vale'

"All of your plugins must be added before the following line

call vundle#end()		"required
filetype plugin indent on	"required
set hidden

"Brief Help for Vundle
" :PluginInstall  	-installs plugins
" :PluginList 		-lists plugings
" :PLuginSearch 	-seaches for foo
" :PluginClean 		-confirms removal of unused plugins

"Put your non-plugin stuff after this line

let g:tex_flavor='latex'
let g:DefaultTargetFormat='pdf'
let g:vimtex_view_enabled=1
let g:vimtex_view_automatic=1
let g:vimtex_view_method='zathura'

"Some deafults
"When started as "evim", evim.vim will already have done these settings
if v:progname =~? "evim"
  finish
endif

if has("vms")
   set nobackup
   if has('persistent_undo')
     set undofile
   endif
endif

"Highlighting

if &t_Co > 2 || has("gui_running")
   syntax on
   set hlsearch
endif

"Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  autocmd BufWritePost ~/dwm/dwmblocks/config.h !cd ~/dwm/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks &}
  autocmd BufWritePost ~/dwm/config.h !cd ~/dwm/; sudo make install
  autocmd BufWritePost ~/st/config.h !cd ~/st/; sudo make install

"For all text files set 'textwidth' to 78 characters
  autocmd FileType text setlocal textwidth=78

augroup END

"Add (relative) numbers on the side when Vim opens
set number relativenumber

"Spelling
set spell spelllang=en_us
set nospell

hi clear SpellBad
hi SpellBad cterm=underline
hi SpellBad cterm=bold
hi SpellBad ctermfg=red
"
"Use wal color scheme
"colorscheme wal

"Base 16 colorscheme
"if filereadable(expand("~/.vimrc_background"))
"	let base16colorspace=256
"	source ~/.vimrc_background
"endif
set bg=dark


"Add TEMP directory
set dir=$TEMP

"NERDTREE
map <leader>n :NERDTreeToggle<CR>

"Turn off swap files
set noswapfile
set nobackup
set nowb


"Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

"Completion
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~
set wildignore+=*.png,*.jpg,*gif

"Search
set incsearch
set ignorecase
set smartcase

"Command History
set history=10000

"Ruler
set ruler

"Setting Goyo to the "\" + f
map <leader>f :Goyo \| set linebreak<CR>


"Goyo with LimeLight
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
let g:limelight_conceal_ctermfg = 'grey'
let g:limelight_default_coefficient = 0.7

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"Setting file syntax manually
"let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.mdown': 'markdown', '.markdown': 'markdown'}
"let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd VimLeave *.tex !texclear %


"ViM-Airline
let g:airline#extensions#tabline#enabled = 0

"Settings for fugitive
map <leader>g :G add . \| :G commit -m "Updated from ViM" \| :Git push<CR>
map <leader>p :G pull<CR>
"Setting tabline
set showtabline=0

"More color in life
"set termguicolors
set go+=c

"Binding for compiling beamer presentations using pandoc
map <leader>bp :!pandoc % --citeproc -t beamer -o presentation.pdf <CR>


"Snippets Configuration of UltiSnips
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsForwardTrigger="<C-j>"
let g:UltiSnipsJmpBackwardTrigger="<C-k>"

"Mapping for opening the current directory in lf
"map <leader>c :!st lf & <CR><CR>

"Settings for Plantuml preview
let g:plantuml_previewer#save_format='pdf'

set guifont=Material\ Design\ 11

let g:airline_powerline_fonts=1

"For compiling all kinds of stuff
map <leader>cc :w! \| !compiler "<c-r>%"<CR>
"autocmd BufWritePost *.tex !biber %:r

"Opening corresponding review.
map <leader>cv :!compiler-output %<CR><CR>

let g:neotex_enabled=2
let g:neotex_subfile=2
let g:neotex_delay=2

" vim-pandoc {{{2
let g:pandoc#filetypes#handled = ["pandoc", "markdown", "textile"]
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#biblio#bibs = ["/home/divya/bib/psycho.bib", "/home/divya/bib/math.bib", "/home/divya/bib/phil.bib", "/home/divya/bib/phy.bib"]
let g:pandoc#completion#bib#mode = 'citeproc'
let g:pandoc#modules#disabled = ["folding"]

"Auto-Completion!
set completeopt+=menuone
set completeopt+=noselect
let g:mucomplete#enable_auto_at_startup = 1

"Output for RMarkdown
map <leader>ro :w! \| !Rscript -e "rmarkdown::render('%', quiet=TRUE)"<CR><CR>

"FuzzyFinding Stuff

nmap <leader>o :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>h :History<CR>
nmap <leader>t :BTags<CR>
nmap <leader>T :Tags<CR>
