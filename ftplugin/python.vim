setlocal foldlevel=1
setlocal tabstop=4        " tab width is 4 spaces
setlocal shiftwidth=4     " indent also with 4 spaces
setlocal softtabstop=4
setlocal expandtab

setlocal foldtext=foldtext#python()

let g:echodoc_enable_at_startup = 1

let g:pydocstring_templates_dir = g:vimdir.'/templates/pydocstring/'
nmap <silent> <LocalLeader>pd <Plug>(pydocstring)
