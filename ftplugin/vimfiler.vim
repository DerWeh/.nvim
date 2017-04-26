call vimfiler#custom#profile('explorer', 'context', {
      \  'safe': 0,
      \  'simple': 0
      \ })

noremap <buffer> i :VimFilerPrompt<CR>

let g:vimfiler_tree_leaf_icon = '¦'
"let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_opened_icon = ''
"let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_tree_closed_icon = ''
" let g:vimfiler_file_icon = '-'
" let g:vimfiler_marked_file_icon = '*'
