setl foldlevel=1
setl tabstop=4        " tab width is 4 spaces
setl shiftwidth=4     " indent also with 4 spaces
setl softtabstop=4
setl expandtab

let g:echodoc_enable_at_startup = 1

let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#statement_length = 80

let g:jedi#goto_assignments_command = 'gd'
let g:jedi#goto_definitions_command = 'gD'
let g:jedi#rename_command           = '<leader>jr'
let g:jedi#usages_command           = '<leader>ju'


nmap <silent> <Leader>pd <Plug>(pydocstring)
