" VIM Configuration File

" ================= set UTF-8 encoding ========== {{{1
set encoding=utf-8 fenc=utf-8 termencoding=utf-8
scriptencoding utf-8
set nocompatible


" ================= General setup =============== {{{1
augroup vimrc
  autocmd!
augroup END
let g:vimdir = expand('~').'/.config/nvim'

set updatetime=1000
set hidden
if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait'
  set shell=/bin/zsh
endif
set visualbell
set noerrorbells
set clipboard+=unnamedplus

" go to last cursor position upon opening files
autocmd vimrc BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g'\"" | endif

let g:maplocalleader="'"
let g:mapleader=','

if has('conceal')
  set conceallevel=2 concealcursor=n
endif

" ================= Command line ================ {{{1
set showcmd                     "Show incomplete cmds down the bottom
set noshowmode                  "Don't show current mode down the bottom
set shortmess+=c "don't give |ins-completion-menu| messages
set wildmode=longest,full
set wildignore+=*.pyc,__cache__,*.o,*.obj

" ================= Backup Settings ============= {{{1
set writebackup
if !isdirectory(expand('~').'/.config/nvim/.backup')
  silent execute '!mkdir '.g:vimdir.'/.backup > /dev/null 2>&1'
endif
let &backupext = '~' . substitute(expand('%:p'), '/', '%', 'g')
execute 'set backup backupdir='.g:vimdir.'/.backup//'
if !isdirectory(expand('~').'/.config/nvim/.undo')
  silent execute '!mkdir '.g:vimdir.'/.undo > /dev/null 2>&1'
endif
" ending with `//` creates unique names
execute 'set undofile undodir='.g:vimdir.'/.undo//'


" ================= Search ====================== {{{1
set hlsearch
set ignorecase
set smartcase
set inccommand=split  " preview for substitute command


" ================= Caps Lock =================== {{{1
autocmd vimrc VimEnter,FocusGained * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &>/dev/null"
autocmd vimrc VimLeave,FocusLost * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock' &>/dev/null"


" ================= Intention =================== {{{1
set smartindent                 " use indentation of previous line
set cindent                     " Each new line will be automatically indented the correct amount according to
                                " the C indentation standard.
set tabstop=2 shiftwidth=2 softtabstop=2
set expandtab


" ================= Format Options ============== {{{1
set linebreak        " Break line without break the word.
let &showbreak='➣➣\'
set nowrap
set formatoptions+=n " recognize numbered lists
set formatoptions+=2 " use second line for indent for indented paragraphs
set formatoptions+=w " trailing whitespace indicates paragraph continuation
set formatoptions+=t " auto-wrap text
set formatoptions+=q " allow formating of comments with `gq`
set formatoptions+=l " don't break long lines in insert mode
set formatoptions-=r
set formatoptions-=o

let &colorcolumn='80,120,121,122'
set listchars=tab:│\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨,


" ================= Nvim ======================== {{{1
execute 'source '.g:vimdir.'/.pythonprovider.vim'


" ================= Diff-mode =================== {{{1
set diffopt+=vertical

" show the difference between the current buffer and the file it was loaded from
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit# | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

autocmd vimrc BufReadPost * call s:diff_nospell()
function! s:diff_nospell() abort
  if &diff
    setlocal nospell
  endif
endfunction


" ================= Spelling ==================== {{{1
autocmd vimrc BufRead * call s:set_spell()
function! s:set_spell() abort
  if &readonly || !&modifiable
    setlocal nospell
  else
    setlocal spell spelllang=en_us
  endif
endfunction


" ================= Folding ===================== {{{1
set foldmethod=marker
set foldtext=foldtext#custom()




" ================= Completion ================== {{{1
set omnifunc=syntaxcomplete#Complete
set completeopt=menu,preview,longest


" ================= Plug-ins ==================== {{{1
let s:special_buffers = ['help', 'text', 'markdown', 'vimfiler', 'tagbar']
" Make sure you use single quotes
call plug#begin(g:vimdir.'/plugged')
function! s:cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

Plug 'tpope/vim-sensible'

" ----------------- Appearance ------------------- {{{2
" these are relevant if speed-up is desired
Plug 'DerWeh/papercolor-theme' "{{{
let g:papercolor_theme_options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }
"}}}
Plug 'rakr/vim-one'
Plug 'vim-airline/vim-airline' "{{{
Plug 'vim-airline/vim-airline-themes'
"let g:airline_extensions = ['tabline', 'vimagit', 'branch', 'quickfix', 'hunks']
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#branch#vcs_priority = ['git']
let g:airline_detect_spell = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols "{{{
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
"let g:airline_symbols.maxlinenr = ''
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
let g:airline_symbols.paste = 'PASTE'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"" old vim-powerline symbols
"let g:airline_left_sep = '⮀'
"let g:airline_left_alt_sep = '⮁'
"let g:airline_right_sep = '⮂'
"let g:airline_right_alt_sep = '⮃'
"let g:airline_symbols.branch = '⭠'
"let g:airline_symbols.readonly = '⭤'
"let g:airline_symbols.linenr = '⭡'
"}}}
"}}}
Plug 'lukas-reineke/indent-blankline.nvim'

"Plug 'thaerkh/vim-indentguides' "{{{ # possible indent char: │
"let g:indentguides_firstlevel=0
"let g:indentguides_ignorelist = s:special_buffers
""}}}
Plug 'blueyed/cursorcross.vim'
let g:cursorcross_dynamic = 'cw'  " add `l` for cursorline
autocmd vimrc BufEnter * set relativenumber " number
autocmd vimrc BufLeave,WinLeave * set norelativenumber " nonumber
" Plug 'edkolev/promptline.vim', {'on': 'PromptlineSnapshot'}
Plug 'Yggdroot/hiPairs'
let g:hiPairs_stopline_more = 800
let g:hiPairs_timeout = 2
let g:hiPairs_insert_timeout = 2
Plug 'andymass/vim-matchup'



" ----------------- Text Objects ----------------- {{{2
Plug 'kana/vim-textobj-user'
Plug 'gaving/vim-textobj-argument'
Plug 'michaeljsmith/vim-indent-object'
Plug 'glts/vim-textobj-comment'

" ----------------- Auto Completion -------------- {{{2
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

""}}}
"Plug 'Shougo/echodoc.vim' "{{{
"let g:echodoc_enable_at_startup = 1
"let g:echodoc#highlight_arguments='Visual'
"" let g:echodoc#type='virtual'
""}}}
"Plug 'Shougo/neoinclude.vim'
"Plug 'Shougo/neco-syntax'
"Plug 'ujihisa/neco-look'
"Plug 'Shougo/neco-vim'
"if has('nvim-0.4')
"  Plug 'ncm2/float-preview.nvim'
"  let g:echodoc#type='floating'
"  set completeopt-=preview
"endif

" ----------------- Motions ---------------------- {{{2
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'ggandor/lightspeed.nvim'

" ----------------- Editing ---------------------- {{{2
" Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-commentary' " smaller than nerdcommenter, but lack partial and multi-line comments
Plug 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'EasyAlign','<Plug>(LiveEasyAlign)', 'LiveEasyAlign']} "{{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"}}}
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'
Plug 'bfredl/nvim-miniyank' "{{{

map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)

map <C-n> <Plug>(miniyank-cycle)
"}}}
Plug 'junegunn/vim-peekaboo'
Plug 'cohama/lexima.vim'
imap <C-h> <BS>
cmap <C-h> <BS>
Plug 'joom/latex-unicoder.vim'
let g:unicoder_no_map = 1

" ----------------- Search ----------------------- {{{2
Plug 'haya14busa/incsearch.vim', {'on': ['<Plug>(incsearch-forward)', '<Plug>(incsearch-stay)', '<Plug>(incsearch-backward)']} "{{{
let g:incsearch#magic = '\v'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
"}}}
Plug 'haya14busa/vim-asterisk' "{{{
let g:asterisk#keeppos = 1
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
"}}}
Plug 'brooth/far.vim', {'on': ['Far', 'Farp', 'F'], 'do': ':UpdateRemotePlugins'} "{{{
if executable('ag')
  let g:far#source = 'agnvim'
endif

"}}}

" ----------------- Version control -------------- {{{2
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/agit.vim'
Plug 'jreybert/vimagit'
Plug 'lewis6991/gitsigns.nvim/'

" ----------------- Coding ----------------------- {{{2
Plug 'ludovicchabant/vim-gutentags'
" set regexpengine=1  " https://gist.github.com/glts/5646749#file-readme-L8
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ }

" ----------------- Writing ---------------------- {{{2
Plug 'davidbeckingsale/writegood.vim'
Plug 'Ron89/thesaurus_query.vim'

" ----------------- File type -------------------- {{{2
" ~~~~~~~~~~~~~~~~~ Latex ~~~~~~~~~~~~~~~~~~~~~~~~ {{{3
Plug 'lervag/vimtex', {'for': ['latex', 'tex', 'bib'], 'do' : 'pip3 install --user neovim-remote'} " {{{
augroup vimtex
  autocmd!
  autocmd User vimtex call vimtex#imaps#add_map({
        \'lhs':'..', 
        \'rhs':'.<CR>%%<CR>', 
        \'leader': '', 
        \'wrapper' : 'vimtex#imaps#wrap_trivial'
        \})
  autocmd User vimtex call vimtex#imaps#add_map({
        \'lhs':'!!',
        \'rhs':'!<CR>%%<CR>',
        \'leader': '',
        \'wrapper' : 'vimtex#imaps#wrap_trivial'
        \})
  autocmd User vimtex call vimtex#imaps#add_map({
        \'lhs':'??',
        \'rhs':'?<CR>%%<CR>',
        \'leader': '',
        \'wrapper' : 'vimtex#imaps#wrap_trivial'
        \})
augroup END
" }}}
Plug 'DerWeh/quicktex' " , {'for': ['latex', 'tex', 'bib']}
let g:quicktex_dollarcheck = 0  " don't check for $...$

" ~~~~~~~~~~~~~~~~~ RST ~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{3
Plug 'Rykka/riv.vim' ", {'for': ['rst', 'python']} "{{{
let g:riv_python_rst_hl=1
"}}}
Plug 'Rykka/InstantRst', {'on': 'InstantRst', 'do': 'pip install https://github.com/Rykka/instant-rst.py/archive/master.zip --user'}
" ~~~~~~~~~~~~~~~~~ Python ~~~~~~~~~~~~~~~~~~~~~~~ {{{3
Plug 'heavenshell/vim-pydocstring', {'for': 'python'}
Plug 'alfredodeza/pytest.vim', {'on': 'Pytest'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'tmhedberg/simpylfold', {'for': 'python'}  "very slow startup
Plug 'DerWeh/vim-ipython', {'on': ['IPython', 'IPythonNew']}
Plug 'tweekmonster/impsort.vim', {'for': 'python'}
Plug 'vim-scripts/python_match.vim', {'for': 'python'}

" ----------------- Linting ---------------------- {{{2
Plug 'neomake/neomake', { 'do': ':UpdateRemotePlugins'} "{{{
let g:neomake_python_enabled_makers = ['pyflakes', 'pylint']
" let g:neomake_error_sign = {'texthl': 'Debug'}
" augroup my_neomake_highlights
"   autocmd!
"   autocmd ColorScheme *
"         \ hi link NeomakeError SpellBad |
"         \ hi link NeomakeWarning SpellCap
" augroup END
"}}}

" ----------------- Special buffers -------------- {{{2
Plug 'simnalamburt/vim-mundo'
Plug 'kassio/neoterm', {'on': ['T', 'Tnew', 'Tmap', 'Topen', 'Ttoggle'], 'do': ':UpdateRemotePlugins' } " {{{
let g:neoterm_autoscroll = 1
let g:neoterm_fixedsize = 1
let g:neoterm_size = 18
"}}}
Plug 'majutsushi/tagbar' "{{{
let g:tagbar_sort = 0
let g:tagbar_autoshowtag = 1
noremap <F8> <Esc>:Tagbar<CR>
noremap g<F8> <Esc>:TagbarShow<CR>
" }}}
Plug 'vim-scripts/vimwiki', { 'on': ['<Plug>VimwikiIndex','<Plug>VimwikiTabIndex', '<Plug>VimwikiUISelect']}
Plug 'mhinz/vim-startify' "{{{
let g:startify_fortune_use_unicode = 1
let g:startify_custom_header = []
let g:startify_bookmarks = [ {'n': '~/.config/nvim/init.vim'},
      \{'z': '~/.zshrc'},
      \{'p': '~/pyplot'}]
"}}}
Plug 'tweekmonster/startuptime.vim', {'on': ['StartupTime']}

" ----------------- Utility ---------------------- {{{2
Plug 'nixon/vim-vmath' "{{{
vnoremap <silent> ++ y:call VMATH_Analyse()<CR>gv "}}}
Plug 'romainl/vim-qf' "{{{
let g:qf_auto_open_loclist = 0
let g:qf_auto_open_quickfix = 0
let g:qf_mapping_ack_style = 1 "}}}
Plug 'lilydjwg/colorizer', { 'on':  ['<Plug>Colorizer', 'ColorHighlight', 'ColorToggle']} " {{{
let g:colorizer_startup = 0
" }}}
Plug 'chrisbra/vim-diff-enhanced', { 'on': ['PatienceDiff', 'EnhancedDiff']}
Plug 'vim-scripts/vis', {'on': ['B', 'S']}
Plug 'will133/vim-dirdiff', {'on': ['DirDiff']} "{{{
let g:DirDiffExcludes = '.*,*.exe,*.swp'
"}}}
Plug 'andrewradev/linediff.vim', {'on': ['Linediff', 'LinediffAdd']}
Plug 'rickhowe/diffchar.vim'
Plug 'chrisbra/Recover.vim'

" ----------------- Readability ------------------ {{{2
Plug 'junegunn/limelight.vim', {'on': ['Limelight',]} " {{{
" let g:limelight_bop = '^\s*\n^\w'
" let g:limelight_eop = '\ze\n^\s*\n^\w'
"}}}
Plug 'roman/golden-ratio', { 'on': ['<Plug>(golden_ratio_resize)']} " {{{
let g:golden_ratio_autocommand = 0
let g:golden_ratio_exclude_nonmodifiable = 1
" }}}
Plug 'chrisbra/NrrwRgn'

" ----------------- Telescope ----------------------- {{{2
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'folke/todo-comments.nvim'
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'thinca/vim-qfreplace'

" ----------------- Folding ---------------------- {{{2
Plug 'Konfekt/FastFold'

" load last
Plug 'ryanoasis/vim-devicons'
call plug#end()

call gina#core#get()  " needed to work with RiV see Charge reconstruction and Friedel sum rule in heterostructures

" ================= Color settings ============== {{{1
set t_Co=256      " turn syntax highlighting on
set termguicolors
set background=light
colorscheme one
set showmatch     " highlight matching braces
syntax sync minlines=100 maxlines=260
set synmaxcol=800 " Don't try to highlight lines longer than 800 characters,
                  " in order to speed up the view port.
set lazyredraw    " can lead to problems with splits?
set ttyfast

" let g:indent_blankline_char = '│'
let g:indent_blankline_buftype_exclude = ['terminal']
" " let g:indent_blankline_show_current_context = v:true

lua << EOF
require("indent_blankline").setup {
    char = "│",
}
EOF

" ================= Key-mappings ================ {{{1
nnoremap ; :|                          " faster `commands` using ;
nnoremap : ;
vnoremap ; :|                          " faster `commands` using ;
vnoremap : ;

tnoremap <ESC> <C-\><C-n>|
tnoremap <leader><ESC> <ESC>
" nnoremap p p=`]<C-o>|                  " Auto indent pasted text
" nnoremap P P=`]<C-o>|

cabbrev w!! w !sudo tee % >/dev/null|  " writing files needing sudo
nmap Q <Nop>|                          " Remove mapping for `Ex` mode

nnoremap <F2> :w<CR>|                  " save file via F2
inoremap <F2> <ESC>:w<CR>gi|           " save file via F2
set pastetoggle=<F3>|                  " toggle paste mode for pasting code without intend

noremap <leader>h :<C-u>nohl<CR>|      " Remove highlight from search results

vmap < <gv|                            " reselect after shifting indent
vmap > >gv|

imap <c-z> <c-g>u<Esc>[s1z=`]a<c-g>u|  " correct last spelling error
imap <c-l> <Right>
imap <c-a> <c-o>A

" ----------------- Window Management ------------- {{{2
" move with <C-?>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" create new split with c<C-?>
nnoremap c<C-j> :bel sp new<cr>
nnoremap c<C-k> :abo sp new<cr>
nnoremap c<C-h> :lefta vsp new<cr>
nnoremap c<C-l> :rightb vsp new<cr>
" move and focus (resize) with g<C-?>
nnoremap g<C-j> <C-w>j:let &winheight = &lines * 7 / 10<cr>
nnoremap g<C-k> <C-w>k:let &winheight = &lines * 7 / 10<cr>
onoremap g<C-h> <C-w>h<C-w>_
nnoremap g<C-l> <C-w>l<C-w>_
" delete window with d<C-?>
nnoremap d<C-j> <C-w>j<C-w>c
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c
nmap <C-w>r <Plug>(golden_ratio_resize)
nmap <C-w>f <C-w><Bar><C-w>_

" noremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>| " switch between header/source with F4

" ----------------- Plug-in Mappings ------------- {{{2
nnoremap <leader>fe :VimFilerExplorer<CR>
nmap <leader>ct <Plug>Colorizer
nnoremap <silent> <F9> :MundoToggle<CR>
nmap <Leader>ww <Plug>VimwikiIndex
nmap <Leader>wt <Plug>VimwikiTabIndex
nmap <Leader>ws <Plug>VimwikiUISelect
nmap <Leader>ss <plug>(matchup-hi-surround)
inoremap <Leader>ll <Esc>:call unicoder#start(1)<CR>
vnoremap <Leader>ll :<C-u>call unicoder#selection()<CR>

" ----------------- Telescope ----------------- {{{2
nnoremap <F1> <cmd>Telescope help_tags<CR>
nnoremap <leader>/ <cmd>Telescope current_buffer_fuzzy_find<CR>
nnoremap <silent> <space>f <cmd>Telescope find_files<CR>
nnoremap <space>/ <cmd>Telescope live_grep<cr>
nnoremap g<space>/ <cmd>Telescope grep_string<cr>
nnoremap <space>s <cmd>Telescope buffers<cr>
nnoremap <silent> <space>q <cmd>Telescope quickfix<cr>
nnoremap <silent> <space>l <cmd>Telescope loclist<cr>
nnoremap <space>r <cmd>Telescope resume<cr>
nnoremap <space>t <cmd>TodoTelescope<cr>

" =============================================== {{{1
" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

function! s:NextTextObject(motion, dir)
  let l:c = nr2char(getchar())

  if l:c ==# 'b'
      let l:c = '('
  elseif l:c ==# 'B'
      let l:c = '{'
  elseif l:c ==# 'd'
      let l:c = '['
  endif

  exe 'normal! '.a:dir.l:c.'v'.a:motion.l:c
endfunction
" Latex {{{
let g:tex_flavor = 'latex'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
" autocmd vimrc FileType tex,bib nnoremap <LocalLeader><space>l :Denite vimtex_labels<CR>
" autocmd vimrc FileType tex,bib nnoremap <LocalLeader><space>t :Denite vimtex_toc<CR>
" }}}

" Gina {{{
" TODO commits behind remote
call airline#parts#define_function('gina', 'gina#component#repo#branch')
let g:airline_section_b = airline#section#create(['hunks', g:airline_symbols.branch,'gina'])
call gina#custom#execute('commit', 'setlocal spell')
" call gina#custom#execute('commit', "call committia#open('git')")
"}}}

" neomake {{{
call neomake#configure#automake('wrin')
"}}}

" ===============================================

let g:coq_settings = { 'auto_start': v:true }
lua << EOF
require('telescope').load_extension('media_files')
require'telescope'.setup {
  extensions = {
    media_files = {
      find_cmd = "rg"
    }
  },
}
require('gitsigns').setup()
require('todo-comments').setup {}
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
  { src = "vimtex", short_name = "vTEX" },
  { src = "bc", short_name = "MATH", precision = 6 },
}
EOF
