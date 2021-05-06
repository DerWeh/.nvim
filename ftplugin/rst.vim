setlocal tabstop=3        " tab width is 3 spaces
setlocal shiftwidth=3     " indent also with 3 spaces
setlocal softtabstop=3

map <buffer><silent> <F8> :Unite outline -buffer-name=TOC -sync -vertical -winwidth=40 -no-quit -toggle -no-quit -auto-highlight<CR>
imap <buffer><silent> <F8> <C-o>:Unite outline -buffer-name=TOC -sync -vertical -winwidth=40 -no-quit -toggle -no-quit -auto-highlight -no-focus<CR>
