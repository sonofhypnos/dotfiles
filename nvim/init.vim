set nocompatible

" =============================================================================
"   PLUGINS
" =============================================================================
" to update run :PlugUpgrade, PlugUpdate

call plug#begin('~/.local/share/nvim/plugged')

" Load Plugins
" autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'davidhalter/jedi-vim'
"
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" spellchecking in bash and other languages. might collide with my other
" addons.
Plug 'dense-analysis/ale'



" Code Formating
Plug 'sbdchd/neoformat'

" file management
Plug 'scrooloose/nerdtree'

" saving as root
Plug 'lambdalisue/suda.vim'


" timetracking
Plug 'wakatime/vim-wakatime'


" Python help
Plug 'fs111/pydoc.vimj'

call plug#end()


" Plugin settings
let g:deoplete#enable_at_startup = 1

" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to space conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

" disable autocompletion, because we use deoplete for completion
" let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"



" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=2
set nojoinspaces
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter

" Sane splits
set splitright
set splitbelow


" Decent wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor


" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines


" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase
set gdefault

" Enable searching as you type, rather than waiting till you press enter.
set incsearch



" =============================================================================
" # GUI settings 
" =============================================================================
" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" =============================================================================
" # Keyboard shortcuts
" =============================================================================

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
"r how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>


"map f <Plug>Sneak_f
"map F <Plug>Sneak_F
"map t <Plug>Sneak_t
"map T <Plug>Sneak_T


" remapping Escape
nnoremap ö< <esc>
" Remap in Normal mode
inoremap ö <esc>
" Remap in Insert and Replace mode
vnoremap ö <esc>
" Remap in Visual and Select mode
xnoremap ö <esc>
" Remap in Visual mode
snoremap ö <esc>
" Remap in Select mode
cnoremap ö <C-C>
" Remap in Command-line mode
onoremap ö <esc>
" Remap in Operator pending mode

" esc in command mode

" remapping Escape
nnoremap Ö <esc>
" Remap in Normal mode
inoremap Ö <esc>
" Remap in Insert and Replace mode
vnoremap Ö <esc>
" Remap in Visual and Select mode
xnoremap Ö <esc>
" Remap in Visual mode
snoremap Ö <esc>
" Remap in Select mode
cnoremap Ö <C-C>
" Remap in Command-line mode
onoremap Ö <esc>
" Remap in Operator pending mode

