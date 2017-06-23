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

" Correctly setup PYTHONPATH for pylint. Since Neomake-Autolint uses a
" temporary file the default PYTHONPATH will be in the temporary directory
" rather than the project root.
function! s:PylintSetup()
  " Store off the original PYTHONPATH since it will be modified prior to
  " doing a lint pass.
  let s:PythonPath = exists('s:PythonPath') ? s:PythonPath : $PYTHONPATH
  let l:path = s:PythonPath
  if match(l:path, getcwd()) >= 0
    " If the current PYTHONPATH already includes the working directory
    " then there is nothing left to do
    return
  endif

  if !empty(l:path)
    " Uses the same path separator that the OS uses, so ':' on Unix and ';'
    " on Windows. Only consider Unix for now.
    let l:path.=':'
  endif

  let $PYTHONPATH=l:path . getcwd()
endfunction

call s:PylintSetup()
