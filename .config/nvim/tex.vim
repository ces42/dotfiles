
function! tex#add_delim_modifiers(width) abort " {{{1
  call vimtex#util#undostore()
  if a:width != 0
      let line = getline('.')
      let column = col('.')
      call setline(line('.'), strpart(line, 0, col('.') - a:width - 1) . line[col('.') - 1:])
      call cursor(line('.'), column - a:width)
  endif
  " Save cursor position
  let l:cursor = vimtex#pos#get_cursor()

  " Use syntax highlights to detect region math region
  let l:ww = &whichwrap
  set whichwrap=h
  while vimtex#syntax#in_mathzone()
    normal! h
    if vimtex#pos#get_cursor()[1:2] == [1, 1] | break | endif
  endwhile
  let &whichwrap = l:ww
  let l:startval = vimtex#pos#val(vimtex#pos#get_cursor())

  let l:undostore = v:true
  call vimtex#pos#set_cursor(l:cursor)

  while v:true
    let [l:open, l:close] = vimtex#delim#get_surrounding('delim_modq_math')
    if empty(l:open) || vimtex#pos#val(l:open) <= l:startval
      break
    endif

    call vimtex#pos#set_cursor(vimtex#pos#prev(l:open))
    if !empty(l:open.mod) | continue | endif

    if l:undostore
      let l:undostore = v:false
      call vimtex#pos#set_cursor(l:cursor)
      call vimtex#pos#set_cursor(vimtex#pos#prev(l:open))
    endif

    " Add close modifier
    let line = getline(l:close.lnum)
    let line = strpart(line, 0, l:close.cnum - 1)
          \ .  '\right' . strpart(line, l:close.cnum - 1)
    call setline(l:close.lnum, line)

    " Add open modifier
    let line = getline(l:open.lnum)
    let line = strpart(line, 0, l:open.cnum - 1)
          \ . '\left' . strpart(line, l:open.cnum - 1)
    call setline(l:open.lnum, line)

    " Adjust cursor position
    let l:cursor[2] += 5
  endwhile

  call vimtex#pos#set_cursor(l:cursor)
  return b:changedtick
endfunction
