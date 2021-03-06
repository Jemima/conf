" David Munro's <david.munro@gmail.com> vimrc file shamelessly incorporating
" useful things from everywhere and everyone.


" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
"
" Set up some language-specific shortcuts, this must be early because it only
" runs when the filetype is actually set.
" Free C-R so we don't keep redoing if we're too slow to build. We map redo to
" something else later.
nmap <C-R> <nop>
map <F1> <nop>
" Go
autocmd FileType go map <buffer> <C-B>  :GoBuild<CR>
autocmd FileType go map <buffer> <C-R><C-R> :GoRun<CR>
autocmd FileType go map <buffer> <C-R><C-T> :GoTest<CR>
" General shortcuts for plugins
noremap <F3> :NERDTree<CR>
noremap <F4> :TagbarToggle<CR>
noremap <F5> :UndotreeToggle<CR>

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
set foldlevel=99
set foldmethod=indent
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
set conceallevel=0
let mapleader=","
" Shortcuts
" Windows-style redo shortcut, frees C-R for e.g. Run.
nnoremap <C-Y> <C-R>
nnoremap ; :
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nmap <silent> <leader>/ :nohlsearch<CR> " remove the search result highlights
nmap <silent> \, :nohlsearch<CR> " remove the search result highlights

nnoremap Y y$
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

vnoremap p "_dp
vnoremap P "_dP

" Use the system clipboard by default.
if has('win32') || has('win64')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" I really want to write the file.
if has('win32') || has('win64')
    " attrib +w % then try writing again I guess?
else
    cmap w!! w !sudo tee % >/dev/null
endif

" Make j/k move by screen lines, not 'real' lines (i.e. on a wrapped line
" don't skip the entire thing).
nnoremap j gj
nnoremap k gk

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
nmap tl :tabnext<CR>
nmap th :tabprevious<CR>
nmap bl :bn<CR>
nmap bh :bp<CR>

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
" We want persistent undo (undo between file closes)
if has('persistent_undo')
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
        " For all text files set 'textwidth' to 80 characters.
        autocmd FileType text setlocal textwidth=80

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
"fun! SetupVAM()
    "let c = get(g:, 'vim_addon_manager', {})
    "let g:vim_addon_manager = c
    "let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'
    "" most used options you may want to use:
    "" let c.log_to_buf = 1
    "" let c.auto_install = 0
    "let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
    "if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
        "execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
                    "\       c.plugin_root_dir.'/vim-addon-manager'
    "endif
    "call vam#ActivateAddons([], {'auto_install' : 0})
"endfun

"call SetupVAM()
"let vam_always = {
            "\ 'never': [ 'github:fholgado/minibufexpl.vim.git' ],
            "\ 'always': [ 'github:scrooloose/nerdtree.git', 'github:scrooloose/syntastic.git', 'github:scrooloose/nerdcommenter.git', 'SearchComplete', 'Tagbar', 'github:tpope/vim-surround.git', 'github:tpope/vim-fugitive', 'github:vim-perl/vim-perl.git', 'github:goatslacker/mango.vim.git', 'github:ervandew/supertab', 'ScrollColors', 'Colour_Sampler_Pack', 'vim-airline', 'csv', 'github:BenBergman/TagHighlight', 'github:tpope/vim-surround', 'OmniCppComplete', 'delimitMate', 'github:mbbill/undotree', 'vim-snippets', 'github:wesgibbs/vim-irblack.git', 'github:AndrewRadev/linediff.vim', 'github:PProvost/vim-ps1.git', 'github:fatih/vim-go' ]
            "\ }
"call vam#ActivateAddons(vam_always['always'])

" If we don't have vim-plug install it now.
" Will probably break if $HOME has spaces.
let PlugPath=expand($HOME).'/.vim/autoload/plug.vim'
if empty(glob(PlugPath))
    exe 'silent !curl -fLo ' . PlugPath . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Setup our plugins.
call plug#begin('~/.vim/plugged')
" Simple file explorer/
Plug 'scrooloose/nerdtree'
" Shortcuts for comments e.g. comment out a block of text.
Plug 'scrooloose/nerdcommenter'
" Uses CTags to display a list of tags (functions, etc) in a sidebar.
Plug 'majutsushi/Tagbar'
" Manipulate surrounding text.
Plug 'tpope/vim-surround'
" Useful functionality for Perl
Plug 'vim-perl/vim-perl'
" Browse colour themes.
Plug 'vim-scripts/ScrollColors'
" A whole bunch of themes.
" Plug 'vim-scripts/Colour_Sampler_Pack'
" Improved status bar
Plug 'bling/vim-airline'
" Useful commands for csv files.
" Plug 'chrisbra/csv'
" Insert closing delimiters automatically.
Plug 'Raimondi/delimitMate'
" GUI for vim's undo branches
Plug 'mbbill/undotree'
" Library of snippets
Plug 'honza/vim-snippets'
" Allows diffing blocks within a file, instead of just an entire file.
Plug 'AndrewRadev/linediff.vim'
" Powershell support
Plug 'PProvost/vim-ps1'
" Go support
Plug 'fatih/vim-go'
" Shortcuts for text alignment
Plug 'junegunn/vim-easy-align'
" Pandoc-flavour markwown syntax highlighting
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" Only load these next plugins if we're operating normally. Sometimes (e.g.
" invoked to edit a form, running via a plugin like vsvim) we won't have everything set up correctly to keep
" these plugins happy (meaningful tags, python support, munged path so You Complete Me
" doesn't crash, etc).
if !exists('g:SimplePlugins') && has('python') && !&diff
    " Automatic syntax checking
    Plug 'scrooloose/syntastic'
    " Improved code completion. Needs to be manually installed, because it's
    " picky and fragile.
    Plug 'Valloric/YouCompleteMe'
    " Required for vim-shell and vim-easytags
    Plug 'xolox/vim-misc'
    " Allows command to run async without opening a command prompt on Windows.
    " Required for vim-easytags to run async on Windows
    "Plug 'xolox/vim-shell'
    " Automatic tag generation.
    Plug 'xolox/vim-easytags'
    " A snippet manager
    Plug 'SirVer/ultisnips'
    let g:AdvancedPlugins = 1
else
    let g:AdvancedPlugins = 0
endif
call plug#end()

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

" Don't use conceal in pandoc.
let g:pandoc#syntax#conceal#use=0

" Setup Airline for our status bar.
let g:airline#extensions#whitespace#checks = [ 'indent' ]
let g:airline#extensions#whitespace#mixed_indent_format = 'mi[%s]'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" EasyAlign settings
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

if has('cmdline_info')
    set ruler                   " show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd                 " show partial commands in status line and selected characters/lines in visual mode
endif

if g:AdvancedPlugins == 1
    " Syntastic settings.
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0

    " YouCompleteMe settings
    " Copied (and then modified) based on examples at https://github.com/Valloric/YouCompleteMe/issues/420.
    " UltiSnips and YouCompleteMe really don't play nicely together.
    let g:ulti_expand_or_jump_res = 0
    function ExpandSnippetOrCarriageReturn()
        let snippet = UltiSnips#ExpandSnippetOrJump()
        if g:ulti_expand_or_jump_res > 0
            return snippet
        else
            return "\<C-y>"
        endif
    endfunction
    inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"
    " Use a fallback default config file.
    let g:ycm_global_ycm_extra_conf = '~/conf/.ycm_extra_conf.py'
    " Load the above without warning.
    let g:ycm_extra_conf_globallist = ['~/conf/.ycm_extra_conf.py']
    " Keep log files around for debugging.
    let g:ycm_server_keep_logfiles = 1
    " Easytags setup
    " Run easytags in the background
    " Doesn't actually work, never returns (on Windows at least).
    " let g:easytags_async = 1
    " Use project-specific files if it finds them.
    let g:easytags_dynamic_files = 1
    " Use .tags on windows as well for consistency.
    let g:easytags_file = '~/.vim/tags'
    " UpdateTags only seems to run when the file has been edited and saved. Run it
    " once when we first load the file.
    "autocmd BufReadPost * UpdateTags
    " Speed up syntax highlighting by sacrificing accuracy
    " let g:easytags_syntax_keyword = 'always'
 endif
" Look for tag files in the file's directory, then look in parent directories,
" then the global tags file.
set tags=./tags;
set tags+=tags;
set tags+='~/.vim/tags'

