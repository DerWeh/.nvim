" VIM Configuration File

" ================= set UTF-8 encoding ========== {{{1
set encoding=utf-8 fenc=utf-8 termencoding=utf-8
scriptencoding utf-8
set nocompatible


" ================= General setup =============== {{{1
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
set inccommand=split  " preview for substitute command


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
set nowrap
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
let s:special_buffers = ['help', 'text', 'markdown', 'vimfiler', 'tagbar']
" Make sure you use single quotes
call plug#begin(s:vimdir.'/plugged')
function! s:cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

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
Plug 'nathanaelkane/vim-indent-guides' " would be faster then indentLine
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = s:special_buffers

"Plug 'thaerkh/vim-indentguides' "{{{ # possible indent char: │
"let g:indentguides_firstlevel=0
"let g:indentguides_ignorelist = s:special_buffers
""}}}
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
let g:deoplete#enable_at_startup = 0
autocmd vimrc InsertEnter * call deoplete#enable()
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
Plug 'ujihisa/neco-look'

" ----------------- Motions ---------------------- {{{2
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'justinmk/vim-sneak' "{{{
let g:sneak#label = 1
"}}}
" Plug 'easymotion/vim-easymotion'

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
Plug 'vim-scripts/YankRing.vim' " {{{
" don't populate yank ring with singe elements
let g:yankring_min_element_length = 2
" only works if you have Vim with clipboard support
if has('clipboard')
  let g:yankring_manual_clipboard_check = 1
endif
let g:yankring_replace_n_nkey = '<C-n>'
let g:yankring_replace_n_pkey = '<C-p>'
Plug 'machakann/vim-highlightedyank'
"}}}
Plug 'junegunn/vim-peekaboo'

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
Plug 'brooth/far.vim', {'on': ['Far', 'Farp', 'F'], 'do': ':UpdateRemotePlugins'} "{{{
if executable('ag')
  let g:far#source = 'agnvim'
endif

"}}}

" ----------------- Version control -------------- {{{2
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/agit.vim'
Plug 'jreybert/vimagit'
Plug 'mhinz/vim-signify' "{{{
let g:signify_vcs_list = ['git']
"}}}

" ----------------- Coding ----------------------- {{{2
Plug 'ludovicchabant/vim-gutentags'
" set regexpengine=1  " https://gist.github.com/glts/5646749#file-readme-L8
Plug 'autozimu/LanguageClient-neovim', { 'do':
      \ ':!pip install --user -U python-language-server <bar> UpdateRemotePlugins'
      \ }

let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ }

" ----------------- File type -------------------- {{{2
" ~~~~~~~~~~~~~~~~~ Latex ~~~~~~~~~~~~~~~~~~~~~~~~
Plug 'lervag/vimtex', {'for': ['latex', 'tex'], 'do' : 'pip3 install --user neovim-remote'}
" ~~~~~~~~~~~~~~~~~ RST ~~~~~~~~~~~~~~~~~~~~~~~~~~
Plug 'Rykka/riv.vim', {'for': ['rst']} "{{{
" let g:riv_python_rst_hl=1
"}}}
Plug 'Rykka/InstantRst', {'on': 'InstantRst', 'do': 'pip install https://github.com/Rykka/instant-rst.py/archive/master.zip --user'}
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Plug 'heavenshell/vim-pydocstring', {'for': 'python'}
Plug 'alfredodeza/pytest.vim', {'on': 'Pytest'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
" Plug 'tmhedberg/SimpylFold', {'for': 'python'}  "very slow startup
Plug 'DerWeh/vim-ipython', {'on': ['IPython', 'IPythonNew']}
Plug 'tweekmonster/impsort.vim', {'for': 'python'}
Plug 'vim-scripts/python_match.vim', {'for': 'python'}

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
" Plug 'vim-scripts/TaskList.vim' " replaced by Denite:grep
Plug 'andrewradev/linediff.vim', {'on': ['Linediff', 'LinediffAdd']}

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

" ----------------- Denite ----------------------- {{{2
Plug 'Shougo/denite.nvim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite-session'
Plug 'osyo-manga/unite-quickfix'
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'thinca/vim-qfreplace'
Plug 'Shougo/vimfiler.vim' | Plug 'romgrk/vimfiler-prompt', { 'on' : 'VimFilerPrompt'}
let g:vimfiler_as_default_explorer = 1
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" ----------------- Folding ---------------------- {{{2
Plug 'Konfekt/FastFold'

call plug#end()


" ================= Color settings ============== {{{1
set t_Co=256      " turn syntax highlighting on
set termguicolors
set background=light
colorscheme one
syntax enable     " keeps highlighting
set showmatch     " highlight matching braces
syntax sync minlines=100 maxlines=260
set synmaxcol=800 " Don't try to highlight lines longer than 800 characters,
                  " in order to speed up the view port.
set lazyredraw    " can lead to problems with splits?
set ttyfast

" ================= Key-mappings ================ {{{1
nnoremap ; :|                          " faster `commands` using ;
nnoremap : ;
vnoremap ; :|                          " faster `commands` using ;
vnoremap : ;

tnoremap <ESC> <C-\><C-n>
nnoremap p p=`]<C-o>|                  " Auto indent pasted text
nnoremap P P=`]<C-o>|

cabbrev w!! w !sudo tee % >/dev/null| " writing files needing sudo
nmap Q <Nop>|                          " Remove mapping for `Ex` mode

nnoremap <F2> :w<CR>|                  " save file via F2
inoremap <F2> <C-o>:w<CR>|             " save file via F2
set pastetoggle=<F3>|                  " toggle paste mode for pasting code without intend

noremap <leader>h :<C-u>nohl<CR>|      " Remove highlight from search results

vmap < <gv                             " reselect after shifting indent
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
nmap <C-w>r <Plug>(golden_ratio_resize)
nmap <C-w>f <C-w><Bar><C-w>_

" noremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>| " switch between header/source with F4

" ----------------- Plug-in Mappings ------------- {{{2
nnoremap <leader>fe :VimFilerExplorer<CR>
nmap <leader>ct <Plug>Colorizer
nnoremap <silent> <F10> :YRShow<CR>
nnoremap <silent> <F9> :MundoToggle<CR>
nmap <Leader>ww <Plug>VimwikiIndex
nmap <Leader>wt <Plug>VimwikiTabIndex
nmap <Leader>ws <Plug>VimwikiUISelect

" ----------------- Denite/Unite ----------------- {{{2
nnoremap <F1> :Denite -buffer-name=help help<CR>
nnoremap [unite] <Nop>
nmap <leader>u [unite]
nnoremap [unite] :Unite |
nnoremap [unite]b :Unite -buffer-name=bookmark bookmark<cr>
nnoremap [unite]/ :Unite -buffer-name=search line:forward -start-insert -no-quit -custom-line-enable-highlight<CR>
nnoremap <leader>/ :Denite -buffer-name=search line -auto-highlight -auto-resize<CR>
nnoremap <silent> <space>f :Denite -buffer-name=files -short-source-names file_rec file_old<CR>
nnoremap <space>/ :Denite -buffer-name=grep -no-empty grep:.<cr>
nnoremap <space><leader>/ :Denite -buffer-name=grep grep:.::!<cr>
nnoremap <space>t :Denite -buffer-name=Task_List -auto-highlight grep:.:-s:FIXME\|TODO\|XXX<cr>
nnoremap <space><leader>t :Denite -buffer-name=Task_List -auto-highlight grep:-s:FIXME\|TODO\|XXX<cr>
nnoremap <space>s :Unite -buffer-name=buffers -quick-match buffer<cr>

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
let g:vimtex_latexmk_progname = 'nvr'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
" }}}

" Denite "{{{
if executable('ag')
  call denite#custom#var('file_rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts', ['-i', '--hidden'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/', 'tags'])


" call denite#custom#var('menu', 'menus', s:menus)
let s:menus = {}

let s:menus.search = {
      \ 'description': 'Search using grep'
      \ }

let s:menus.search.command_candidates = [
      \ ['▷ Grep in CURRENT directory                     ⌘ <space>//',
          \ 'Denite -buffer-name=grep grep:.'],
      \ ['▷ Grep in CUSTOM directory                     ⌘ <space>/',
          \ 'Denite -buffer-name=grep grep:`input("Enter directory: ")`'],
      \ ['▷ Grep for CURSORWORD                     ⌘ <space>/',
          \ 'DeniteCursorWord -buffer-name=grep grep:.'],
      \]

call denite#custom#var('menu', 'menus', s:menus)
"}}}

" Unite "{{{
if executable('ag') == 1
  "let g:unite_source_grep_command = 'ag'
  let g:unite_source_rec_async_command =
        \['ag', '--follow', '--nocolor', '--hidden', '-g', '']
  "let g:unite_source_grep_default_opts =
        "\ '-i --vimgrep --hidden --ignore ' .
        "\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
endif

call unite#custom#profile('default', 'context', {
\   'direction': 'botright',
\ })
call unite#custom#profile('outline', 'context', {'direction': 'topleft'})

call unite#custom_source('file_rec,file_rec/async,file_rec/neovim,file_mru,file,buffer,grep',
    \ 'ignore_pattern', join([
    \ '\.git/',
    \ '__cache__/',
    \ '\.undo/',
    \ '\.backup/',
    \ '__pycache__/',
    \ ], '\|'))

call unite#custom#source('files,file,file/async,file/new,buffer, '.
      \ 'file_rec,file_rec/async, file_rec/git, file_rec/neovim, file_mru, '.
      \ 'file_include, file_list, file_point', 'matchers', 'matcher_fuzzy')


call unite#custom#profile('action', 'context', {
      \ 'start_insert' : 1
      \ })
"}}}

" TODO commits behind remote
call airline#parts#define_function('gina', 'gina#component#repo#branch')
let g:airline_section_b = airline#section#create(['hunks', g:airline_symbols.branch,'gina'])
" ===============================================
