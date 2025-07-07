let mapleader="\<Space>"
set nocompatible
set mouse=a
set path+=**
set wildmenu
set wildmode=longest:full,full
set wildignorecase
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set ignorecase
set smartcase
set incsearch
set hidden
set clipboard=unnamedplus
set completeopt=menuone,noinsert,noselect
set showcmd
set splitbelow
set splitright
syntax on
filetype plugin indent on
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-n>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-x>\<C-n>"
command! MakeTags !ctags -R .
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
" Enable true color support
if has('termguicolors')
  set termguicolors
endif
" Load colorscheme
colorscheme habamax
" Function to clear background highlights
function! TransparentBackground()
  highlight Normal ctermbg=NONE guibg=NONE
  highlight NormalNC ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE
  highlight SignColumn ctermbg=NONE guibg=NONE
  highlight LineNr ctermbg=NONE guibg=NONE
  highlight VertSplit ctermbg=NONE guibg=NONE
  highlight Pmenu ctermbg=NONE guibg=NONE
endfunction
" Run it once after colorscheme loads
call TransparentBackground()
" Also rerun on every colorscheme change (for example, if you switch themes)
autocmd ColorScheme * call TransparentBackground()


