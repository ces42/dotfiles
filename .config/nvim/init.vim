" vim: foldmethod=marker
" vim: foldlevel=1
let g:python3_host_prog = expand('/usr/bin/python3')
set tabstop=4
set shiftwidth=4

let mapleader=' '
let maplocalleader=' '

set termguicolors
" ~/.config/nvim/lua/init.lua
lua require('init')

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
let g:AutoPairsMapCh = 0
let g:AutoPairsShortcutBackInsert='<M-v>'

" incsearch.vim
"map /  <Plug>(incsearch-forward)
"map ?  <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)


" filetype plugin indent on " already done by plug#end()
" syntax on " already done by plug#end()
set guifont=JuliaMono:h12
color PaperColor
" colorscheme catppuccin-mocha

"lua require('texlab')
"lua require('tabout').setup{
"            \    tabkey = '<C-j>',
"            \    backwards_tabkey = '<C-;>',
"            \    act_as_tab = false,
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

hi IndentBlanklineChar guifg=#2a2a2a
"lua require("indent_blankline").setup {
"            \    show_current_context = true,
"            \}

" UltiSnips {{{
" Trigger configuration. Do not use 'tab' if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

let g:UltiSnipsEditSplit="tabdo"

"autocmd BufLeave * call UltiSnips#LeavingBuffer() " fixes crash when doing gt inside snippet

"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? coc#_select_confirm() :
     "\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()

"function! s:check_back_space() abort
    "let col = col('.') - 1
    "return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"let g:coc_snippet_next = '<tab>'
" }}}

" vimtex
so ~/.config/nvim/tex.vim

" auto-pairs {{{
"let g:autopairs_center_line = 0
"let g:AutoPairsBackInsert = "<M-V>"
""let g:AutoPairs = {'(':')', '[':']', '{':'}','"':'"', '`':'`', '$':'$'}
"au FileType tex let b:AutoPairs = AutoPairsDefine({'$' : '$'})
"}}}


" FireNVim {{{
if exists('g:started_by_firenvim')
    source ~/.config/nvim/firenvim.vim
endif
" }}}

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

set so=2 " show 2 lines before/after cursor

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

" C-A, C-X operates on digits, letters, hex and binary numbers
set nrformats=alpha,hex,bin

" linenumbers
set number
set relativenumber
autocmd BufLeave * : if &nu | setlocal norelativenumber | endif
autocmd BufEnter * : if &nu | setlocal relativenumber | endif
autocmd FocusLost * : if &nu | setlocal norelativenumber | endif
autocmd FocusGained * : if &nu | setlocal relativenumber | endif

"" line wrapping
" breakindent can make insert mode slow
set breakindent " Indents word-wrapped lines as much as the 'parent' line
set lbr " word-wrap does not split words

" messages
set shortmess-=F " show file info when opening
set shortmess-=T " don't truncate messages

" show warning when search wraps
set shortmess+=S " this disables the match counter :/

set modelineexpr

" }}}

" TODO something for folding

" https://vi.stackexchange.com/questions/18310/keep-relative-cursor-position-after-indenting-with {{{
func! Indent(ind)
    if &sol
        set nostartofline
    endif
    let vcol = virtcol('.')
    if a:ind
        norm! >>
        exe "norm!". (vcol + shiftwidth()) . '|'
    else
        norm! <<
        exe "norm!". (vcol - shiftwidth()) . '|'
    endif
endfunc

noremap >> :call Indent(1)<cr>
noremap << :call Indent(0)<cr>
" Shift + Tab deindents line
imap <S-Tab> <C-\><C-o><<

" }}}

" key bindings {{{
" easymotion
map <leader> <Plug>(easymotion-prefix)

" prevent Ctrl+U from deleting work https://vim.fandom.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" make Ctrl+R break undo sequence
inoremap <C-R> <C-G>u<C-R>
" Ctrl+R twice to paste default buffer, Ctrl+R-Ctrl+E to paste 0-buffer
inoremap <C-R><C-R> <C-R>"
inoremap <C-R><C-T> <C-R>*
inoremap <C-R><C-E> <C-R>+
" ctrl+L in insert mode to correct last spelling mistake
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" press '\h' to highlight search results
map <leader>h :set hlsearch!<cr>
" press '\l' to show line Numbers, '\rl' to show relative line numbers
map <leader>l :set nu!<cr>
map <leader>r :set rnu!<cr>
" <leader>8 / 9 / 0 for 80 / 90 / 100 character line
map <leader>8 :set colorcolumn=80<cr>
map <leader>9 :set colorcolumn=90<cr>
map <leader>0 :set colorcolumn=100<cr>
map <leader>1 :set colorcolumn=<cr>
" press '\m' to enable folding by markers
map <leader>m :set foldmethod=marker<CR>
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
inoremap <C-w> <C-\><C-o>"zdB
" C-Backspace delete previous word, C-Del word after cursor
inoremap <C-BS> <C-\><C-o>"zdb
cnoremap <C-BS> <C-w>
inoremap <C-h> <C-\><C-o>"zdb
cnoremap <C-h> <C-w>
inoremap <C-Del> X<Left><C-o>"zde
" ctrl-d as alias for del
inoremap <C-D> <del>
" C-a and C-e for jumping to start/end of line (like bash)
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
cnoremap <C-a> <home>
cnoremap <C-e> <end>
" Alt/C + b/f for word/character movement (like bash/emacs)
"inoremap <C-f> <Right>
"inoremap <C-b> <Left>
inoremap <M-f> <C-\><C-o>e<Right>
inoremap <M-b> <C-\><C-o>b
" Ctrl + hjkl to move in insert and command mode
inoremap <M-j> <C-o>gj
inoremap <M-k> <C-o>gk
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
inoremap <C-s> <C-o>:update<CR>
nnoremap <C-s> :update<CR>
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

nnoremap <C-/> :noh<CR>
" 'g/' to search for selected text in visual mode
xnoremap g/ "zy/<C-R>z<CR>
" gy to copy the whole buffer into the Ctrl+C clipboard
nnoremap gy gg"+yG``

" " C-T to open Telescope file picker in normal mode
" nnoremap <C-T> <cmd>Telescope find_files<CR>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Don't clutter unnamed register with one-character deletes
"nnoremap x "-x "disable this because I *do* like doing xp
" vnoremap <c-d> "zx
vnoremap x "zx
nnoremap <Del> "-x

" Shift-enter does the same as o but w/o changing mode
nmap <S-CR> o<ESC>
imap <S-CR> <C-\><C-o>o

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
"nnoremap <silent> \e :set opfunc=Extract<cr>g@

nnoremap <f5> :set autochdir<bar>:w<bar>make %<cr>
imap <f5> <C-o>:w<bar>make<cr>

nnoremap <F3> :%s//g<Left><Left>
inoremap <F3> <Esc>:%s//g<Left><Left>

nnoremap g/ /\c<left><left>

" <C-;> as a more easily repeatable alternative to g;
nnoremap <C-;> g;
inoremap <C-;> <C-\><C-o>g;

" Alt-backspace to undo in insert mode
inoremap <A-BS> <C-o>u

" gs as alias for ys (vim-surround)
nmap gs ys
nmap gss yss

" AltGr + s for surrounding
nmap ß ys
nmap ßß yss

" AltGr + : for lua command mode
nnoremap ¶ :lua

" QQ to leave vim
nnoremap QQ :qa<enter>

" Alt-C to copy current filename to clipboard
nnoremap <M-c> :let @+ = substitute(expand('%'), '/home/ca/', '~/', '')<CR>
inoremap <M-c> <C-o>:let @+ = substitute(expand('%'), '/home/ca/', '~/', '')<CR>

" }}}


" commands {{{
" save when file is readonly using sudo
command! WW Lazy load suda.vim | SudaWrite % | e | set noreadonly

"common typos
command! W  w
command! Wq wq
command! WQ wq
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

command! Rc tabe ~/.config/nvim/init.vim | tabe ~/.config/nvim/lua/init.lua | tabe ~/.config/nvim/lua/plugins/misc.lua
command! RC tabe ~/.config/nvim/init.vim | tabe ~/.config/nvim/lua/init.lua | tabe ~/.config/nvim/lua/plugins/misc.lua

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
    :set shellredir=>
    exe "read! if encoded=`xclip -selection clipboard -o -t text/html` 2>/dev/null; then echo $encoded | pandoc --wrap=none -f HTML -t ". target . "; else xclip -o; fi"
    let &shellredir=_shellredir
endfunction

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
autocmd BufEnter * let &titlestring="vi:" . substitute(expand("%:p"), $HOME, '~', 0)
" autocmd BufEnter * let &titlestring="\ue62b:" . substitute(expand("%:p"), $HOME, '~', 0)
set title

" report directory changes to terminal
" https://github.com/neovim/neovim/issues/21771
autocmd DirChanged * call chansend(v:stderr, printf("\033]7;file://%s\033\\", v:event.cwd))

" customize cursor, highlighting etc {{{
set cul
nnoremap <leader>v :set cul!<cr>
hi CursorLine guibg=#101010
augroup cursor
    au!
    autocmd InsertEnter * highlight  CursorLine ctermbg=232
    autocmd InsertEnter * highlight  CursorLine guibg=#202020
    autocmd InsertLeave * highlight  CursorLine ctermbg=234
    autocmd InsertLeave * highlight  CursorLine guibg=#101010
augroup END

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait300-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175 " from :h guicursor
"hi Search ctermfg=15
"hi IncSearch guibg=#30e060
hi WarningMsg guifg=white guibg=red gui=bold "to make search wrapping more obvious
hi SpellBad cterm=undercurl ctermbg=none gui=undercurl guisp=red
hi SpellCap cterm=undercurl ctermbg=none guisp=lightblue
hi SpellLocal cterm=undercurl ctermbg=none guisp=cyan
hi SpellRare cterm=undercurl ctermbg=none guisp=magenta

hi Conceal ctermfg=lightblue ctermbg=none guibg=NONE

hi MatchParen guibg=#c00000 guifg=#a0ff00 gui=none

" hi Cursor guifg=white

hi pandocStrikeout gui=strikethrough
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

"profile start output.log
"profile func *


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
