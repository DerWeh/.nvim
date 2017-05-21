" VIM Configuration File

" ================= set UTF-8 encoding ========== {{{1
set encoding=utf-8 fenc=utf-8 termencoding=utf-8
scriptencoding utf-8
set nocompatible


" ================= general setup =============== {{{1
filetype plugin indent on
set backspace=2
augroup vimrc
  autocmd!
augroup END
let s:vimdir = expand('~').'/.config/nvim'

set autoread                    "Reload files changed outside vim
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
set laststatus=2
set wildmenu
set wildmode=longest,full
set wildignore+=*.pyc,__cache__,*.o,*.obj

" ================= Backup Settings ============= {{{1
set writebackup
if !isdirectory(expand('~').'/.config/nvim/.backup')
  silent execute '!mkdir '.s:vimdir.'/.backup > /dev/null 2>&1'
endif
let &backupext = '~' . substitute(expand('%:p'), '/', '%', 'g')
execute 'set backup backupdir='.s:vimdir.'/.backup//'
if !isdirectory(expand('~').'/.config/nvim/.undo')
  silent execute '!mkdir '.s:vimdir.'/.undo > /dev/null 2>&1'
endif
" ending with `//` creates unique names
execute 'set undofile undodir='.s:vimdir.'/.undo//'


" ================= Search ====================== {{{1
set incsearch
set hlsearch
set ignorecase
set smartcase


" ================= Caps Lock =================== {{{1
autocmd vimrc VimEnter,FocusGained * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'"
autocmd vimrc VimLeave,FocusLost * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'"


" ================= Intention =================== {{{1
set autoindent
set smartindent                 " use indentation of previous line
set cindent                     " Each new line will be automatically indented the correct amount according to
                                " the C indentation standard.
set smarttab
set tabstop=2 shiftwidth=2 softtabstop=2
set expandtab


" ================= Format Options ============== {{{1
set linebreak        " Break line without break the word.
let &showbreak='➣➣\'
set formatoptions+=n " recognize numbered lists
set formatoptions+=2 " use second line for indent for indented paragraphs
set formatoptions+=w " trailing whitespace indicates paragraph continuation
set formatoptions+=t " auto-wrap text
set formatoptions+=q " allow formating of comments with `gq`
set formatoptions+=l " don't break long lines in insert mode
set formatoptions+=j " remove comment leader when joining lines
set formatoptions-=r
set formatoptions-=o

let &colorcolumn='80,'.join(range(120,999),',')


" ================= Nvim ======================== {{{1
execute 'source '.s:vimdir.'/.pythonprovider.vim'


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
function! CustomFoldText()
  "get first non-blank line
  let l:fs = v:foldstart
  while getline(l:fs) =~ '^\s*$' | let l:fs = nextnonblank(l:fs + 1)
  endwhile
  if l:fs > v:foldend
    let l:line = getline(v:foldstart)
  else
    let l:line = substitute(getline(l:fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  "strip foldmarkers
  let l:markexpr = escape(substitute(&foldmarker, ',', '|', 'g'),'{')
  " TODO: check comment sign for filetype, add first line if comment
  let l:whitespace = '(\w\s*)?["|#]\s*|\s*$'
  let l:strip_line = substitute(l:line, '\v'.l:markexpr.'|'.l:whitespace, '', 'g')
  let l:strip_line = substitute(l:strip_line, '\v'.l:whitespace, '', 'g')
  let l:strip_line = substitute(l:strip_line, '\v^(\s*)', '\1<', '').'>'
  let l:w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let l:foldSize = 1 + v:foldend - v:foldstart
  let l:foldSizeStr = ' ' . l:foldSize . ' lines '
  let l:foldLevelStr = repeat('+--', v:foldlevel)
  let l:lineCount = line('$')
  let l:foldPercentage = printf('[%.1f', (l:foldSize*1.0)/l:lineCount*100) . '%] '
  let l:expansionString = repeat('.', l:w - strwidth(l:foldSizeStr.strip_line.foldLevelStr.foldPercentage))
  return l:strip_line . l:expansionString . l:foldSizeStr . l:foldPercentage . l:foldLevelStr
endfunction
set foldtext=CustomFoldText()


" ================= Completion ================== {{{1
set omnifunc=syntaxcomplete#Complete
set completeopt=menu,preview,longest


" ================= Plug-ins ==================== {{{1
" Make sure you use single quotes
call plug#begin(s:vimdir.'/plugged')
function! s:cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

" ----------------- Appearance ------------------ {{{2
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
Plug 'vim-airline/vim-airline' "{{{
Plug 'vim-airline/vim-airline-themes'
"let g:airline_extensions = ['tabline', 'vimagit', 'branch', 'quickfix', 'hunks']
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#branch#enabled = 1
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
Plug 'ryanoasis/vim-devicons'
"Plug 'nathanaelkane/vim-indent-guides' " would be faster then indentLine
"Plug 'Yggdroot/indentLine' "{{{
"let g:indentLine_fileTypeExclude = ['help', 'text', 'markdown', 'vimfiler', 'tagbar']
"let g:indentLine_setConceal = 0
"let g:indentLine_showFirstIndentLevel = 1
"let g:indentLine_first_char = '│'
""}}}
Plug 'thaerkh/vim-indentguides' "{{{
let g:indentguides_firstlevel=0
let g:indentguides_ignorelist = ['help', 'text', 'markdown', 'vimfiler', 'tagbar']
"}}}
Plug 'blueyed/cursorcross.vim'
"Plug 'edkolev/promptline.vim', {'on': 'PromptlineSnapshot'}

" ----------------- Text Objects ----------------- {{{2
Plug 'kana/vim-textobj-user'
Plug 'gaving/vim-textobj-argument'
Plug 'michaeljsmith/vim-indent-object'
Plug 'glts/vim-textobj-comment'

" ----------------- Auto Completion -------------- {{{2
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "{{{
Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets'
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#auto_completion_start_length = 2
" increase limit for tag cache files
let g:deoplete#sources#tags#cache_limit_size = 16777216 " 16MB
" default: 100, more to get more methods (e.g. np.<TAB>)
let g:deoplete#max_list = 1000
let g:neosnippet#enable_completed_snippet = 1
let g:deoplete#omni#input_patterns = {}

" mappings "{{{
function! s:check_back_space() "{{{
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~ '\s'
endfunction "}}}

inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' :
      \ <SID>check_back_space() ? '<S-TAB>' :
      \ deoplete#manual_complete()
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><TAB>
      \ pumvisible() ? '<C-n>' :
      \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
      \ ! <SID>check_back_space() ? deoplete#mappings#manual_complete():
      \ "\<TAB>"

imap <c-j> <Plug>(neosnippet_expand_or_jump)
smap <c-j> <Plug>(neosnippet_expand_or_jump)
xmap <c-j> <Plug>(neosnippet_expand_target)
"}}}
"}}}
Plug 'Shougo/echodoc.vim' "{{{
let g:echodoc_enable_at_startup = 1
let g:echodoc#highlight_arguments='Visual'
"}}}
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-syntax'
Plug 'zchee/deoplete-jedi', {'for': ['python']}

" ----------------- Motions ---------------------- {{{2
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'justinmk/vim-sneak' "{{{
let g:sneak#label = 1
"}}}

" ----------------- Editing ---------------------- {{{2
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'EasyAlign','<Plug>(LiveEasyAlign)', 'LiveEasyAlign']} "{{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"}}}
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/YankRing.vim' " {{{
" don't populate yank ring with singe elements
let g:yankring_min_element_length = 2
" only works if you have Vim with clipboard support
if has('clipboard')
  let g:yankring_manual_clipboard_check = 1
endif
let g:yankring_replace_n_nkey = '<C-n>'
let g:yankring_replace_n_pkey = '<C-p>'
"}}}

" ----------------- Search ----------------------- {{{2
Plug 'google/vim-searchindex'
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
Plug 'brooth/far.vim', {'on': ['Far', 'Farp', 'F'], 'do': 'UpdateRemotePlugins'} "{{{
if executable('ag')
  let g:far#source = 'agnvim'
endif

"}}}

" ----------------- Version control -------------- {{{2
Plug 'tpope/vim-fugitive' | Plug 'gregsexton/gitv', { 'on': ['Gitv']}
Plug 'jreybert/vimagit'
Plug 'mhinz/vim-signify' "{{{
let g:signify_vcs_list = ['git']
"}}}

" ----------------- Linting ---------------------- {{{2
Plug 'neomake/neomake', { 'do': ':UpdateRemotePlugins'}
      \| Plug 'dojoteef/neomake-autolint' "{{{
let g:neomake_python_enabled_makers = ['pyflakes', 'pylint']
let g:neomake_autolint_sign_column_always = 1
let g:neomake_error_sign = {'texthl': 'Debug'}
augroup my_neomake_highlights
  autocmd!
  autocmd ColorScheme *
        \ hi link NeomakeError SpellBad |
        \ hi link NeomakeWarning SpellCap
augroup END
"}}}

" ----------------- Special buffers -------------- {{{2
Plug 'mbbill/undotree', {'on': ['UndotreeShow', 'UndotreeToggle']}
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

call plug#end()


" ================= Color settings ============== {{{1
set t_Co=256      " turn syntax highlighting on
set termguicolors
set background=light
colorscheme PaperColor
syntax enable     " keeps highlighting  ;
highlight ExtraWhitespace ctermbg=LightRed guibg=#ffafd7
autocmd vimrc InsertLeave * match ExtraWhitespace /\s\+$/
                  " Show whitespace
set showmatch     " highlight matching braces
syntax sync minlines=100 maxlines=260
set synmaxcol=800 " Don't try to highlight lines longer than 800 characters,
                  " in order to speed up the view port.
set lazyredraw    " can lead to problems with splits?
set ttyfast

" ================= Key-mappings ================ {{{1
nnoremap ; :|                                                      " faster `commands` using ;
nnoremap : ;
vnoremap ; :|                                                      " faster `commands` using ;
vnoremap : ;

nnoremap p p=`]<C-o>|                                              " Auto indent pasted text
nnoremap P P=`]<C-o>|

cabbrev w!! w !sudo tee % >/dev/null| " writing files needing sudo
nmap Q <Nop>|                          " Remove mapping for `Ex` mode

nnoremap <F2> :w<CR>|                                              " save file via F2
inoremap <F2> <C-o>:w<CR>|                                         " save file via F2
set pastetoggle=<F3>| " toggle paste mode for pasting code without intend

noremap <leader>h :<C-u>nohl<CR>|                                      " Remove highlight from search results

vmap < <gv " reselect after shifting indent
vmap > >gv

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


" =============================================== {{{1

" ===============================================
