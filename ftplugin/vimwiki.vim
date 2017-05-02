" let g:vimwiki_folding = 'expr'
let g:vimwiki_table_mappings = 0
function! VimwikiLinkHandler(link) "{{{ Use Vim to open links with the
  " 'vlocal:' or 'vfile:' schemes.  E.g.:
  "   1) [[vfile:///~/Code/PythonProject/abc123.py]], and
  "   2) [[vlocal:./|Wiki Home]]
  let s:link = a:link
  if s:link =~? 'vlocal:' || s:link =~? 'vfile:'
    let s:link = s:link[1:]
  else
    return 0
  endif
  let [l:idx, l:scheme, l:path, l:subdir, l:lnk, l:ext, l:url] =
       \ vimwiki#base#resolve_scheme(s:link, 0)
  if g:vimwiki_debug
    echom 'LinkHandler: idx='.l:idx.', scheme=[v]'.l:scheme.', path='.l:path.
         \ ', subdir='.l:subdir.', lnk='.l:lnk.', ext='.l:ext.', url='.l:url
  endif
  if l:url ==# ''
    echom 'Vimwiki Error: Unable to resolve link!'
    return 0
  else
    call vimwiki#base#edit_file('tabnew', l:url, [], 0)
    return 1
  endif
endfunction " }}}
