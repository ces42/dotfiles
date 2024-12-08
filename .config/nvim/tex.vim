" I always source this file at startup (independent of loading of vimtex) --
" so let's kee it minimal!
let g:UNICODE_ENABLED=1

if g:UNICODE_ENABLED
  au BufReadCmd *.tex call Tex_tr_BufRead()
endif
" au FileReadCmd *.tex call Tex_tr_FileRead()

function! Tex_tr_BufRead()
    " let l1 = line("'\"")
    exe "sil doau BufReadPre " . fnameescape(expand("<amatch>"))
    " let l2 =  line("'\"")
    " let l3 = line("'\"")
    sil lua require('tr_tex_chr').read_tr_buffer(vim.fn.fnameescape(vim.fn.expand('<amatch>')))
    exe "sil doau BufReadPost " . fnameescape(expand("<amatch>"))
    " exe l1 .. 'mark \"'
    " normal! g`"
    " echo l1 l2 l3 line("'\"")
endfunction

"function! Tex_tr_FileRead()
"    exe "sil doau FileReadPre " . fnameescape(expand("<amatch>"))
"    exe "noautocmd r" . fnameescape(expand("<amatch>"))
"    let b:translate_tex_unicode = 1
"    exe "sil doau FileReadPost " . fnameescape(expand("<amatch>"))
"endfunction

