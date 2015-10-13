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
  let g:indent_guides_enable_on_vim_startup = 1
  " 30 indent levels (default) can cause lag and seems excessive
  let g:indent_guides_indent_levels = 8
  let g:indent_guides_auto_colors = 0
  augroup indent_guides_augroup
    autocmd!
    au VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#3F3F3F ctermbg=237
    au VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#2A2A2A ctermbg=235
  augroup END

  "### Multi-Cursor
  let g:multi_cursor_use_default_mapping=0
  let g:multi_cursor_start_key=';m'
  "next_key
  "if used directly after start_key, it jumps to next occurrence of word under cursor
  "if used after moving around, it finalizes multi-cusror selection
  let g:multi_cursor_next_key='m'
  let g:multi_cursor_quit_key='<Esc>'
  
  "### GnuPG
  let g:GPGPreferArmor=1
  let g:GPGDefaultRecipients=["darren.q@gmail.com"]

  "### Ansible
  let g:ansible_attribute_highlight = "ab"
  " allow yaml/yml files to indicate they are ansible playbooks
  " by putting # vim:ft=ansible at beginning or end of file
  au FileType yaml,yml :set modeline

  "### UndoTree
  let g:undotree_SetFocusWhenToggle=1
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
au FileType ansible,html :set indentkeys-=*<Return>
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
augroup cursor_line_colors_augroup
  autocmd!
  au VimEnter * :hi CursorLine ctermbg=235 guibg=#333333
  au InsertEnter * :hi CursorLine ctermbg=232 guibg=#111111 
  au InsertLeave * :hi CursorLine ctermbg=235 guibg=#333333
augroup END

"diff mode colors
augroup diff_mode_colors_augroup
  autocmd!
  au VimEnter * :hi DiffText ctermbg=Yellow ctermfg=Red cterm=none guibg=Yellow guifg=Red gui=none
  au VimEnter * :hi DiffChange ctermbg=Yellow ctermfg=Black cterm=none guibg=Yellow guifg=Black gui=none
  au VimEnter * :hi DiffAdd ctermbg=Black guibg=Black
  au VimEnter * :hi DiffDelete ctermbg=Black guibg=Black
augroup END

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
  "if $TERM=="cygwin" || has("win32")
  if $ConEmuANSI=='ON'
    set term=pcansi
    set t_Co=256
  else
    "cygwin without ConEmu or in ConEmu ssh
    if $TERM=='cygwin'
      autocmd VimEnter * :set t_Co=8
      colorscheme miro8
    "PuTTY, *nix ssh (not gVim, ConEMU, or cygwin)
    else
      "leave term, t_Co alone, use colorscheme set above
    endif
  endif
endif

"Temp folders
if has('win32') || has('win64')
  let $TMP="C:/TEMP"
else
  let $TMP="/tmp"
endif
set directory=$TMP
set backupdir=$TMP

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand($HOME . '/.vim-undodir')
    " Create dirs
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
    set undolevels=1000
    set undoreload=10000 
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
" w W b B         Move by word (W/B includes non-alphanumeric chars)
" dw dW yw yW     Delete/Yank word (W includes non-alphanumeric chars)
" :g/word/        Show all line matches in a pane at bottom
" :%s/old/new/gc  Replace text globally with confirmation
" 25%             Jump to line based on percentage of file
" { }             Jump to prev/next empty line
" =               (Visual mode) Indent lines to same level

" ma 'a         Mark line as 'a' / Move to line marked 'a'
" [' ]'         Jump to Previous/Next lowercase mark
" :marks        Show all marks
" :delmarks!    Delete lowercase marks
" :delm A-Z0-9  Delete all other marks

"  .    Repeat previous edit
"  @:   Repeat previous command
"  q:   Show command history

" do  (diff mode) Get changes from other window into current window
" dp  (diff mode) Put changes from current window into other window
" ]c  (diff mode) Jump to next change
" [c  (diff mode) Jump to previous change

"paste clipboard without indenting
inoremap <F12> <Esc>:set paste!<CR>:set paste?<CR>i
nnoremap <F12> :set paste!<CR>:set paste?<CR>

"turn off whitespace character listing and line numbers (for clean copying)
nnoremap <F11> :set list!<CR>:set number!<CR>

"quick indentation in visual mode
vmap <tab> >gv
vmap <s-tab> <gv

" remap asterisk so it just highlights word currently under cursor
" instead of moving to the next occurrence
nnoremap * *``

" remap o/O so they go back into Normal mode
"nnoremap o o<Esc>
"nnoremap O O<Esc>

let mapleader = ";"

"copy visual mode selection to OS clipboard (works well with Shift-v)
vnoremap <S-c> "*y

"turn off highlighting
nmap <silent> <leader>* :set hlsearch!<CR>:set hlsearch?<CR>

"shortcuts to save/quit/file explorer/show path
nmap <silent> <leader>w :w!<CR>
nmap <silent> <leader>q :q<CR>
nmap <silent> <leader>e :E<CR>
nmap <silent> <leader>p :CtrlP<CR>
nmap <silent> <leader>r :CtrlPMRU<CR>
nmap <silent> <leader>u :UndotreeToggle<CR>
"m is used by multi-cursor

"shortcuts to enable/disable various features
nmap <silent> <leader>A :if (&ft=='ansible')<Bar>:set ft=ansible!<Bar>:else<Bar>:set ft=ansible<Bar>:endif<CR>
nmap <silent> <leader>D :call ToggleDiff()<CR>
nmap <silent> <leader>E :set expandtab!<CR>:set expandtab?<CR>
nmap <silent> <leader>I :call indent_guides#toggle()<CR>
nmap <silent> <leader>H <C-w>H
nmap <silent> <leader>J <C-w>J
nmap <silent> <leader>K <C-w>K
nmap <silent> <leader>L <C-w>L
nmap <silent> <leader>M :marks a-z<CR>
nmap <silent> <leader>N :set number!<CR>
nmap <silent> <leader>O :DiffOrig<CR>
nmap <silent> <leader>Q :qa!<CR>
nmap <silent> <leader>P :lcd %:p:h<CR>:pwd<CR>
nmap <silent> <leader>R :retab<CR>
nmap <silent> <leader>S :windo set scrollbind!<CR>:set scrollbind?<CR>
"[W]hitespace
nmap <silent> <leader>W :set list!<CR>

" switch split layout between vertical and horizontal
let sp = 0
nnoremap <silent> <leader><Space> :let sp=!sp<Bar>:if sp<Bar>:vertical ball<Bar>:else<Bar>:ball<Bar>:endif<CR>

nmap <silent> <leader>- :sp<CR>
nmap <silent> <leader>\ :vs<CR>
nmap <silent> <leader>] :if winnr('$')>1<Bar>:wincmd w<Bar>:else<Bar>:bnext<Bar>:endif<CR>
nmap <silent> <leader>[ :if winnr('$')>1<Bar>:wincmd W<Bar>:else<Bar>:bprev<Bar>:endif<CR>
nmap <silent> <leader>} :bnext<CR>
nmap <silent> <leader>{ :bprev<CR>
nmap <silent> <leader>b :buffers<CR>:b
nmap <silent> <leader>x :bdelete<CR>
nmap <silent> <leader>n :enew<CR>
nmap <silent> <leader>h :hide<CR>
nmap <silent> <leader>o :only<CR>

nmap <silent> <leader>tn :tabnew<CR>
nmap <silent> <leader>tc :tabclose<CR>
nmap <silent> <leader>t] :tabnext<CR>
nmap <silent> <leader>t[ :tabprev<CR>
