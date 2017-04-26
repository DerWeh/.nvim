setl foldlevel=1
setl tabstop=4        " tab width is 4 spaces
setl shiftwidth=4     " indent also with 4 spaces
setl softtabstop=4
setl expandtab

let g:echodoc_enable_at_startup = 0

let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#statement_length = 80

" jedi Configuration from https://github.com/zeekay/vice-complete{{{

"setl omnifunc=jedi#completions

" Needed for deoplete/neocomplcache
let g:jedi#auto_vim_configuration   = 0
let g:jedi#completions_enabled      = 1
let g:jedi#completions_command      = ''

" Call signatures
let g:jedi#show_call_signatures     = 1
let g:jedi#show_call_signatures_delay = 0

let g:jedi#auto_initialization      = 1
let g:jedi#goto_assignments_command = 'gd'
let g:jedi#goto_definitions_command = 'gD'
let g:jedi#popup_on_dot             = 0
let g:jedi#popup_select_first       = 0
let g:jedi#rename_command           = '<leader>jr'
let g:jedi#usages_command           = '<leader>ju'
let g:jedi#use_splits_not_buffers   = 'right'
let g:jedi#use_tabs_not_buffers     = 0

"let g:deoplete#omni#input_patterns.python = '\([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
"}}}
