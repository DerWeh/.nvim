" VIM Configuration File

" set UTF-8 encoding
set encoding=utf-8 fenc=utf-8 termencoding=utf-8
set nocompatible

" ================ General Config ====================
set showcmd                     "Show incomplete cmds down the bottom
set noshowmode                  "Don't show current mode down the bottom
set autoread                    "Reload files changed outside vim
set visualbell
set noerrorbells
set diffopt+=vertical
set shortmess+=c

let g:maplocalleader="'"
let g:mapleader=','

set clipboard+=unnamedplus
filetype plugin indent on


set backspace=2


" ================ Backup Settings===================
set writebackup
if !isdirectory(expand('~').'/.config/nvim/.backup')
  silent !mkdir ~/.config/nvim/.backup > /dev/null 2>&1
endif
let &backupext = '~' . substitute(expand('%:p'), '/', '%', 'g')
set backup backupdir=~/.config/nvim/.backup//
if !isdirectory(expand('~').'/.config/nvim/.undo')
  silent !mkdir ~/.config/nvim/.undo > /dev/null 2>&1
endif
set undofile undodir=~/.config/nvim/.undo//  " ending with `//` creates unique names


"" ================ Caps Lock ========================
au VimEnter,FocusGained * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'"
au VimLeave,FocusLost * :silent exec "!xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'"


" ================ Indentation ======================
set autoindent
set smartindent                 " use indentation of previous line
set cindent                     " Each new line will be automatically indented the correct amount according to
                                " the C indentation standard.
set smarttab
set tabstop=2 shiftwidth=2 softtabstop=2
set expandtab


" ================ Completion =======================
set wildmenu
set wildmode=longest,full
set wildignore+=*.pyc,__cache__,*.o,*.obj


" ================ Search ===========================
set incsearch
set hlsearch
set ignorecase
set smartcase

set omnifunc=syntaxcomplete#Complete
set completeopt=menu,preview,longest

"sometimes increases performance
set lazyredraw " can lead to problems with splits?
set ttyfast

let &colorcolumn='80,'.join(range(120,999),',')


" =============== nvim =============================
source ~/.config/nvim/.pythonprovider.vim

" =============== Plug-in Management =================={{{
call plug#begin('~/.config/nvim/plugged')
function! Cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

" Make sure you use single quotes
" --------------- On-demand loading -------------------
Plug 'lilydjwg/colorizer', { 'on':  ['<Plug>Colorizer', 'ColorHighlight', 'ColorToggle']} " {{{
let g:colorizer_startup = 0
"let g:colorizer_maxlines = 800
" }}}
Plug 'chrisbra/vim-diff-enhanced', { 'on': ['PatienceDiff', 'EnhancedDiff']}
Plug 'vim-scripts/vimwiki', { 'on': ['<Plug>VimwikiIndex','<Plug>VimwikiTabIndex', '<Plug>VimwikiUISelect']} "{{{
" let g:vimwiki_folding = 'expr'
let g:vimwiki_table_mappings = 0
function! VimwikiLinkHandler(link) "{{{ Use Vim to open links with the
  " 'vlocal:' or 'vfile:' schemes.  E.g.:
  "   1) [[vfile:///~/Code/PythonProject/abc123.py]], and
  "   2) [[vlocal:./|Wiki Home]]
  let s:link = a:link
  if s:link =~ 'vlocal:' || s:link =~ 'vfile:'
    let s:link = s:link[1:]
  else
    return 0
  endif
  let [idx, scheme, path, subdir, lnk, ext, url] =
       \ vimwiki#base#resolve_scheme(s:link, 0)
  if g:vimwiki_debug
    echom 'LinkHandler: idx='.idx.', scheme=[v]'.scheme.', path='.path.
         \ ', subdir='.subdir.', lnk='.lnk.', ext='.ext.', url='.url
  endif
  if url == ''
    echom 'Vimwiki Error: Unable to resolve link!'
    return 0
  else
    call vimwiki#base#edit_file('tabnew', url, [], 0)
    return 1
  endif
endfunction " }}}
"}}}
Plug 'roman/golden-ratio', { 'on': ['<Plug>(golden_ratio_resize)']} " {{{
let g:golden_ratio_autocommand = 0
let g:golden_ratio_exclude_nonmodifiable = 1
" }}}
Plug 'junegunn/limelight.vim', {'on': ['Limelight',]} " {{{
" let g:limelight_bop = '^\s*\n^\w'
" let g:limelight_eop = '\ze\n^\s*\n^\w'
"}}}
Plug 'will133/vim-dirdiff', {'on': ['DirDiff']}
let g:DirDiffExcludes = ".*,*.exe,*.swp"
Plug 'chrisbra/NrrwRgn'

Plug 'tpope/vim-speeddating'
Plug 'dhruvasagar/vim-table-mode'

" ------------------- Python --------------------------
Plug 'heavenshell/vim-pydocstring', { 'for': 'python', 'on':  '<Plug>pydocstring'}
Plug 'alfredodeza/pytest.vim', { 'for': 'python', 'on': 'Pytest'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'tmhedberg/SimpylFold', {'for': 'python'}
Plug 'davidhalter/jedi-vim', {'for': 'python'} "{{{
let g:jedi#force_py_version = 2
"}}}
Plug 'vim-python/python-syntax', {'for': 'python'} "{{{
let g:python_highlight_builtins = 1
let g:python_highlight_builtin_funcs = 1
let g:python_highlight_builtin_objs = 1
let g:python_highlight_builtin_funcs_kwarg = 0
let g:python_highlight_exceptions = 1
let g:python_highlight_string_formatting = 1
let g:python_highlight_string_format = 1
let g:python_highlight_string_templates = 1
let g:python_highlight_indent_errors = 0
let g:python_highlight_space_errors = 0
let g:python_highlight_doctests = 1
let g:python_highlight_class_vars = 1
let g:python_highlight_operators = 0
let g:python_highlight_file_headers_as_comments = 1
"}}}

" ------------------- tex -----------------------------
Plug 'lervag/vimtex'

" ------------------- rst -----------------------------
Plug 'Rykka/riv.vim', {'for': ['rst']}
" let g:riv_python_rst_hl=1
Plug 'Rykka/InstantRst', {'on': 'InstantRst', 'do': 'pip install https://github.com/Rykka/instant-rst.py/archive/master.zip --user'}

" ------------------- Unite --------------------------
Plug 'Shougo/unite.vim'
      \ | Plug 'Shougo/unite-outline' | Plug 'Shougo/unite-session'
      \ | Plug 'osyo-manga/unite-quickfix' | Plug 'Shougo/unite-outline'
      \ | Plug 'kmnk/vim-unite-giti' | Plug 'rafaqz/citation.vim'
let g:citation_vim_bibtex_file='~/citation/out.bib'
let g:citation_vim_mode='bibtex'
let g:citation_vim_cache_path='~/.config/nvim/cache'
Plug 'thinca/vim-qfreplace', {'on': 'Qfreplace'}
Plug 'Shougo/vimfiler.vim' | Plug 'romgrk/vimfiler-prompt', { 'on' : 'VimFilerPrompt', 'for' : 'vimfiler'}
let g:vimfiler_as_default_explorer = 1

let g:vimfiler_as_default_explorer = 1
Plug 'majutsushi/tagbar' "{{{
let g:tagbar_sort = 0
" }}}

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'spiiph/vim-space' " {{{
let g:space_no_character_movements = 1
"}}}
Plug 'tpope/vim-fugitive' | Plug 'gregsexton/gitv', { 'on': ['Gitv']}
Plug 'jreybert/vimagit'
Plug 'Konfekt/FastFold'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/TaskList.vim'
Plug 'vim-scripts/YankRing.vim' " {{{
" don't populate yank ring with singe elements
let g:yankring_min_element_length = 2
" let g:yankring_record_insert = 1
" only works if you have Vim with clipboard support
if has('clipboard')
  let g:yankring_manual_clipboard_check = 1
endif
let g:yankring_replace_n_nkey = '<C-n>'
let g:yankring_replace_n_pkey = '<C-p>'
"}}}
Plug 'google/vim-searchindex'
Plug 'haya14busa/incsearch.vim', {'on': ['<Plug>(incsearch-forward)', '<Plug>(incsearch-stay)', '<Plug>(incsearch-backward)']} "{{{
let g:incsearch#magic = '\v'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
"}}}
Plug 'haya14busa/vim-asterisk', {'on': ['<Plug>(asterisk-*)', '<Plug>(asterisk-#)', '<Plug>(asterisk-g*)',
      \ '<Plug>(asterisk-g#)', '<Plug>(asterisk-z*)', '<Plug>(asterisk-gz*)', '<Plug>(asterisk-z#)', '<Plug>(asterisk-gz#)']} "{{{
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
Plug 'vim-scripts/vis', {'on': ['B', 'S']}
Plug 'tpope/vim-unimpaired'

Plug 'brooth/far.vim' " , {'on': ['Far', 'Farp', 'F']} {{{
if executable('ag')
  let g:far#source = 'agnvim'
endif
"}}}
Plug 'easymotion/vim-easymotion' " {{{
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1

" Move to line
map  <Leader><Leader>f <Plug>(easymotion-bd-f)
nmap <Leader><Leader>f <Plug>(easymotion-overwin-f)

map  <Leader><Leader>w <Plug>(easymotion-bd-w)
" nmap <Leader><Leader>w <Plug>(easymotion-overwin-w)

map  <Leader>/ <Plug>(easymotion-sn)
omap <Leader>/ <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" " Without these mappings, `n` & `N` works fine. (These mappings just provide
" " different highlight method and have some other features )
map  <Leader>n <Plug>(easymotion-next)
map  <Leader>N <Plug>(easymotion-prev)
" }}}
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
Plug 'romainl/vim-qf' "{{{
let g:qf_auto_open_loclist = 0
let g:qf_auto_open_quickfix = 0
let g:qf_mapping_ack_style = 1"}}}
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify' "{{{
let g:startify_fortune_use_unicode = 1
let g:startify_custom_header = []
let g:startify_bookmarks = [ {'n': '~/.config/nvim/init.vim'},
      \{'z': '~/.zshrc'},
      \{'p': '~/pyplot'}]
"}}}
Plug 'blueyed/cursorcross.vim'
Plug 'nixon/vim-vmath'
vnoremap <silent> ++ y:call VMATH_Analyse()<CR>gv
Plug 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'EasyAlign','<Plug>(LiveEasyAlign)', 'LiveEasyAlign']} "{{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"}}}


" -------------------- nvim specific -----------------
Plug 'neomake/neomake', { 'do': ':UpdateRemotePlugins'}
      \| Plug 'dojoteef/neomake-autolint' "{{{
let g:neomake_python_enabled_makers = ['pyflakes', 'pylint']
let g:neomake_autolint_sign_column_always = 1
let g:neomake_error_sign = {'texthl': 'Debug'}
augroup my_neomake_highlights
  au!
  autocmd ColorScheme *
        \ hi link NeomakeError SpellBad |
        \ hi link NeomakeWarning SpellCap
augroup END
"}}}
"Plug 'w0rp/ale'{{{
"let g:ale_lint_on_insert_leave = 1
"}}}
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'roxma/nvim-completion-manager' "{{{
"inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"let g:cm_matcher = {'module': 'cm_matchers.fuzzy_matcher', 'case': 'smartcase'}
"let g:cm_refresh_default_min_word_len = [[1,3],[5,2]]
"imap <c-j>     <Plug>(neosnippet_expand_or_jump)
"vmap <c-j>     <Plug>(neosnippet_expand_or_jump)
"inoremap <silent> <c-u> <c-r>=cm#sources#neosnippet#trigger_or_popup("\<Plug>(neosnippet_expand_or_jump)")<cr>
"vmap <c-u>     <Plug>(neosnippet_expand_target)
"" expand parameters
"let g:neosnippet#enable_completed_snippet=1
""}}}

Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets'| Plug 'Shougo/echodoc.vim'
"Plug 'Shougo/context_filetype.vim' " doesn't work
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-syntax'
Plug 'zchee/deoplete-jedi', {'for': ['python']}
" doesn't seem to properly work so far
"Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' } "{{{
"let g:LanguageClient_serverCommands = {
"    \ 'python': ['/cfs/home/w/e/wehandre/.local/bin/pyls'],
"    \ }
"}}}
Plug 'c0r73x/neotags.nvim', {'on': 'NeotagsToggle', 'do': ':UpdateRemotePlugins' } " {{{
set regexpengine=1
let g:neotags_enabled=0
"}}}
Plug 'kassio/neoterm', {'on': ['T', 'Tnew', 'Tmap', 'Topen', 'Ttoggle'], 'do': ':UpdateRemotePlugins' } " {{{
let g:neoterm_autoscroll = 1
let g:neoterm_size = &lines
"}}}
"Plug 'bfredl/nvim-ipy' "{{{
"let g:nvim_ipy_perform_mappings = 0
""}}}

"Plug 'nathanaelkane/vim-indent-guides'
Plug 'Yggdroot/indentLine' "{{{
let g:indentLine_fileTypeExclude = ['help', 'text', 'markdown']
let g:indentLine_setConceal = 0
"}}}
Plug 'vim-airline/vim-airline' "{{{
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#vcs_priority = ['git']
set laststatus=2
let g:airline_powerline_fonts = 0
let g:airline_detect_spell = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_idx_mode = 0
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
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
Plug 'edkolev/promptline.vim', {'on': 'PromptlineSnapshot'}
Plug 'ryanoasis/vim-devicons'

" ------------------- text objects -------------------
Plug 'kana/vim-textobj-user'
Plug 'gaving/vim-textobj-argument'
Plug 'michaeljsmith/vim-indent-object'
Plug 'glts/vim-textobj-comment'

Plug 'mattn/webapi-vim'

" personal modified
Plug 'DerWeh/papercolor-theme'"{{{
let g:PaperColor_Theme_Options = {
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
Plug 'DerWeh/vim-ipython', {'on': ['IPython', 'IPythonNew']}

" Add plug-in to &runtimepath
call plug#end()
" }}}


" ===================== Color Settings ==============={{{
set t_Co=256                       " turn syntax highlighting on
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=light
colorscheme PaperColor
syntax enable                      " keeps highlighting  ;
highlight ExtraWhitespace ctermbg=LightRed guibg=#:ffafd7
au InsertLeave * match ExtraWhitespace /\s\+$/
                                   " Show whitespace
set showmatch                      " highlight matching braces
set nocursorcolumn
syntax sync minlines=100 maxlines=260
set synmaxcol=800                  " Don't try to highlight lines longer than 800 characters,
                                   "in order to speed up the view port.
" }}}


" ==================== Folding ======================={{{
set foldmethod=marker
fu! CustomFoldText()
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
endf
set foldtext=CustomFoldText()
"}}}


" ===================== Key Mappings ================={{{
nnoremap ; :|                                                      " faster `commands` using ;
nnoremap : ;
vnoremap ; :|                                                      " faster `commands` using ;
vnoremap : ;


nnoremap p p=`]<C-o>|                                              " Auto indent pasted text
nnoremap P P=`]<C-o>|

cnoremap w!! w !sudo tee % >/dev/null
nmap Q <Nop>|                                                      " Remove mapping for `Ex` mode

nnoremap <F2> :w<CR>|                                              " in normal mode F2 will save the file
inoremap <F2> <C-o>:w<CR>|                                         " in insert mode F2 will exit insert, save, enters insert again
set pastetoggle=<F3>| " toggle paste mode for pasting code without intend
noremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>| " switch between header/source with F4
noremap <leader>h :<C-u>nohl<CR>|                                      " Remove highlight from search results

" -------------------- Plugin Mappings ---------------
" Plug-in mapping{{{
nnoremap <leader>fe :VimFilerExplorer<CR>
nmap <leader>ct <Plug>Colorizer
noremap <F8> <Esc>:TagbarToggle<CR>
nnoremap <silent> <F10> :YRShow<CR>
nmap <silent> <Leader>pd <Plug>(pydocstring)
nmap <Leader>ww <Plug>VimwikiIndex
nmap <Leader>wt <Plug>VimwikiTabIndex
nmap <Leader>ws <Plug>VimwikiUISelect
nmap <C-w>r <Plug>(golden_ratio_resize)
nmap <C-w>f <C-w><Bar><C-w>_

"Unite mappings
" generate unite prefix, nmap ? [unite] can use it then
nnoremap <F1> :Denite -buffer-name=help help<CR>
nnoremap [unite] <Nop>
nmap <leader>u [unite]
nnoremap [unite] :Unite |
nnoremap [unite]b :Unite -buffer-name=bookmark bookmark<cr>
nnoremap [unite]/ :Unite -buffer-name=search line:forward -start-insert -no-quit -custom-line-enable-highlight<CR>
nnoremap <silent>[unite]c       :<C-u>Unite -buffer-name=citation -start-insert -default-action=append      citation/key<cr>
nnoremap <silent>[unite]co :<C-u>Unite -input=<C-R><C-W> -default-action=start -force-immediately citation/file<cr>
nnoremap <silent>[unite]cf :<C-u>Unite -input=<C-R><C-W> -default-action=file -force-immediately citation/file<cr>
nnoremap <silent>[unite]ci :<C-u>Unite -input=<C-R><C-W> -default-action=preview -force-immediately citation/combined<cr>
nnoremap <silent>[unite]cs :<C-u>Unite  -default-action=yank  citation/key:<C-R><C-W><cr>
vnoremap <silent>[unite]cs :<C-u>exec "Unite  -default-action=start citation/key:" . escape(@*,' ') <cr>
nnoremap <silent>[unite]cx :<C-u>exec "Unite  -default-action=start citation/key:" . escape(input('Search Key : '),' ') <cr>

nnoremap <silent> <space>f :Denite -buffer-name=files -short-source-names file_rec file_old<CR>
"nnoremap <space>/ :Unite -buffer-name=grep -no-empty -no-resize grep<cr>
nnoremap <space>/ :Denite -buffer-name=grep -no-empty grep:.<cr>
nnoremap <space>s :Unite -buffer-name=buffers -quick-match buffer<cr>
" }}}


" -------------------- Window Movement ---------------
map <C-h> <C-w>h|                     " move with <C-?>
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap c<C-j> :bel sp new<cr>       " creat new split with c<C-?>
nnoremap c<C-k> :abo sp new<cr>
nnoremap c<C-h> :lefta vsp new<cr>
nnoremap c<C-l> :rightb vsp new<cr>
nnoremap g<C-j> <C-w>j:let &winheight = &lines * 7 / 10<cr>
nnoremap g<C-k> <C-w>k:let &winheight = &lines * 7 / 10<cr>
onoremap g<C-h> <C-w>h<C-w>_|         " move and focus (resize) with g<C-?>
nnoremap g<C-l> <C-w>l<C-w>_
nnoremap d<C-j> <C-w>j<C-w>c|         " delete window with d<C-?>
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c

" Intending codeblocks
vmap < <gv
vmap > >gv
"}}}

" go to last cursor position upon opening files
if has('autocmd')
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif


if has('autocmd')
  au BufAdd,BufNewFile,BufRead * call s:diff_lang_settings()
endif
function! s:diff_lang_settings() "{{{
  if &diff || &readonly || !&modifiable
    setl nospell
  else
    setl spell spelllang=en_us
  endif
endfunction "}}}

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit# | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

" format options{{{
set textwidth=0
set linebreak  " Break line without break the word.

let &showbreak='➣➣\'
set formatoptions+=n
set formatoptions+=2
set formatoptions+=w
set formatoptions+=t
set formatoptions+=q
set formatoptions+=l
set formatoptions+=j
au FileType vim setlocal fo-=r fo-=o
set formatoptions-=r
set formatoptions-=o
"}}}

" Plug-ins {{{

" deoplete {{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#auto_completion_start_length = 2

" increase limit for tag cache files
let g:deoplete#sources#tags#cache_limit_size = 16777216 " 16MB
" default: 100, more to get more methods (e.g. np.<TAB>)
let g:deoplete#max_list = 1000

inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' :
        \ <SID>check_back_space() ? '<S-TAB>' :
        \ deoplete#manual_complete()

function! s:check_back_space() "{{{
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~ '\s'
endfunction"}}}
let g:neosnippet#enable_completed_snippet = 1
" enable neosnippet
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

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=n
endif

let g:context_filetype#same_filetypes = 1
let g:echodoc_enable_at_startup = 1
let g:echodoc#highlight_arguments='Visual'
let g:deoplete#omni#input_patterns = {}
" ------------------- vimtex ---------------------
"let g:deoplete#omni#input_patterns.tex = '\\(?:'
"      \ .  '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
"      \ . '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
"      \ . '|hyperref\s*\[[^]]*'
"      \ . '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
"      \ . '|\w*(gls|Gls|GLS)(pl)?\w*(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
"      \ . '|includepdf(\s*\[[^]]*\])?\s*\{[^}]*'
"      \ . '|includestandalone(\s*\[[^]]*\])?\s*\{[^}]*'
"      \ . '|usepackage(\s*\[[^]]*\])?\s*\{[^}]*'
"      \ . '|documentclass(\s*\[[^]]*\])?\s*\{[^}]*'
"      \ .')'
let g:deoplete#omni#input_patterns.tex = '\\.*'
"}}}

"Unite/Denite{{{
autocmd FileType denite setl nospell
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
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])


call unite#custom#profile('default', 'context', {
\   'direction': 'botright',
\ })
call unite#custom#profile('outline', 'context', {'direction': 'topleft'})

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
    \ 'ignore_pattern', join([
    \ '\.git/',
    \ '__cache__/',
    \ '\.undo',
    \ '\.backup',
    \ ], '\|'))
call unite#custom#source('files,file,file/new,buffer,file_rec,file_rec/async,file_mru', 'matchers', 'matcher_fuzzy')
"}}}

" Latex {{{
let g:tex_conceal= 'adgm'
let g:tex_flavor = 'latex'
"}}}

"}}}
