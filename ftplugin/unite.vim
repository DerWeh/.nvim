setlocal nospell
silent call airline#extensions#load()

imap <buffer> <C-n>   <Plug>(unite_select_next_line)
imap <buffer> <C-p>   <Plug>(unite_select_previous_line)

nmap <buffer> <C-n>   <Plug>(unite_select_next_line)
nmap <buffer> <C-p>   <Plug>(unite_select_previous_line)

nmap <silent><buffer><expr> Enter unite#do_action('switch')
nmap <silent><buffer><expr> <C-t> unite#do_action('tabswitch')
nmap <silent><buffer><expr> <C-s> unite#do_action('splitswitch')
nmap <silent><buffer><expr> <C-v> unite#do_action('vsplitswitch')

imap <silent><buffer><expr> Enter unite#do_action('switch')
imap <silent><buffer><expr> <C-t> unite#do_action('tabswitch')
imap <silent><buffer><expr> <C-s> unite#do_action('splitswitch')
imap <silent><buffer><expr> <C-v> unite#do_action('vsplitswitch')

nmap <buffer> <C-g> <Plug>(unite_toggle_auto_preview)

nnoremap <buffer> <ESC> :UniteClose<cr>
nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
nmap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
nmap <buffer><silent> <c-r> <Plug>(unite_redraw)

if executable('ag') == 1
  "let g:unite_source_grep_command = 'ag'
  let g:unite_source_rec_async_command =
        \['ag', '--follow', '--nocolor', '--hidden', '-g', '']
  "let g:unite_source_grep_default_opts =
        "\ '-i --vimgrep --hidden --ignore ' .
        "\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
endif

call unite#custom#profile('default', 'context', {
\   'direction': 'botright',
\ })
call unite#custom#profile('outline', 'context', {'direction': 'topleft'})

call unite#custom_source('file_rec,file_rec/async,file_rec/neovim,file_mru,file,buffer,grep',
    \ 'ignore_pattern', join([
    \ '\.git/',
    \ '__cache__/',
    \ '\.undo/',
    \ '\.backup/',
    \ '__pycache__/',
    \ ], '\|'))
call unite#custom#source('files,file,file/async,file/new,buffer, '.
      \ 'file_rec,file_rec/async, file_rec/git, file_rec/neovim, file_mru, '.
      \ 'file_include, file_list, file_point', 'matchers', 'matcher_fuzzy')
