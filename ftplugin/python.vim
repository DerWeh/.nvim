setl foldlevel=1
setl tabstop=4        " tab width is 4 spaces
setl shiftwidth=4     " indent also with 4 spaces
setl softtabstop=4
setl expandtab

let g:echodoc_enable_at_startup = 1

nmap <silent> <LocalLeader>pd <Plug>(pydocstring)

nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <buffer> gD :call LanguageClient_textDocument_definition()<CR>
nnoremap <buffer> <LocalLeader>r :call LanguageClient_textDocument_rename()<CR>
nnoremap <buffer> <LocalLeader>s :Denite documentSymbol<CR>
nnoremap <buffer> <LocalLeader>S :DeniteCursorWord -auto-highlight documentSymbol<CR>
nnoremap <buffer> <LocalLeader>n :Denite -auto-highlight references<CR>
