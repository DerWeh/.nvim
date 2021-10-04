function! semshihl#custom() abort
  hi semshiLocal           ctermfg=209 guifg=#ff875f
  hi semshiGlobal          ctermfg=214 guifg=#ffaf00
  hi semshiImported        ctermfg=214 guifg=#ffaf00 cterm=bold gui=bold
  hi semshiParameter       ctermfg=75  guifg=#5fafff
  hi semshiParameterUnused ctermfg=117 guifg=#87d7ff cterm=underline gui=underline
  hi semshiFree            ctermfg=218 guifg=#ffafd7
  hi semshiBuiltin         ctermfg=207 guifg=#ff5fff
  hi semshiAttribute       ctermfg=49  guifg=#00ffaf
  hi semshiSelf            ctermfg=249 guifg=#b2b2b2
  hi semshiUnresolved      ctermfg=226 guifg=#ff0f0f cterm=underline gui=underline
  hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f

  hi semshiErrorSign       ctermfg=231 guifg=#afaf0f ctermbg=160 guibg=#d70f0f
  hi semshiErrorChar       ctermfg=231 guifg=#afaf0f ctermbg=160 guibg=#d70f0f
  hi semshiGlobal          ctermfg=red guifg=#ff0000
  highlight! link semshiUnresolved SpellBad
endfunction
