" let mapleader='\<Space>'
set nocompatible
set mouse=a
set spell
set cursorline
set cursorcolumn
set path+=**
set wildmenu
set wildmode=longest:list,full
set wildignorecase
set number
set relativenumber
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set ignorecase
set smartcase
set incsearch
set hlsearch
set hidden
set clipboard=unnamed
set clipboard+=unnamedplus
set completeopt=menuone,noinsert,noselect
set showcmd
set showmatch
set splitbelow
set splitright
set undofile
syntax on
filetype plugin indent on
nnoremap <leader>e :Lex<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :wq<CR>
command! MakeTags !ctags -R .
let g:netrw_banner=0
let g:netrw_browse_split=0
let g:netrw_liststyle=3
let g:netrw_sizestyle="H"
let g:netrw_preview=0
let g:netrw_alto=1
let g:netrw_altv=1
" Start netrw if no filename on cmdline
    au VimEnter * if expand("%") == "" | e . | endif
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


