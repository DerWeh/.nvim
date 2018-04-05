setlocal foldlevel=1
setlocal tabstop=4        " tab width is 4 spaces
setlocal shiftwidth=4     " indent also with 4 spaces
setlocal softtabstop=4
setlocal expandtab

setlocal foldtext=foldtext#python()

let g:echodoc_enable_at_startup = 1

let g:pydocstring_templates_dir = g:vimdir.'/templates/pydocstring/'
nmap <silent> <LocalLeader>pd <Plug>(pydocstring)

nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <buffer> gD :call LanguageClient_textDocument_definition()<CR>:normal! m'<CR>
nnoremap <buffer> <LocalLeader>r :call LanguageClient_textDocument_rename()<CR>
nnoremap <buffer> <LocalLeader>s :Denite documentSymbol<CR>
nnoremap <buffer> <LocalLeader>S :DeniteCursorWord -auto-highlight documentSymbol<CR>
nnoremap <buffer> <LocalLeader>n :Denite -auto-highlight references<CR>
