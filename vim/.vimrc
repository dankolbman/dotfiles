" Dan Kolbman .vimrc

" -- Remaps --
" Don't skip over wraps
nnoremap j gj
nnoremap k gk
command WQ wq
command Wq wq
command W w
command Q q

set backspace=indent,eol,start

" -- White space --
" Tabstop
set tabstop=4
" Make indents follow tabbing
set sw=4
" Make tabs space characters
set expandtab

" -- Visual --
" Line numbers
set number
" Syntax highlighting
syntax on
" Bar on column 80
let &colorcolumn=join(range(80,81),",")
highlight ColorColumn ctermbg=0 guibg=#000000
" Show border under current line
set cursorline
" Highlight cursor column
" set cursorcolumn
" Show matching parenthesis
set showmatch
" Always show statusline
set laststatus=2
set vb

" -- Searching --
" Highlight results
set hlsearch
" Search while typing
set incsearch
" Don't move to line start when jumping
set nostartofline

" -- Language Server --
" if executable('pyls')
"     " pip install python-language-server
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pyls',
"         \ 'cmd': {server_info->['pyls']},
"         \ 'allowlist': ['python'],
"         \ })
" endif

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


let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tpope/vim-surround'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" Plug 'psf/black', { 'branch': 'stable' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'mhinz/vim-mix-format'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'yaegassy/coc-htmldjango', {'do': 'yarn install --frozen-lockfile'}
" Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
Plug 'rust-lang/rust.vim'

call plug#end()

if executable('ruff')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ruff',
        \ 'cmd': {server_info->['ruff', 'server']},
        \ 'allowlist': ['python'],
        \ 'workspace_config': {
        \   'ruff': {
        \     'lineLength': 100,
        \     'ignore': ['E501']
        \   }
        \ },
        \ })
endif

" nnoremap <leader>b :Black<CR>
nnoremap <leader>b :LspDocumentFormat<CR>

nnoremap <leader>d :call CocAction('format')<CR>

let g:mix_format_on_save = 1

" Enter FZF command and wait for path input
nnoremap <leader>F :FZF 
" Run FZF in current directory
nnoremap <leader>f :FZF<CR>

" Run ripgrep
nnoremap <leader>r :Rg<CR>

" netrw
let g:netrw_banner = 0
" style of directory listingss
let g:netrw_liststyle = 3
" Split explorer pane vertically
" let g:netrw_browse_split = 2

" let g:black_linelength = 88

set errorformat=%f:%l:%c:\ %m


colorscheme dracula
set term=xterm-256color
set re=0
