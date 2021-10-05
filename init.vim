" VIM Configuration File

" ================= set UTF-8 encoding ========== {{{1
set encoding=utf-8 fenc=utf-8 termencoding=utf-8
scriptencoding utf-8
set nocompatible


" ================= General setup =============== {{{1
augroup vimrc
  autocmd!
augroup END
let g:vimdir = stdpath('config')

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

let g:maplocalleader="\\"
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
" not working, <C> triggers FocusLost -> FocusGained
" autocmd vimrc VimEnter,FocusGained * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &>/dev/null"
" autocmd vimrc VimLeave,FocusLost * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock' &>/dev/null"


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
set listchars=tab:│\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨


" ================= Nvim ======================== {{{1
execute 'source '.g:vimdir.'/.pythonprovider.vim'


" ================= Diff-mode =================== {{{1
set diffopt+=vertical,hiddenoff,algorithm:patience,indent-heuristic

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
autocmd vimrc BufNewFile,BufRead * call s:set_spell()
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

Plug 'folke/which-key.nvim'

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
Plug 'Th3Whit3Wolf/one-nvim'
Plug 'famiu/feline.nvim'
Plug 'hoob3rt/lualine.nvim'
"}}}
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'blueyed/cursorcross.vim'
Plug 'auwsmit/vim-active-numbers'
set relativenumber number
let g:actnum_exclude =
      \ ['TelescopePrompt', 'tagbar', 'startify', 'undotree', 'gundo', 'terminal', 'w3m', 'gina-blame']
autocmd vimrc TermOpen * :set filetype=terminal norelativenumber nonumber
Plug 'andymass/vim-matchup'
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_hi_surround_always = 1
let g:matchup_matchparen_offscreen = {'method': 'popup'}



" ----------------- Text Objects ----------------- {{{2
Plug 'kana/vim-textobj-user'
Plug 'gaving/vim-textobj-argument'
Plug 'michaeljsmith/vim-indent-object'
Plug 'glts/vim-textobj-comment'

" ----------------- Auto Completion -------------- {{{2
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

"Plug 'Shougo/neoinclude.vim'
"Plug 'Shougo/neco-syntax'
"Plug 'ujihisa/neco-look'
"Plug 'Shougo/neco-vim'
if has('nvim-0.4')
  Plug 'ncm2/float-preview.nvim'
  let g:echodoc#type='floating'
  set completeopt-=preview
endif

" ----------------- Motions ---------------------- {{{2
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'ggandor/lightspeed.nvim'

" ----------------- Editing ---------------------- {{{2
Plug 'tpope/vim-commentary' " smaller than nerdcommenter, but lack partial and multi-line comments
Plug 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'EasyAlign','<Plug>(LiveEasyAlign)', 'LiveEasyAlign']} "{{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"}}}
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'bfredl/nvim-miniyank' "{{{
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
map <C-n> <Plug>(miniyank-cycle)
"}}}

Plug 'windwp/nvim-autopairs'
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

" ----------------- Version control -------------- {{{2
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/agit.vim'
Plug 'jreybert/vimagit'
Plug 'lewis6991/gitsigns.nvim/'

" ----------------- Coding ----------------------- {{{2
Plug 'ludovicchabant/vim-gutentags'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'

" ----------------- Writing ---------------------- {{{2
Plug 'davidbeckingsale/writegood.vim'
Plug 'Ron89/thesaurus_query.vim'

" ----------------- File type -------------------- {{{2
" ~~~~~~~~~~~~~~~~~ Latex ~~~~~~~~~~~~~~~~~~~~~~~~ {{{3
Plug 'lervag/vimtex', {'for': ['latex', 'tex', 'bib'], 'do' : 'pip install --user neovim-remote'} " {{{
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
Plug 'tweekmonster/impsort.vim', {'for': 'python'}
Plug 'vim-scripts/python_match.vim', {'for': 'python'}
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'mnacamura/iron.nvim'

" ----------------- Linting ---------------------- {{{2
Plug 'neomake/neomake', { 'do': ':UpdateRemotePlugins'} "{{{
let g:neomake_python_enabled_makers = ['pyflakes', 'pylint', 'pydocstyle']
" let g:neomake_logfile = '/ltmp/neomake.log'
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
Plug 'vim-scripts/vis', {'on': ['B', 'S']}
Plug 'will133/vim-dirdiff', {'on': ['DirDiff']} "{{{
let g:DirDiffExcludes = '.*,*.exe,*.swp'
"}}}
Plug 'andrewradev/linediff.vim', {'on': ['Linediff', 'LinediffAdd']}
Plug 'rickhowe/diffchar.vim'
Plug 'chrisbra/Recover.vim'
Plug 'alpertuna/vim-header'
let g:header_field_author = 'Weh Andreas'
let g:header_field_author_email = 'andreas.weh@physik.uni-augsburg.de'
let g:header_auto_update_header = 0

" ----------------- Readability ------------------ {{{2
Plug 'junegunn/limelight.vim', {'on': ['Limelight',]} " {{{
" let g:limelight_bop = '^\s*\n^\w'
" let g:limelight_eop = '\ze\n^\s*\n^\w'
"}}}
Plug 'roman/golden-ratio', { 'on': ['<Plug>(golden_ratio_resize)']} " {{{
let g:golden_ratio_autocommand = 0
let g:golden_ratio_exclude_nonmodifiable = 1
" }}}

" ----------------- Telescope ----------------------- {{{2
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'thinca/vim-qfreplace'

" ----------------- Folding ---------------------- {{{2
Plug 'Konfekt/FastFold'

" load last
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

call gina#core#get()  " needed to work with RiV see Charge reconstruction and Friedel sum rule in heterostructures

" ================= Color settings ============== {{{1
set t_Co=256      " turn syntax highlighting on
set termguicolors
set background=light
let g:one_allow_italics=1
colorscheme one
call one#highlight('Folded', 'cccccc', '', 'bold,underline')
set showmatch     " highlight matching braces
syntax sync minlines=100 maxlines=260
set synmaxcol=800 " Don't try to highlight lines longer than 800 characters,
                  " in order to speed up the view port.
set lazyredraw    " can lead to problems with splits?
set ttyfast
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

" let g:indent_blankline_char = '│'
let g:indent_blankline_buftype_exclude = ['terminal', 'help']
" " let g:indent_blankline_show_current_context = v:true


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
" move and focus (resize) with g<C-?>
nnoremap g<C-j> <C-w>j:let &winheight = &lines * 7 / 10<cr>
nnoremap g<C-k> <C-w>k:let &winheight = &lines * 7 / 10<cr>
onoremap g<C-h> <C-w>h<C-w>_
nnoremap g<C-l> <C-w>l<C-w>_

" noremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>| " switch between header/source with F4

" ----------------- Plug-in Mappings ------------- {{{2
inoremap <Leader>ll <Esc>:call unicoder#start(1)<CR>
vnoremap <Leader>ll :<C-u>call unicoder#selection()<CR>


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
call gina#custom#execute('commit', 'setlocal spell')
" call gina#custom#execute('commit', "call committia#open('git')")
"}}}

" neomake {{{
call neomake#configure#automake('wrin')
"}}}

" ===============================================

let g:coq_settings = {'auto_start': 'shut-up', 'display.pum.fast_close': v:false}

runtime plugin_config.lua
runtime which_key.lua
