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
set colorcolumn=80
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
Plug 'p00f/nvim-ts-rainbow'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" airline 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" treeshitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript" },
  highlight = {
    enable = false,
    disable = { "cuda", "python" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false 
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = nil,
  }
}
EOF

"fzf
set rtp+=~/.vim/bundle/fzf

" colorscheme 
colorscheme gruvbox 

" transparent bg
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

" leader key
let mapleader = " "

" nerdtree
nmap <F6> :NERDTreeToggle<CR>

" telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr> 
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" window 
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
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
nnoremap <silent> H :call <SID>show_documentation()<CR>
nmap <silent> df :call CocAction('jumpDefinition', 'vsplit')<CR>

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

" lua
command! Scratch lua require'tools'.makeScratch()

lua << EOF
require'nvim-autopairs'.setup{}
EOF

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif
