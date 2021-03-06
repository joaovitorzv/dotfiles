"
" This file is not being used,
" my current enviroment setup is init.lua
"
syntax on

set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab 
set smartindent

set exrc
set guicursor=
set relativenumber
set nu
set nowrap
set incsearch
set scrolloff=8
set signcolumn=yes
set backspace=indent,eol,start
set colorcolumn=90
set nohlsearch
set completeopt=menuone,noselect

"coc required
set hidden 
set nobackup 
set nowritebackup 
set cmdheight=2
set updatetime=300
set shortmess+=c

call plug#begin('~/.vim/plugged')

" colorscheme
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/sonokai'
Plug 'tomasiser/vim-code-dark'
Plug 'pacokwon/onedarkhc.vim'
Plug 'joshdick/onedark.vim'

" syntax highlight
" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'prabirshrestha/vim-lsp'
Plug 'neovim/nvim-lspconfig'

" useful plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'https://github.com/kien/ctrlp.vim.git'
Plug 'preservim/nerdtree'
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround'
Plug 'prettier/vim-prettier'

" airline 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" treeshitter
lua << EOF
require'lspconfig'.pyright.setup{}
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript", "tsx", "graphql", "html", "jsdoc", "json", "json5", "yaml", "lua", "regex", "scss", "css", "bash", "python"  },
  highlight = {
    enable = true,
    disable = { "vim" },
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = false 
  },
}
require'nvim-autopairs'.setup{}
EOF
 
"fzf
set rtp+=~/.vim/bundle/fzf

" colorscheme 
if (has("termguicolors"))
  set termguicolors
endif

let g:gruvbox_contrast_dark = 'hard' 
colorscheme gruvbox 

" transparent bg
"highlight Normal     ctermbg=NONE guibg=NONE
"highlight LineNr     ctermbg=NONE guibg=NONE
"highlight SignColumn ctermbg=NONE guibg=NONE

" leader key
let mapleader = " "

" source init
nnoremap <leader>up :so ~/dotfiles/nvim/init.vim<CR>

" nerdtree
nmap <F6> :NERDTreeToggle<CR>

" window 
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <Leader>ps :Rg<CR>
nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>

" window tabs
nnoremap <leader><tab> :tabn<CR>
nnoremap <leader><S-Tab> :tabp<CR>

" copypaste
noremap <Leader>p "+p
noremap <Leader>y "+y

" find
nnoremap <silent> <leader>f :GFiles<CR> 

" utils  
nnoremap <leader>s :w<CR>
nnoremap <leader>q :wq<CR>

" definitions
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> gd :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <leader>rn <Plug>(coc-rename)

" suggetions navigate with tab 
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" COC...k?
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
