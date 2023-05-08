let g:UNICODE_ENABLED=1
let g:vimtex = 1

function! TexSetupBuffer()
    " https://castel.dev/post/lecture-notes-1
    setlocal spell
    set spelllang=en_us
    " ctrl+L in insert mode to correct last spelling mistake
    " inoremap <buffer> <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
    " ctrl+backspace deletes _<digit> in one go (to undo auto-numeric-subscript snippet)
    "inoremap <buffer> <expr> <C-H> (matchstr(getline(line('.'))[0:col('.') - 2], '_\d$') != '' && vimtex#syntax#in_mathzone()) ? '<BS><BS>' : '<C-W>'

    let b:_quick_undo_tick = -1
    let b:_quick_undo_pos = [-1, -1]
    inoremap <buffer> <expr> <BS> (b:_quick_undo_tick == b:changedtick) && (col('.') == b:_quick_undo_pos[1]) && (line('.') == b:_quick_undo_pos[0]) ? '<C-o>u<C-o>u<BS>' : v:lua.MPairs.autopairs_bs(bufnr())
    "
    " in Kitty I have ctrl+9 mapped to F13 and ctrl+0 mapped to F14
    "imap <buffer> <F13> <C-\><C-O>tsd
    "imap <buffer> <F14> <C-\><C-O>tsd
    imap <buffer> <C-0> <C-\><C-O>tsd
    imap <buffer> <C-9> <C-\><C-O>tsd
    inoremap <buffer> <C-4> <C-\><C-o>f$<right>
    inoremap <buffer> <expr> ² vimtex#syntax#in_mathzone() ? '^2' : '²'
    inoremap <buffer> <expr> ³ vimtex#syntax#in_mathzone() ? '^3' : '³'
    nmap <buffer> g% VaeS%
    function! Tsa()
        norm ts$
        call vimtex#env#change_surrounding('math', 'align')
        norm g%
        " norm vie
        " substitue /\(=\|≤\|\\leq\|≥\|\\geq\|\\cong\)/\&\1/
    endfunction
    " nmap <buffer> tsa ts$csealign<CR>g%vie:s/\(=\|≤\|\\leq\|≥\|\\geq\|\\cong\)/\&\1/<CR>
    nmap <buffer> tsa :call Tsa()<CR>
    "nnoremap <buffer> ci= F=lct=  <left>
    "nnoremap <buffer> ci+ F+lct+  <left>

    " ys<textobj>c to sorround with latex command
    " let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"
    " let b:surround_{char2nr("s")} = "\\{\r\\}"
    " let b:surround_{char2nr("S")} = "\\left\\{\r\\right\\}"
    " let b:surround_{char2nr("d")} = "\\left\1delim: \1\r\\right\1\r(\r)\r[\r]\r{\r}\r<\r>\1"
    " "if b:translate_tex_unicode
    " "    let b:surround_{char2nr("N")} = "∥\r∥"
    " "else
    " let b:surround_{char2nr("n")} = "\\lVert\r\\rVert"
    " let b:surround_{char2nr("N")} = "\\left\\|\r\\right\\rVert"
    "endif

lua << EOF
conf = require('nvim-surround.config')
require('nvim-surround').buffer_setup({
    surrounds = {
        ['c'] = {
            add = function()
            local result = conf.get_input("command: ")
            if result then
                return { { "\\" .. result .. "{" }, { "}" } }
                end
                end,
        },
        ['e'] = {
            add = function()
            local result = conf.get_input("env: ")
            if result then
                return { { "\\begin{" .. result .. "} " }, { " \\end{" .. result .. "}" } }
                end
                end,
        },
        ['S'] = {
            add = {'\\left\\{', '\\right\\}'},
            find = '\\left\\{.-\\right\\}',
            delete = "^(.......)().-(.......)()$",
        },
        ['s'] = {
            add = {'\\{', '\\}'},
            find = '\\{.-\\}',
            -- find = function() -- WIP
            --     match = '\\{.-\\}'
            --     line1 = match.first_pos[1]
            --     col1 = match.first_pos[2]
            --     first_line = string.subvim.api.nvim_get_buf_lines(0, line1, line1, 1):sub()
            -- end
            delete = "^(..)().-(..)()$",
        },
        ['n'] = {
            add = {'\\lVert ', '\\rVert '},
            find = '\\lVert.-\\rVert',
            delete = "^(...... ?)().-(......)()$",
        },
        ['N'] = {
            add = {'\\left\\|', '\\right\\|'},
            find = '\\left\\|.-\\right\\|',
            delete = "^(........)().-(........)()$",
        },
    }
})
EOF

    imap <C-/> 
    nmap <buffer> <leader>o cicoperatorname{<C-R>"}<ESC>
    nmap <buffer> ysm ysi$
    setlocal matchpairs=(:) " vimtex already highlights [] and {} (much faster than matchpairs or matchpairs.nvim)
    setlocal iskeyword=@,48-57,192-255

    syntax match texMathDelim "⟨"
    syntax match texMathDelim "⟩"

    if g:UNICODE_ENABLED
        py3 from translate_tex_chr import tr_write_buffer, tr_write_file, tr_change_buffer
        augroup tex_translate_w
            au!
            au BufWriteCmd *.tex call Tex_tr_BufWrite()
        augroup END
    endif

    call vimtex#syntax#core#new_region_math('cd')
    call vimtex#syntax#core#new_region_math('cd*')
endfunction

function! VimtexPreSetup()
    "let g:vimtex_latexmk_progname='nvr'
    "let g:ycm_semantic_triggers.tex = ['re!\\[A-Za-z]*']
    let g:vimtex_quickfix_open_on_warning = 0
    let g:vimtex_quickfix_mode = 2
    let g:vimtex_quickfix_autoclose_after_keystrokes = 3
    let g:tex_flavor = 'latex'
    let g:vimtex_echo_verbose_input = 0

    set fdm=marker
    "let g:vimtex_fold_enabled = 1
    "let g:vimtex_fold_types = {
    "            \ 'envs' : {'enabled': 0},
    "            \ 'items' : {'enabled' : 0}
    "            \}


    "let g:vimtex_matchparen_enabled = 0

    "let $VIMTEX_OUTPUT_DIRECTORY='.latex'
    "g:vimtex_compiler_latexmk['options'] = ['-verbose', 'file-line-error', '-synctex=1', 'interaction-nonstopmode', '-auxdir=./.latex']
    "let g:vimtex_compiler_latexmk = {
                "\ 'build_dir' : '',
                "\ 'callback' : 1,
                "\ 'continuous' : 1,
                "\ 'executable' : 'latexmk',
                "\ 'hooks' : [],
                "\ 'options' : [
                "\   '-verbose',
                "\   '-file-line-error',
                "\   '-synctex=1',
                "\   '-interaction=nonstopmode',
                "\   '-=./.latex'
                "\ ],
    "\}
    let g:vimtex_indent_enabled=1

    " viewer
    let g:vimtex_view_method = 'zathura'
    "let g:vimtex_view_general_viewer = 'okular'
    "let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
    "let g:vimtex_view_general_options_latexmk = '--unique'

    function! In_math(lhs, rhs) abort
        let l:outside_math = (nvim_get_mode().mode == 'i') && !(vimtex#syntax#in_mathzone() || vimtex#syntax#in('texNewcmdArgBody'))
        return l:outside_math ? a:lhs : a:rhs
    endfunction

    function! Ensure_math(lhs, rhs) abort
        let l:wrap = (nvim_get_mode().mode == 'i') && !(vimtex#syntax#in_mathzone() || vimtex#syntax#in('texNewcmdArgBody'))
        return l:wrap ? ( "$" . a:rhs . "$" ) : a:rhs
    endfunction

    " custom insert mode shortcuts (loading takes << 1ms)
    let g:vimtex_imaps_leader=';'
    call vimtex#imaps#add_map( {'lhs' : 'V', 'rhs' : '\nabla', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : '7', 'rhs' : '\partial^\nabla', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'vi', 'rhs' : '\imath'} )
    call vimtex#imaps#add_map( {'lhs' : 'vj', 'rhs' : '\jmath'} )
    call vimtex#imaps#add_map( {'lhs' : 'j>', 'rhs' : '\Leftrightarrow', 'wrapper': 'Ensure_math'})
    call vimtex#imaps#add_map( {'lhs' : 'j<', 'rhs' : '\Rightarrow', 'wrapper': 'Ensure_math'})
    "call vimtex#imaps#add_map( {'lhs' : 'jxh', 'rhs' : '\xleftarrow'} )
    call vimtex#imaps#add_map( {'lhs' : 'jx', 'rhs' : '\xrightarrow'} )
    call vimtex#imaps#add_map( {'lhs' : 'j~', 'rhs' : '\rightsquigarrow'} )
    call vimtex#imaps#add_map( {'lhs' : '2', 'rhs' : '^2'} )
    call vimtex#imaps#add_map( {'lhs' : '1', 'rhs' : '^{-1}'} )
    call vimtex#imaps#add_map( {'lhs' : '=', 'rhs' : '\equiv'} )
    call vimtex#imaps#add_map( {'lhs' : ';', 'rhs' : '^'} )
    call vimtex#imaps#add_map( {'lhs' : '/', 'rhs' : '\wedge'} )
    call vimtex#imaps#add_map( {'lhs' : '^', 'rhs' : '\bigwedge'} )
    call vimtex#imaps#add_map( {'lhs' : 'o', 'rhs' : '\circ'} )
    call vimtex#imaps#add_map( {'lhs' : 'O', 'rhs' : '\otimes'} )
    call vimtex#imaps#add_map( {'lhs' : 'B', 'rhs' : '\bullet'} )
    call vimtex#imaps#add_map( {'lhs' : 'M>', 'rhs' : '\varinjlim'} )
    call vimtex#imaps#add_map( {'lhs' : 'M<', 'rhs' : '\varprojlim'} )
    call vimtex#imaps#add_map( {'lhs' : 'vd', 'rhs' : '\partial', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'vc', 'rhs' : '\bar\partial', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'vo', 'rhs' : '\infty', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'vs', 'rhs' : '\star', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'vm', 'rhs' : '\setminus', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'vp', 'rhs' : '2 \pi i', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'v2', 'rhs' : '2\pi', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : 'vl', 'rhs' : '\ell', 'wrapper': 'Ensure_math'} )
    call vimtex#imaps#add_map( {'lhs' : '~<', 'rhs' : '\lesssim'} )
    call vimtex#imaps#add_map( {'lhs' : '~>', 'rhs' : '\gtrsim'} )

    "call vimtex#imaps#add_map( {'lhs' : 'jl', 'rhs' : '\arrow{r}', 'wrapper' : 'vimtex#imaps#wrap_environment', 'context' : ['tikzcd']} )

    "let g:vimtex_grammar_vlty = {'lt_directory': '/opt/LanguageTool-5.2/'}
    let g:vimtex_delim_list = { 'delim_math' : {
                \    'name' : [
                \      ['(', ')'],
                \      ['[', ']'],
                \      ['\{', '\}'],
                \      ['\langle', '\rangle'],
                \      ['\lbrace', '\rbrace'],
                \      ['\lvert', '\rvert'],
                \      ['\lVert', '\rVert'],
                \      ['\lfloor', '\rfloor'],
                \      ['\lceil', '\rceil'],
                \      ['\ulcorner', '\urcorner'],
                \      ['⟨', '⟩'],
                \    ]
                \  }
                \}
    let g:vimtex_syntax_conceal = {'accents': 0, 'cites': 0, 'fancy': 0, 'greek':0, 'math_bounds':1, 'math_delimiters':0, 'math_fracs':0, 'math_super_sub':0, 'math_symbols':0, 'sections':0, 'styles':0}

    setlocal keywordprg=texdoc
endfunction


let b:translate_tex_unicode = 0

if g:UNICODE_ENABLED
    augroup tex_translate
        au!
        lua require('tr_tex_chr')
        au BufReadPre *.tex let b:lastpos = line("'\"")
        " au BufReadCmd *.tex call Tex_tr_BufRead()
        au BufReadPost *.tex lua tr_buffer()
        au BufReadPost *.tex let b:translate_tex_unicode = 1 | exe b:lastpos .. 'mark \"' | normal! g`"
        " au FileReadCmd *.tex call Tex_tr_FileRead()
    augroup END
endif

augroup vimtex_setup
    au!
    au BufReadPost *.tex call TexSetupBuffer()
    "au BufReadPost *.tex lua 
    au User VimtexEventInitPre call VimtexPreSetup()
    au User VimtexEventInitPost call VimtexPostSetup()
augroup END

" ----------------------------------------------------------------------------------------
" Commands for read/write with unicode substitution
" ----------------------------------------------------------------------------------------

function! Tex_tr_FileRead()
    exe "sil doau FileReadPre " . fnameescape(expand("<amatch>"))
    "exe "noautocmd sil r! cat " . fnameescape(expand("<amatch>")) .  " | " fnameescape(expand("~/latex_tools/tr_tex_chr.lua"))
    exe "noautocmd r" . fnameescape(expand("<amatch>"))
    let b:translate_tex_unicode = 1
    exe "sil doau FileReadPost " . fnameescape(expand("<amatch>"))
endfunction

function! Tex_tr_BufRead()
    " let l1 = line("'\"")
    exe "sil doau BufReadPre " . fnameescape(expand("<amatch>"))
    " let l2 =  line("'\"")
    " exe "noautocmd sil %! cat " . fnameescape(expand("<amatch>")) .  " | " fnameescape(expand("~/latex_tools/tr_tex_chr.lua"))
    " exe "noautocmd e " . fnameescape(expand("<amatch>")) .  " | " fnameescape(expand("~/latex_tools/tr_tex_chr.lua"))
    " let l3 = line("'\"")
    exe "sil lua read_tr_buffer('" . fnameescape(expand("<amatch>")) . "')"
    let b:translate_tex_unicode = 1
    exe "sil doau BufReadPost " . fnameescape(expand("<amatch>"))
    " exe l1 .. 'mark \"'
    " normal! g`"
    " echo l1 l2 l3 line("'\"")
endfunction

function! Tex_tr_FileWrite()
    exe "sil doau FileWritePre " . fnameescape(expand("<amatch>"))
    exe "noautocmd sil py3 tr_write_file('" .fnameescape(expand("<amatch>")) . "')"
    exe "sil doau FileWritePost " . fnameescape(expand("<amatch>"))
    set nomodified
endfunction

function! Tex_tr_BufWrite()
    exe "sil doau BufWritePre " . fnameescape(expand("<amatch>"))
    exe "noautocmd sil py3 tr_write_buffer('" .fnameescape(expand("<amatch>")) . "')"
    exe "sil doau BufWritePost " . fnameescape(expand("<amatch>"))
    set nomodified
endfunction

function! VimtexPostSetup()
    lua require('tex_tools')
    nnoremap <buffer> <leader>ld :!firefox http://detexify.kirelabs.org/classify.html<CR>
    nnoremap <buffer> <leader>lf :lua expand_font_macros()<CR>
endfunction

au BufReadPost *.tex lua require('vimtex').imaps_setup()

command! UnicodeToTex py3 tr_change_buffer()


" ------------------------------------------------------------------------------
" utilities
" ------------------------------------------------------------------------------

function! AlwaysMath()
    function! vimtex#syntax#in_mathzone()
        return 1
    endfunction
endfunction

" ------------------------------------------------------------------------------
" file-specific config
" ------------------------------------------------------------------------------

au! BufAdd *diary.tex :LspStop

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
