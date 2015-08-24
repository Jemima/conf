" David Munro's <david.munro@gmail.com> vimrc file shamelessly incorporating
" useful things from everywhere and everyone.


" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Indentation options:
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set copyindent
set expandtab
set smarttab

set showmatch  " show matches
set hlsearch   " highlight search terms
set number     " show line numbers
" set rnu!       " Relative line numbering
set lbr!       " Linewrap at word boundaries
set history=100		" keep 100 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hidden     " allows for hidden buffers
set showmode      " show the current mode
set wildmenu
set wrapscan
set ch=2
set timeoutlen=200
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
set scrolloff=5
set showfulltag
set diffopt+=iwhite "ignore whitespace changes when diffing
set whichwrap=b,s,<,>,[,]
set cursorline
set cursorcolumn
set backspace=indent,eol,start
set ignorecase
set smartcase
set wildmode=list:longest,full
set foldenable
set laststatus=2 " Always show the status line
set ve=onemore
set autoread
let mapleader=","
if has('cmdline_info')
    set ruler                   " show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd                 " show partial commands in status line and selected characters/lines in visual mode
endif
" Shortcuts
nnoremap ; :
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nmap <silent> <leader>/ :nohlsearch<CR> " remove the search result highlights
nmap <silent> \, :nohlsearch<CR> " remove the search result highlights
noremap <F3> :NERDTree<CR>
noremap <F4> :TagbarToggle<CR>
noremap <F5> :UndotreeToggle<CR>

nnoremap Y y$
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

vnoremap p "_dp
vnoremap P "_dP

" Use the regular windows keyboard by default.
set clipboard=unnamed


cmap w!! w !sudo tee % >/dev/null

" Switch to previous/next buffer in MiniBuffExpl
" nnoremap th :MBEbp<CR>
" nnoremap tl :MBEbn<CR>
"
" cnoremap  :bd :MBEbd<CR>
" noremap   <C-F4> :MBEbd<CR>

" Make j/k move by screen lines, not 'real' lines (i.e. on a wrapped line
" don't skip the entire thing).
nnoremap j gj
nnoremap k gk

" Easier to hit than escape
inoremap  <leader><TAB> <ESC>
vnoremap  <leader><TAB> <ESC>

" Let us delete/change/yank/etc within spaces and underscores, not just
" brackets, etc.
nnoremap di<space> T<space>d,
nnoremap da<space> F<space>d,
nnoremap ci<space> T<space>c,
nnoremap ca<space> F<space>c,
nnoremap yi<space> T<space>y,
nnoremap ya<space> F<space>y,
nnoremap vi<space> T<space>v,
nnoremap va<space> F<space>v,
nnoremap di_ T_d,
nnoremap da_ F_d,
nnoremap ci_ T_c,
nnoremap ca_ F_c,
nnoremap yi_ T_y,
nnoremap ya_ F_y,
nnoremap vi_ T_v,
nnoremap va_ F_v,

" Stuff for working with tabs/buffers
nmap tl :tabPrevious<CR>
nmap th :tabNext<CR>
nmap bh :bn<CR>
nmap bl :bp<CR>

"Stuff for diffs
nmap dp :diffput
nmap do :diffget

"
" Run maximized in diff mode
if &diff
   au GUIEnter * simalt ~x
endif

set fillchars+=stl:\ ,stlnc:\ 
set encoding=utf-8

au FocusLost * silent! :wa " save when we lose focus

" Windows Compatible {
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif
" We want persistent undo (undo between file closes
if has('persistent_undo')
    "This is a test
    ""Writing somethung elswe`
    let myUndoDir = expand($HOME.'/.vim/undodir')
    " No console pops up
    " call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

"Don't let UndoTree highlight changed text. I just wrote it, I know what I
"changed.
let g:undotree_HighlightChangedText = 0

"The arrows don't work in some terminals
let g:NERDTreeDirArrows=0

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

set t_Co=256
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
" Finally, account for the black background of the terminal.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    set bg=dark
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else

    set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis

" Look for tag files in the file's directory, then in the directory we ran from
set tags=./tags;
set tags+=tags;

"Keep swap, backup, etc files in ~/.vimswap, etc instead of current folder
function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

" Setup Vim Addon manager, and init with the plugins we like.
fun! SetupVAM()
    let c = get(g:, 'vim_addon_manager', {})
    let g:vim_addon_manager = c
    let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'
    " most used options you may want to use:
    " let c.log_to_buf = 1
    " let c.auto_install = 0
    let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
    if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
        execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
                    \       c.plugin_root_dir.'/vim-addon-manager'
    endif
    call vam#ActivateAddons([], {'auto_install' : 0})
endfun

call SetupVAM()
let vam_always = {
            \ 'never': [ 'github:fholgado/minibufexpl.vim.git' ],
            \ 'always': [ 'github:scrooloose/nerdtree.git', 'github:scrooloose/nerdcommenter.git', 'SearchComplete', 'Tagbar', 'github:tpope/vim-surround.git', 'github:tpope/vim-fugitive', 'github:vim-perl/vim-perl.git', 'github:goatslacker/mango.vim.git', 'github:ervandew/supertab', 'ScrollColors', 'Colour_Sampler_Pack', 'vim-airline', 'csv', 'github:BenBergman/TagHighlight', 'github:tpope/vim-surround', 'OmniCppComplete', 'delimitMate', 'github:mbbill/undotree', 'vim-snippets', 'github:wesgibbs/vim-irblack.git', 'github:AndrewRadev/linediff.vim', 'github:PProvost/vim-ps1.git' ]
            \ }
call vam#ActivateAddons(vam_always['always'])


" Setup our syntax highlighting.
set autochdir
:autocmd ColorScheme * highlight ExtraWhitespace guibg=purple
:autocmd ColorScheme * highlight TODO ctermbg=green
hi Comment      guifg=gray55		gui=italic
" TODO: Test
syntax match TODO /TODO:/
hi TODO ctermfg=green
highlight ExtraWhitespace guibg=purple
match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd InsertEnter * match ExtraWhitespace /\s\+$%#\@<!$\| \+\ze\t/
autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinLeave * call clearmatches()


" Setup Airline for our status bar.
let g:airline#extensions#whitespace#checks = [ 'indent' ]
let g:airline#extensions#whitespace#mixed_indent_format = 'mi[%s]'
" Alas, we seem only able to change the statusbar in our vimrc, rather than at
" runtime
function! MyPlugin(...)
    call airline#extensions#append_to_section('c', g:extra_name)
endfunction
function! AddName(name)
    let g:extra_name=a:name
    call airline#add_statusline_func('MyPlugin')
endfunction

" We're on Windows, so prefer windows line endings.
set ffs=dos,unix
setglobal ff=dos

" We have too many diff programs, force Vim to use its own.
set diffexpr=MyDiff()
	function MyDiff()
	   let opt = ""
	   if &diffopt =~ "icase"
	     let opt = opt . "-i "
	   endif
	   if &diffopt =~ "iwhite"
	     let opt = opt . "-b "
	   endif
	   silent execute '!"C:/Program Files (x86)/vim/vim74/diff.exe" -a --binary ' . opt . v:fname_in . " " . v:fname_new .
		\  " > " . v:fname_out
	endfunction


