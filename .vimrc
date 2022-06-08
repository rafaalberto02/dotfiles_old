set nu!
set mouse=a
set title
set cursorline
set encoding=utf8
set relativenumber

call plug#begin()

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

Plug 'fladson/vim-kitty'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'editorconfig/editorconfig-vim'
Plug 'rust-lang/rust.vim'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
": Always have the devicons in the last place PLS
Plug 'ryanoasis/vim-devicons'
call plug#end()

"Always Open NerdTree, also, always close
autocmd VimEnter * NERDTree | wincmd p
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

let g:airline_powerline_fonts=1
let g:dracula_colorterm = 0

colorscheme dracula
set tags=tags
