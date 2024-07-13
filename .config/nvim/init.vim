" vim: foldmethod=marker
" vim: foldlevel=1
let g:python3_host_prog = expand('/usr/bin/python3')
set tabstop=4
set shiftwidth=4

let mapleader=' '
let maplocalleader=' '

set termguicolors
" ~/.config/nvim/lua/init.lua

set guifont=JuliaMono:h12
" color PaperColor

function! IsNormalBuffer()
    return &buftype != 'nofile' && &buftype != 'quickfix'
endfunction

" put this here so that firenvim can unmap <ScrollWheelUp>, <ScrollWheelDown>
so ~/.config/nvim/scrolloff.vim

lua require('init')
" color tokyonight-night
colorscheme catppuccin-mocha
color tex_colors
hi Normal guibg=none guifg=e0e0e0
" hi Comment guifg=#707090 "tokyonight

" let g:pymode_python = 'python3'

""python-syntax {{{
"let g:python_highlight_string_format = 1
"let g:python_highlight_builtins = 1
"let g:python_highlight_exceptions = 1
"let g:python_highlight_space_errors = 1
"let g:python_highlight_operators = 1
"let g:python_highlight_class_vars = 1
" }}}

" vim-pandoc
let g:pandoc#folding#level=4
"let g:pandoc#command#autoexec_on_writes = 1
let g:pandoc#command#autoexec_command = 'Pandoc pdf --pdf-engine="pdflatex" -f markdown+smart -F arrows --abbreviations="/home/ca/.pandoc/abbrevs.txt"'
let g:pandoc#command#custom_open = 'evince'
"let g:pandoc#syntax#conceal#cchar_overrides = {"strike": "-"}

" auto-pairs
" let g:AutoPairsMapCh = 0
" let g:AutoPairsShortcutBackInsert='<M-v>'

"lua require('texlab')
"lua require('tabout').setup{
"            \    tabkey = '<C-j>',
"            \    backwards_tabkey = '<C-;>',
"            \    act_as_tab = false,\frac{1}{2}
"            \    act_as_shift_tab = false,
"            \    completion = false,
"            \    ignore_beggining = true,
"            \    tabouts = {
"            \        {open = "'", close = "'"},
"            \        {open = '"', close = '"'},
"            \        {open = '`', close = '`'},
"            \        {open = '(', close = ')'},
"            \        {open = '[', close = ']'},
"            \        {open = '{', close = '}'}
"            \    }
"            \}


" set signcolumn=no

" UltiSnips {{{
let g:UltiSnipsExpandOrJumpTrigger = "<tab>"
" }}}

" vimtex
so ~/.config/nvim/tex.vim

" targets.vim {{{
"let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'
" }}}

" set options {{{
set history=10000

set ttimeout ttimeoutlen=3

" backspace at beginning of line
set backspace=indent,eol,start

set mouse=a "mouse mode
set mousemodel=extend " use right-click to do visual select
set clipboard=unnamed " use system clipboard

set undofile " save undo history

set showcmd " show commands typed in normal mode
set lazyredraw " don't redraw during macro execution

set splitright " split window appear on right
set hi=5000 " size of command history

set whichwrap=<,>,[,] "arrow keys navigate to next line at end of line

"filetype indent plugin on
set smartindent " indent from previous line
set autoindent
set modeline
set hlsearch " highligh search results
set inccommand=split "live preview of substitutions

" set tab width behaviour
"set shiftwidth=4

" linenumbers
set number
set relativenumber
augroup line_numbers
    autocmd BufLeave * : if &nu && !(&ft == 'qf') | setlocal norelativenumber | endif
    autocmd BufEnter * : if &nu && !(&ft == 'qf') | setlocal relativenumber | endif
    autocmd FocusLost * : if &nu && !(&ft == 'qf') | setlocal norelativenumber | endif
    autocmd FocusGained * : if &nu && !(&ft == 'qf') | setlocal relativenumber | endif
    autocmd CmdwinEnter * setlocal nonumber | setlocal nornu
augroup END

"" line wrapping
" breakindent can make insert mode slow
set breakindent " Indents word-wrapped lines as much as the 'parent' line
set lbr " word-wrap does not split words

" messages
set shortmess-=F " show file info when opening
set shortmess-=T " don't truncate messages
" show warning when search wraps
" set shortmess+=S " this disables the match counter :/

set modelineexpr

" use treesitter for folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" set nofoldenable                     " Disable folding at startup.
set foldlevel=20

" don't continue comments when hitting o
" https://superuser.com/questions/271023/can-i-disable-continuation-of-comments-to-the-next-line-in-vim
au BufWinEnter * set formatoptions-=o

" }}}

" TODO something for folding

" https://vi.stackexchange.com/questions/18310/keep-relative-cursor-position-after-indenting-with {{{
" func! Indent(ind)
"     if &sol
"         set nostartofline
"     endif
"     let vcol = virtcol('.')
"     if a:ind
"         norm! >>
"         exe "norm!". (vcol + shiftwidth()) . '|'
"     else
"         norm! <<
"         exe "norm!". (vcol - shiftwidth()) . '|'
"     endif
" endfunc

" nnoremap >> <cmd>call Indent(1)<cr>
" nnoremap << <cmd>call Indent(0)<cr>
" Shift + Tab deindents line
inoremap <S-Tab> <cmd>normal <<<CR>

" }}}

" key bindings {{{
" easymotion
map <leader> <Plug>(easymotion-prefix)

" prevent Ctrl+U from deleting work https://vim.fandom.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" make Ctrl+R break undo sequence
inoremap <C-R> <C-G>u<C-R>
" Ctrl+R twice to paste default buffer, Ctrl+R-Ctrl+E to paste
" system-clipboard
" inoremap <C-R><C-R> <C-R>"
"inoremap <C-R><C-R> <C-R>*
inoremap <C-R><C-R> <C-\><C-o><Plug>(YankyPutAfter)<Right>
inoremap <c-p> <C-\><C-o><Plug>(YankyPreviousEntry)
inoremap <c-n> <C-\><C-o><Plug>(YankyNextEntry)
inoremap <C-R><C-E> <C-R>+
" ctrl+L in insert mode to correct last spelling mistake
inoremap <C-l> <cmd>set spell<CR><c-g>u<Esc>[s1z=`]a<c-g>u
" press '\h' to highlight search results
nnoremap <leader>h <cmd>set hlsearch!<cr>
" press '\l' to show line Numbers, '\rl' to show relative line numbers
" map <leader>l <cmd>set nu!<cr>
nnoremap <leader>l <cmd>call ToggleLines()<CR>
function! ToggleLines()
    if &nu || &rnu
        set nonu
        set nornu
        set signcolumn=no
    else
        set nu
        set rnu
        set signcolumn=number
    end
endfunction
nnoremap <leader>r <cmd>set rnu!<cr>
" <leader>8 / 9 / 0 for 80 / 90 / 100 character line
nnoremap <leader>8 <cmd>set colorcolumn=80<cr>
nnoremap <leader>9 <cmd>set colorcolumn=90<cr>
nnoremap <leader>0 <cmd>set colorcolumn=100<cr>
nnoremap <leader>- <cmd>set colorcolumn=<cr>
" double-click opens folds
nnoremap <silent> <expr> <2-LeftMouse> col('.') == 1 ? 'za' : ((foldclosed(line('.')) == -1) ? '<2-LeftMouse>' : 'zo')
" press '\m' to enable folding by markers
nnoremap <leader>m <cmd>set foldmethod=marker<CR>
" press '\f' to show foldcolumn
" function! ToggleFoldcolumn()
"     if &foldcolumn
"         let &l:foldcolumn = 0
"     else
"         let &l:foldcolumn = 2
"     endif
" endfunction
" nnoremap <expr> <leader>f ToggleFoldcolumn()
" press or Alt+g to capitalize the current word
nnoremap <M-g> lm`b~``h
inoremap <M-g> <Right><C-\><C-o>m`<C-o>b<C-o>~<C-\><C-o>``<Left>
" C-w deletes previous WORD in insert mode
inoremap <C-w> <C-\><C-o>"_dB
" C-Backspace deletes previous word, C-Del word after cursor
inoremap <C-BS> <C-w>
cnoremap <C-BS> <C-w>
inoremap <C-h> <C-w>
cnoremap <C-h> <C-w>
inoremap <C-Del> X<Left><C-o>"_de
" inoremap <C-Del> <cmd>normal "_de<CR>
" ctrl-d as alias for del
inoremap <C-D> <del>
" C-a and C-e for jumping to start/end of line (like bash)
inoremap <C-a> <cmd>normal! ^<CR>
inoremap <C-e> <end>
cnoremap <C-a> <home>
cnoremap <C-e> <end>
" Alt/C + b/f for word/character movement (like bash/emacs)
"inoremap <C-f> <Right>
"inoremap <C-b> <Left>
inoremap <M-f> <cmd>normal! w<CR>
inoremap <M-b> <cmd>normal! b<CR>
" Ctrl + hjkl to move in insert and command mode
" inoremap <M-j> <cmd>normal! gj<CR>
inoremap <M-j> <C-\><C-o>gj
inoremap <M-k> <C-\><C-o>gk
" inoremap <M-k> <cmd>normal! gk<CR>
inoremap <M-h> <Left>
inoremap <M-l> <Right>
cnoremap <M-h> <Left>
cnoremap <M-l> <Right>
" same maps for command mode
nnoremap <M-j> gj
nnoremap <M-k> gk
nnoremap <M-h> <Left>
nnoremap <M-l> <Right>
" emacs keybindings in command mode
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <C-D> <del>
" C-s to save
inoremap <C-s> <cmd>update \| lua require('lualine').refresh()<CR>
nnoremap <C-s> <cmd>update \| lua require('lualine').refresh()<CR>
vnoremap <C-s> <cmd>update \| lua require('lualine').refresh()<CR>
" Up/Down/PageUp/PageDown etc. in command mode like in zsh
cnoremap <C-p> <PageUp>
cnoremap <C-n> <PageDown>
cnoremap <M-p> <Up>
cnoremap <M-n> <Down>
" <C-.> for quick insertion of %:h (directory of the current file)
cnoremap <C-.> %:h

" Spacebar inserts space in normal mode too
"nnoremap <Space> i <Esc>l
" nmap <space> i<space><esc>l

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"==============================================
"               cool splitting
"==============================================
" split automatically if window doesn't exist
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr()) "we haven't moved
    if (match(a:key,'[jk]')+1) "we want to go up/down
      wincmd s
    elseif (match(a:key,'[hl]')+1) "we want to go left/right
      wincmd v
    endif
    exec "wincmd ".a:key
  endif
endfunction

"remap our split keys
map <C-w><C-h> :call WinMove('h')<cr>
map <C-w><C-k> :call WinMove('k')<cr>
map <C-w><C-l> :call WinMove('l')<cr>
map <C-w><C-j> :call WinMove('j')<cr>

" C-w C-] opens in new tab instead of split
nnoremap <C-W><C-]> <C-W><C-]><C-W>T

nnoremap <C-/> <cmd>noh<CR>
" 'g/' to search for selected text in visual mode
xnoremap g/ "zy/<C-R>z<CR>
" gy to copy the whole buffer into the Ctrl+C clipboard
nnoremap gy gg"+yG``
" yp to quickly duplicate current line
nnoremap yp yyp
" Alt-y twice to do yy but not in linewise mode
nnoremap <M-y><M-y> ^y$

" Don't clutter unnamed register with one-character deletes
"nnoremap x "-x "disable this because I *do* like doing xp
" vnoremap <c-d> "zx
vnoremap x "-x
nnoremap <Del> "-x

" Shift-enter does the same as o but w/o changing mode
nmap <S-CR> o<ESC>
imap <S-CR> <cmd>normal o<CR>

" make & (repeat last subsitute) work in visual mode
vnoremap & :&&<CR>

" Ctrl+Shift+Y in insert mode is equivalent to Ctrl+Y five times
imap <C-S-Y> <C-Y><C-Y><C-Y><C-Y><C-Y>

" Use shift + arrow keys in insert mode to select
inoremap <S-Left> <Esc>v
inoremap <S-Right> <Right><Esc>v

vnoremap <S-Left> <Left>
vnoremap <S-Right> <Right>

" gcy to copy insert commented of a line above it
nmap gcy m`yyPgcc``

" gV to visually select current "line" w.r.t line wrap
nnoremap gV g^vg$

" gp to select previously pasted text
nnoremap <expr> gp '`[' . getregtype()[0] . '`]'
vnoremap <expr> gp '`[' . 'o' . (getregtype()[0] == 'v' ? '' : getregtype()[0]) . '`]'

" go and gO to insert *indented* line above/below w/o leaving normal mode
nnoremap go o.<BS><ESC>
nnoremap gO O.<BS><ESC>

"function! Extract(type) " currently not used
    ""let s = line("'[")
    "let name = input('variable name: ')
    "exec "normal O"
    "call setline('.', name . ' = ')
    "exec "normal '[d']O\<Esc>p"
"endfunction
"nnoremap <silent> \e <cmd>set opfunc=Extract<cr>g@

nnoremap <f5> <cmd>set autochdir\|:w\|Make<cr>
" imap <f5> <C-o>:w\|make<cr>

nnoremap <F3> :%s//g<Left><Left><C-^>
vnoremap <expr> <F3> ':s/' .. ((mode()[0] == 'v' \|\| mode()[0] == "\<C-v>") ? '%V' : '') .. '/g<Left><Left><C-^>'
inoremap <F3> <Esc>:%s//g<Left><Left>

" nnoremap g/ /\c<left><left>
nnoremap <M-/> /\c<left><left>

" <C-;> as a more easily repeatable alternative to g;
nnoremap <C-;> g;
inoremap <C-;> <cmd> normal g;<CR>

" Alt-backspace to undo in insert mode
inoremap <A-BS> <C-o>u
snoremap <A-BS> <cmd>undo<CR><esc>a

" gs as alias for ys (vim-surround)
nmap gs ys
nmap gss yss
" AltGr + s for surrounding
nmap ß ys
nmap ßß yss

" AltGr + : for lua command mode
nnoremap ¶ :lua 

" QQ to leave vim
nnoremap QQ <cmd>qa<CR>

" Alt-C to copy current filename to clipboard
nnoremap <M-c> <cmd>let @+ = substitute(expand('%'), '/home/ca/', '~/', '')<CR>
inoremap <M-c> <cmd>let @+ = substitute(expand('%'), '/home/ca/', '~/', '')<CR>


nnoremap <expr> <CR> IsNormalBuffer() ? '"_ciw' : '<CR>'

" select all
" nnoremap <leader>a gg<S-V>G

" copy to ctrl-c system clipboard
xnoremap <leader>y "+y
xnoremap <expr>  IsNormalBuffer() ? '"+y' : ''
nnoremap <expr>  IsNormalBuffer() ? '"+' : ''

" open github files, not html views when using gf on a github link
" currently not working
let GITHUB_RE = 'https://github\.com/\(\w\|-\)*/\(\w\|-\)*/blob/.*'
let GITLAB_RE = 'https://gitlab\..*\.org/\(\w\|-\)*/\(\w\|-\)*/\(-/\)\?blob/.*'
nnoremap <expr> gf (matchstr(expand('<cfile>'), GITHUB_RE . '\\|'. GITLAB_RE) != '') ? ':e ' . substitute(expand('<cfile>'), 'blob', 'raw', '') . '<CR>' : 'gf'
nnoremap <expr> <C-W>gf (matchstr(expand('<cfile>'), GITHUB_RE . '\\|'. GITLAB_RE) != '') ? ':tabe ' . substitute(expand('<cfile>'), 'blob', 'raw', '') . '<CR>' : '<C-W>gf'

" gg goes to start of line if already on first line
nnoremap <expr> gg v:count == 0 && line('.') == 1 ? '0' : 'gg'

" slightly more convenient tab navigation
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt

set nrformats=hex,bin " C-A, C-X operates on digits, letters, hex and binary numbers

function! SingPlur(num)
    let l:word = expand('<cword>')
    if match(l:word, '^[a-zA-Z]*$') == -1
        return -1
    endif
    try
        py3 import pluralizer
    catch
        return ''
    endtry
    py3 if not locals().get('p'): p = pluralizer.Pluralizer()
    let l:declension = a:num == 2 ? 'plural' : 'singular'
    let l:mod = py3eval('p.' .. l:declension .. '("' .. l:word .. '")')
    if l:mod != l:word
        return "\<esc>ciw" .. l:mod .. "\<esc>"
    endif
    return ''
endfunction

function! CXA(num)
    let l:action = SingPlur(a:num)
    return l:action == -1 ? (a:num == 1 ? "\<C-x>" : "\<C-a>" ) : l:action
endfunction

nnoremap <expr> <C-x> CXA(1)
nnoremap <expr> <C-a> CXA(2)

" }}}


" commands {{{
" save when file is readonly using sudo
function! SudaWriteCmd()
    Lazy load suda.vim 
    SudaWrite %
    " e
    set noreadonly
    nnoremap <buffer> <C-S> <cmd>SudaWrite %<CR><cmd>set noreadonly<CR>
    inoremap <buffer> <C-S> <cmd>SudaWrite %<CR><cmd>set noreadonly<CR>
endfunction
" command! WW Lazy load suda.vim | SudaWrite % | e | set noreadonly | nnoremap <buffer> <C-S> :sudawrite % \| e \| set noreadonly<cr> | inoremap <buffer>
command! WW call SudaWriteCmd()

"common typos
command! W  w
command! Wq wq
command! WQ wq
cabbrev WQ! wq!
cabbrev W! w!
cabbrev QA! qa!
cabbrev Qa! qa!
command! Wqa wqa
command! Qa qa
command! Q  q

" fugitive shortcuts
command! Gc Git commit % -m .
command! GC Git commit % -m .
command! Gl Git pull
command! GL Git pull
command! Gp Git push
command! GP Git push

function! Rc()
    cd ~/.config/nvim
    if &ft == 'tex'
        tabe vimtex_setup.vim
    endif
	tabe lua/init.lua
	tabe lua/plugins/misc.lua
	tabe init.vim
endfunction
command! Rc call Rc()
command! RC call Rc()

command! -nargs=? RichPaste call RichPaste('<args>')
command! -nargs=? RP call RichPaste('<args>')

function! RichPaste(...)
    let target = get(a:, 1, -1)
    if target ==# 'tex'
        let target = 'latex'
    elseif target ==# 'md'
        let target = 'markdown'
    end
    if target == -1
        if &ft ==# 'tex'
            let target = 'latex'
        elseif &ft ==# 'pandoc'
            let target = 'markdown'
        else
            let target = &ft
        end
    end
    let _shellredir = &shellredir
    set shellredir=>
    exe "read! if encoded=`xclip -selection clipboard -o -t text/html` 2>/dev/null; then echo $encoded | pandoc --wrap=none -f HTML -t ". target . "; else xclip -o; fi"
    let &shellredir=_shellredir
endfunction

" from :h :DiffOrig
command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_
       \ | diffthis | wincmd p | diffthis
" }}}


" file type settings {{{
au Filetype C set
            \ cindent

au Filetype python set
            \ softtabstop=4
            \ expandtab
            \ fileformat=unix

au Filetype vim set
            \ softtabstop=4
            \ expandtab

" " vim-commentary
" au FileType * let b:commentary_format=&commentstring

au BufRead,BufNewFile *.conf setfiletype conf

" }}}

" customize terminal title
function! PathFmt(path)
    let path = substitute(a:path, $HOME, '~', 0)
    let path = substitute(path, '\~/Documents/Uni/', '~Uni/', 0)
    let path = substitute(path, '\~/Documents/', '~Doc/', 0)
    let path = substitute(path, '\~/.config/nvim/', '~.nvim/', 0)
    let path = substitute(path, '\~/.config/', '~.cfg/', 0)
    return path
endfunction
autocmd BufEnter * let &titlestring="vi:" . PathFmt(expand("%:p"))
" autocmd BufEnter * let &titlestring="\ue62b:" . substitute(expand("%:p"), $HOME, '~', 0)
set title

" report directory changes to terminal
" https://github.com/neovim/neovim/issues/21771
autocmd DirChanged * call chansend(v:stderr, printf("\033]7;file://%s\033\\", v:event.cwd))

" customize cursor, highlighting etc {{{
set cul
" nnoremap <leader>v <cmd>set cul!<cr>
hi CursorLine guibg=#151515
hi Cursor guifg=none guibg=none
hi LineNr guifg=#9a9090 guibg=#202030
hi CursorLineNr guibg=#101015
augroup cursor
    au!
    autocmd InsertEnter * highlight CursorLine ctermbg=232
    autocmd InsertEnter * highlight CursorLine guibg=#202020
    autocmd InsertLeave * highlight CursorLine ctermbg=234
    autocmd InsertLeave * highlight CursorLine guibg=#151515
augroup END

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175 " from :h guicursor
" }}}


" highlighting {{{
"hi Search ctermfg=15
"hi IncSearch guibg=#30e060
hi WarningMsg guifg=white guibg=red gui=bold "to make search wrapping more obvious
hi SpellBad cterm=undercurl ctermbg=none gui=undercurl guisp=red
hi SpellCap cterm=undercurl ctermbg=none guisp=lightblue
hi SpellLocal cterm=undercurl ctermbg=none guisp=cyan
hi SpellRare cterm=undercurl ctermbg=none guisp=magenta

hi Conceal ctermfg=lightblue ctermbg=none guibg=NONE
" hi Search ctermfg=0 ctermbg=11 guifg=#ffffe0 guibg=#4090d0
hi Search ctermfg=0 ctermbg=11 guifg=#e0e0e0 guibg=#3e7090
" hi CurSearch guifg=#ffffe0 guibg=#c04010

hi MatchParen guibg=#c00000 guifg=#a0ff00 gui=none
" hi Visual guibg=#254895 gui=none " PaperColor
hi Visual guibg=#244483 gui=none
hi NvimSurroundHighlight gui=inverse

hi LspDiagnosticsDefaultHint guibg=#303030 guifg=#c77000
" hi pandocStrikeout gui=strikethrough " doesn't work :(
" }}}

" remember stuff across sessions {{{
" remember last cursor position
augroup vimrcEx
    autocmd!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it for commit messages, when the position is invalid, or when
    " inside an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost *
                \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
augroup END

" remember marks
set viminfo='100,f1 " https://www.linux.com/news/vim-tips-moving-around-using-marks-and-jumps/
" }}}

augroup HlYank
    autocmd!
    "autocmd TextYankPost * if v:event.operator ==# 'y' | call s:hl_yank() | endif
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup END
" }}}

autocmd BufWinEnter * if !exists('b:has_been_entered')|let b:has_been_entered = 1|silent! .foldopen|endif

" filetype specific settings {{{

"autocmd User targets#mappings#user call targets#mappings#extend({
            "\ '+': {'pair': [{'o':'+', 'c':'-'}, {'o':'[', 'c':']'}]}
    "\ })
" }}}


" -----------------------------------------------------------------------
" utility functions
" -----------------------------------------------------------------------
function! ScrollEnd(id)
    call search('^.', 'b')
endfunction


" -----------------------------------------------------------------------
" for debugging/experimenting
" -----------------------------------------------------------------------

function Debug(arg)
    call system('echo dbg:' . string(a:arg) . '> /tmp/fifo')
endfunction


" au CmdlineChanged * lua require'lualine'.refresh()
" au CmdlineChanged * redrawstatus

function! Searchcount() abort
    if !v:hlsearch
        return ''
    endif

    try
        let cnt = searchcount({'maxcount': 0, 'timeout': 50})
        " lua cnt = vim.fn.searchcount({maxcount = 0, timeout = 50})
        " call Debug('count')
        " call Debug(cnt.total)
        " lua vim.fn.Debug(cnt.total)
    catch /^Vim\%((\a\+)\)\=:\%(E486\)\@!/
        return '[?/??]'
    endtry

    if empty(cnt)
        return ''
    endif

    return cnt.total
            \ ? cnt.incomplete
            \   ? printf('[%d/??]', cnt.current)
            \   : printf('[%d/%d]', cnt.current, cnt.total)
            \ : '[0/0]'
endfunction

lua << EOF
function lua_sc()
    s = vim.fn.Searchcount()
    return s .. "lua"
end
EOF

" set statusline=%<%f\ %h%m%r\ %{Searchcount()}%=%-14.(%l,%c%V%)\ %P
