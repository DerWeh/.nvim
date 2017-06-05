setlocal nospell

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
