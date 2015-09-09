"use vim settings, rather then vi settings (set as early as possible)
set nocompatible

"Pathogen and Airline plugins
"mkdir -p ~/.vim/autoload ~/.vim/bundle
"curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
"git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
runtime! autoload/pathogen.vim
if exists("*pathogen#infect")
  execute pathogen#infect()
  
  "### CtrlP
  " <Ctrl-P> fuzzy finder file opener
  " <Ctrl-v>/<Ctrl-x> open file in vert/horiz split 
  " <Ctrl-n>/<Ctrl-p> next/previous search in history
  let g:ctrlp_show_hidden = 1

  "### Airline
  "Show list of buffers in the top bar
  let g:airline#extensions#tabline#enabled = 1
  " Show just the filename in the top bar
  let g:airline#extensions#tabline#fnamemod = ':t'
  " Remove the trailing # from the bottom bar
  let g:airline#extensions#default#layout = [ [ 'a', 'b', 'c' ], [ 'x', 'y', 'z' ] ]
  
  "### Indent-Guides
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#3F3F3F ctermbg=237
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#2A2A2A ctermbg=235
  autocmd FileType * call indent_guides#enable()

  " Multi-Cursor
  let g:multi_cursor_use_default_mapping=0
  let g:multi_cursor_start_key=';m'
  "next_key
  "if used directly after start_key, it jumps to next occurrence of word under cursor
  "if used after moving around, it finalizes multi-cusror selection
  let g:multi_cursor_next_key='m'
  let g:multi_cursor_quit_key='<Esc>'
  
endif

"allow unsaved buffers to be hidden
set hidden
"enable syntax highlighting
syntax enable
"enable line numbering
set number
"disable visual wrapping of long lines
set nowrap
"language-based indentation
filetype plugin indent on
au FileType * :set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
au FileType html,css :set shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab
"autoindent: copy indent level from previous line
set autoindent
"smarttab: at start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth space
set smarttab  
"enable omnicomplete
"SQL/HTML/CSS/JS/PHP support built into Vim7
"<Ctrl-x><Ctrl-o> to invoke
"menu     show popup menu with the possible completions
"preview  show extra information about selected completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt=menu,preview
"lowercase searches are not case sensitive
set ignorecase
"upper/mixed case searches are case sensitive
set smartcase
"enable search highlighting
set hlsearch
"enable incremental search
set incsearch
"command line history
set history=100
"always show tabs
set showtabline=2
"always show statusline
set laststatus=2
"open new splits to right/bottom
set splitbelow
set splitright
"whitespace character display
set listchars=trail:·,tab:»·,eol:¬
"show whitespace by default
set list
"easy backspacing
set backspace=2
"wrap movement, backspace, and cursor keys
set whichwrap=b,s,h,l,<,>,[,]
"minimum lines to keep above and below cursor
set scrolloff=2
"disable audio error alerts
set noerrorbells
"highlight current line
set cursorline
autocmd VimEnter * :hi CursorLine ctermbg=235 guibg=#333333
autocmd InsertEnter * :hi CursorLine ctermbg=232 guibg=#111111 
autocmd InsertLeave * :hi CursorLine ctermbg=235 guibg=#333333

"diff mode colors
autocmd VimEnter * :hi DiffText ctermbg=Yellow ctermfg=Red cterm=none
autocmd VimEnter * :hi DiffChange ctermbg=Yellow ctermfg=Black cterm=none

"ignore whitespace in diff mode
if &diff
  set diffopt+=iwhite,filler
endif

"colorscheme
let g:rehash256=1
set background=dark
colorscheme molokai

if has("gui_running")

  "gVim window size
  set lines=35
  set columns=150
  set cmdheight=1

  "gVim font
  if has('win32') || has('win64')
    set guifont=Consolas:h11:cANSI
  endif

else
  "pretty colors in non-gui DOS/cygwin terminals (using ConEmu)
  if $TERM=="cygwin" || has("win32")
    set term=pcansi
    set t_Co=256
  endif
endif

"Temp folders
if has('win32') || has('win64')
  let $TMP="C:/TEMP"
  set directory=$TMP
  set backupdir=$TMP
  set undodir=$TMP
else
  set directory=/tmp
  set backupdir=/tmp
  set undodir=/tmp
endif

"Compare original to unsaved version
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

function! ToggleDiff()
  if (&diff==0)
    :windo diffthis
  else
    :set nodiff
  endif
endfunction

"=============================================
" Key Binding Cheat Sheat
"=============================================
" w/b W/B move by word
"  .   repeat previous edit
"  @:  repeat previous command
"  q:  show command history
" * #  search for word under cursor (forward/backward)
" 25%  move to a location based on percentage
" :g/word/  show all line matches in a pane
" :%s/old/new/gc  replace text globally with confirmation
" do  diff get changes from other window into current window
" dp  diff put changes from current window into other window
" ]c  diff jump to next change
" [c  diff jump to previous change

"paste clipboard without indenting
inoremap <F12> <Esc>:set paste!<CR>:set paste?<CR>i
nnoremap <F12> :set paste!<CR>:set paste?<CR>

"quick indentation in visual mode
vmap <tab> >gv
vmap <s-tab> <gv

let mapleader = ";"

"shortcuts to save/quit/file explorer/show path
nmap <silent> <leader>w :w!<CR>
nmap <silent> <leader>q :q<CR>
nmap <silent> <leader>e :E<CR>
nmap <silent> <leader>p :CtrlP<CR>
nmap <silent> <leader>r :CtrlPMRU<CR>

"shortcuts to enable/disable various features
nmap <silent> <leader>D :call ToggleDiff()<CR>
nmap <silent> <leader>E :set expandtab!<CR>:set expandtab?<CR>
nmap <silent> <leader>H :set hlsearch!<CR>:set hlsearch?<CR>
nmap <silent> <leader>L :set list!<CR>
nmap <silent> <leader>N :set number!<CR>
nmap <silent> <leader>P :lcd %:p:h<CR>:pwd<CR>
nmap <silent> <leader>R :set relativenumber!<CR>
nmap <silent> <leader>S :windo set scrollbind!<CR>:set scrollbind?<CR>
nmap <silent> <leader>W :set list!<CR>


"buffers/split manipulation

" switch split layout between vertical and horizontal
let sp = 0
nnoremap <silent> <leader><Space> :let sp=!sp<Bar>:if sp<Bar>:vertical ball<Bar>:else<Bar>:ball<Bar>:endif<CR>

nmap <silent> <leader>- :sp<CR>
nmap <silent> <leader>\ :vs<CR>
nmap <silent> <leader>] :if winnr('$')>1<Bar>:wincmd w<Bar>:else<Bar>:bnext<Bar>:endif<CR>
nmap <silent> <leader>[ :if winnr('$')>1<Bar>:wincmd W<Bar>:else<Bar>:bprev<Bar>:endif<CR>
nmap <silent> <leader>b :buffers<CR>:b
nmap <silent> <leader>x :bdelete<CR>
nmap <silent> <leader>n :enew<CR>
nmap <silent> <leader>h :hide<CR>
nmap <silent> <leader>o :only<CR>
nmap <silent> <leader>1 :b1<CR>
nmap <silent> <leader>2 :b2<CR>
nmap <silent> <leader>3 :b3<CR>
nmap <silent> <leader>4 :b4<CR>
nmap <silent> <leader>5 :b5<CR>

"tabs
nmap <silent> <leader>t :tabs<CR>
nmap <silent> <leader>tn :tabnew<CR>
nmap <silent> <leader>tc :tabclose<CR>
