scriptencoding utf-8

let s:docstring_re = '^\s*[bBfFrRuU]\{0,2}\\\@<!\(''''''\|"""\|[''"]\)'
let s:docstring_idedentifier_re = '[bBfFrRuU]\{0,2}\\\@<!\(''''''\|"""\|[''"]\)'


function! foldtext#python() abort
  let l:docstring = SimpylFold#FoldText()

  let l:lnum = v:foldstart

  " get first non-blank line
  while getline(l:lnum) =~# '^\s*$' | let l:lnum = nextnonblank(l:lnum + 1)
  endwhile
  if l:lnum > v:foldend
    let l:line = getline(v:foldstart)
  else
    let l:line = substitute(getline(l:lnum), '\t', repeat(' ', &tabstop), 'g')
  endif

  " if line is docstring than strip, is clear from that folding that it is docstring
  let l:is_docstring = !empty(matchlist(l:line, s:docstring_re))
  if l:is_docstring
    let l:line = substitute(l:line, s:docstring_idedentifier_re, '⟨', '')
    " let l:docstring = substitute(l:docstring, '^\s', '', '')
    let l:docstring = l:docstring[1:]  " split leading whitespace
  endif

  let l:width = winwidth(0) - &foldcolumn - (&number ? 8 : 0)  " available space
  let l:foldSize = 1 + v:foldend - v:foldstart
  let l:foldSizeStr = ' ' . l:foldSize . '  '
  let l:foldLevelStr = repeat('+--', v:foldlevel)
  let l:lineCount = line('$')
  let l:foldPercentage = printf('[%.1f', (l:foldSize*1.0)/l:lineCount*100) . '%] '
  " space remaining space to be filled
  let l:space = l:width - strwidth(l:foldSizeStr.l:line.l:foldLevelStr.l:foldPercentage.l:docstring)
  if l:space < 0
    " trim part of docstring that doesn't fit
    return l:line . l:docstring[:l:space-1] . '⟩' . l:foldSizeStr . l:foldPercentage . l:foldLevelStr
  else
    " fill empty space
    let l:expansionString = repeat('•', l:space)
    return l:line . l:docstring . l:expansionString . l:foldSizeStr . l:foldPercentage . l:foldLevelStr
  endif
endfunction


function! foldtext#custom() abort
  "get first non-blank line
  let l:fs = v:foldstart
  while getline(l:fs) =~# '^\s*$' | let l:fs = nextnonblank(l:fs + 1)
  endwhile
  if l:fs > v:foldend
    let l:line = getline(v:foldstart)
  else
    let l:line = substitute(getline(l:fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  "strip foldmarkers
  let l:markexpr = escape(substitute(&foldmarker, ',', '|', 'g'),'{')
  " TODO: check comment sign for filetype, add first line if comment
  let l:whitespace = '(\w\s*)?["|#]\s*|\s*$'
  let l:strip_line = substitute(l:line, '\v'.l:markexpr.'|'.l:whitespace, '', 'g')
  let l:strip_line = substitute(l:strip_line, '\v'.l:whitespace, '', 'g')
  let l:strip_line = substitute(l:strip_line, '\v^(\s*)', '\1<', '').'>'
  let l:w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let l:foldSize = 1 + v:foldend - v:foldstart
  let l:foldSizeStr = ' ' . l:foldSize . ' lines '
  let l:foldLevelStr = repeat('+--', v:foldlevel)
  let l:lineCount = line('$')
  let l:foldPercentage = printf('[%.1f', (l:foldSize*1.0)/l:lineCount*100) . '%] '
  let l:expansionString = repeat('.', l:w - strwidth(l:foldSizeStr.strip_line.foldLevelStr.foldPercentage))
  return l:strip_line . l:expansionString . l:foldSizeStr . l:foldPercentage . l:foldLevelStr
endfunction


function! foldtext#simple() abort
  " Get first non-blank line
  let fs = v:foldstart
  while getline(fs) =~? '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = ' ' . foldSize . ' lines '
  let foldLevelStr = repeat('+--', v:foldlevel)
  let lineCount = line('$')
  let foldPercentage = printf('[%.1f', (foldSize*1.0)/lineCount*100) . '%] '
  let expansionString = repeat('.', w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
  return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction
