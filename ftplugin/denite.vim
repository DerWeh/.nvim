scriptencoding utf-8
setlocal nospell

silent call airline#extensions#load()

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
