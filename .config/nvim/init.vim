" vim: foldmethod=marker
" vim: foldlevel=1
let g:python3_host_prog = expand('/usr/bin/python3')
set tabstop=4
set shiftwidth=4

"" configure vim-plug plugin manager {{{
"packadd packer.nvim
"lua << END
"require('packer').startup(function()
"    use 'wbthomason/packer.nvim'
"    use 'lervag/vimtex' -- TeX stuff
"    use 'nvim-lualine/lualine.nvim'
"    use 'tpope/vim-commentary'
"    use 'tpope/vim-sleuth' -- autodetecs indetation type of file - slow on startup
"    use 'tpope/vim-surround' -- sourround things, change surrounders
"    use 'tpope/vim-repeat' -- makes plugin maps repeatable
"    use 'junegunn/fzf.vim'
"    use 'tpope/vim-fugitive' -- Git integration
"    use {'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
"    use 'dkarter/bullets.vim' -- automatically continue bullet lists
"    use {'vim-pandoc/vim-pandoc-syntax', ft = 'pandoc'}
"    use {'vim-pandoc/vim-pandoc', ft = {'pandoc', 'pandoc-tex'}} -- for pandoc
"    use 'sirver/UltiSnips' -- insert snippets
"    use {'honza/vim-snippets', ft = {'tex', 'snippets'}} -- lots of predefined snippets
"    use 'lambdalisue/suda.vim' -- sudo-save with :W
"    use {'vim-python/python-syntax', ft = 'python'}
"    use 'tpope/vim-scriptease'
"    use {'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end}
"    use 'windwp/nvim-autopairs'
"    use {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd('TSUpdate') end}
"    use 'easymotion/vim-easymotion'
"end)
"END

call plug#begin()
    Plug 'lervag/vimtex' " TeX stuff
    "Plug 'Valloric/YouCompleteMe' " Python, C++, ... autocompletion
    "Plug 'vim-airline/vim-airline' " fancy statusbar
    Plug 'nvim-lualine/lualine.nvim'
    "Plug 'scrooloose/nerdcommenter' " provides (filetype-aware) maps for commenting stuff out
    Plug 'tpope/vim-commentary'
    "Plug 'tpope/vim-sleuth' " autodetecs indetation type of file - slow on startup
    Plug 'tpope/vim-surround' " sourround things, change surrounders
    Plug 'tpope/vim-repeat' " makes plugin maps repeatable
    "Plug 'dimbleby/black.vim' " slow
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-fugitive' " Git integration
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'dkarter/bullets.vim' " automatically continue bullet lists
    Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}
    Plug 'vim-pandoc/vim-pandoc', {'for': ['pandoc', 'pandoc-tex']} " for pandoc
    Plug 'sirver/UltiSnips' " insert snippets
    "Plug 'honza/vim-snippets', {'for': ['tex', 'snippets']} " lots of predefined snippets
    Plug 'lambdalisue/suda.vim' " sudo-save with :W
    "Plug 'jiangmiao/auto-pairs' " autocomplete ( etc.
    Plug 'vim-python/python-syntax', {'for': 'python'}
    Plug 'tpope/vim-scriptease'
    "Plug  'tweekmonster/startuptime.vim'
    Plug 'ces42/firenvim', { 'do': { _ -> firenvim#install(0) } }
    "Plug 'klen/python-mode'
    "Plug 'mhinz/vim-startify' " fancy start screen
    "Plug 'ap/vim-css-color'
    Plug 'windwp/nvim-autopairs'
    "Plug 'wellle/targets.vim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    "Plug 'neovim/nvim-lspconfig'
    "Plug 'neoclide/coc.nvim', {'branch': 'release'}
    "Plug 'monkoose/matchparen.nvim'
    "Plug 'ggandor/lightspeed.nvim'
    Plug 'easymotion/vim-easymotion'
    "Plug 'haya14busa/incsearch.vim' "just jump between matches during incsearch w/ <C-g>
    "Plug 'adelarsq/vim-matchit'
    "Plug 'abecodes/tabout.nvim'
    "Plug 'lukas-reineke/indent-blankline.nvim', {'for': ['vim', 'python', 'snippets']}
    "Plug 'Konfekt/FastFold'
    "Plug 'Raimondi/delimitMate'
call plug#end()
" }}}

    "let g:loaded_matchparen = 1
    "Youcompleteme fix
    "let g:ycm_global_ycm_extra_conf = '~/.config/nvim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
    "let g:ycm_min_num_of_chars_for_completion=4

    " airline {{{
    if !exists('g:airline_symbols')
       let g:airline_symbols = {}
    endif
    let g:airline_symbols.maxlinenr = '' " used to be '㏑'
    let g:airline_symbols.linenr = ' ' " used to be '☰'
    let g:airline_symbols.colnr = ':'
    let g:airline_symbols.dirty='⚡'
    let g:airline_symbols.branch = ''
    let g:airline#extensions#fzf#enabled = 1
    "let g:airline_powerline_fonts = 1
    let g:airline#extensions#whitespace#mixed_indent_algo = 2
    let g:airline#extensions#whitespace#trailing_format = 'tr:%s'
    let g:airline#extensions#whitespace#mixed_indent_file_format = 'mi:%s'
    let g:airline#extensions#wordcount#formatter#default#fmt = '%sW'
    " }}}

    let g:pymode_python = 'python3'

    " bullets.vim
    let g:bullets_enabled_file_types = ['markdown', 'gitcommit']

    "python-syntax {{{
    let g:python_highlight_string_format = 1
    let g:python_highlight_builtins = 1
    let g:python_highlight_exceptions = 1
    let g:python_highlight_space_errors = 1
    let g:python_highlight_operators = 1
    let g:python_highlight_class_vars = 1
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

    " easymotion
    map <Leader> <Plug>(easymotion-prefix)




" filetype plugin indent on " already done by plug#end()
" syntax on " already done by plug#end()
set termguicolors
set guifont=JuliaMono:h12
color PaperColor

"~/.config/nvim/lua/npairs.lua
lua require('npairs')
"lua require('treesitter')
"lua require('texlab')
" ~/.config/nvim/lua/lualine_config.lua
lua require('lualine_config')
"lua require('matchparen').setup()
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

hi IndentBlanklineChar guifg=#2a2a2a
"lua require("indent_blankline").setup {
"            \    show_current_context = true,
"            \}

" UltiSnips {{{
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

let g:UltiSnipsEditSplit="tabdo"

autocmd BufLeave * call UltiSnips#LeavingBuffer() " fixes crash when doing gt inside snippet

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
    let g:timer_started = v:false
    function! My_Write(timer) abort
        let g:timer_started = v:false
        write
    endfunction

    function! Delay_My_Write(delay) abort
        if g:timer_started
            return
        end
        let g:timer_started = v:true
        call timer_start(a:delay, 'My_Write')
    endfunction

    function! Firenvim_get_text()
        if exists('g:status') && g:status == 'translate'
            return py3eval('list(map(tr_write, vim.api.buf_get_lines(0, 0, -1, 0)))')
        end
        " else
        return nvim_buf_get_lines(0, 0, -1, 0)
    endfunction

    augroup FireNVim
        
        au!
        py3 from translate_tex_chr import tr_restore_buffer, tr_write

        " TeXnique
        au BufEnter firenvim_texnique_*.tex call AlwaysMath()
        au BufEnter firenvim_texnique_*.tex nnoremap <leader>c ggcG
        
        au BufEnter firenvim_texnique_*.tex let g:status = 'translate'
        "au BufEnter firenvim_texnique_*.tex function! Firenvim_get_text() abort
        "                                  "\     return py3eval('list(map(tr_write, vim.api.buf_get_lines(0, 0, -1, 0)))')
        "                                  \     return ["AAA"]
        "                                  \ endfunction
        "au BufWritePre firenvim_texnique_*.tex py3 tr_change_buffer('unix')
        "au BufWritePost firenvim_texnique_*.tex py3 tr_restore_buffer()
        au TextChangedI firenvim_texnique_*.tex call Delay_My_Write(100)
        au TextChanged firenvim_texnique_*.tex call Delay_My_Write(100)
        "au BufWrite firenvim_texnique_*.tex %s/\$//ge
        "au BufWrite firenvim_texnique_*.tex lua expand_font_macros()
        "au BufEnter firenvim_texnique_*.tex normal i$
        
        " Stackexchange
        au BufEnter firenvimSE_*.tex let g:status = 'translate'
        au BufWritePre firenvimSE_*.tex lua expand_font_macros()
        "au BufWritePre firenvimSE_*.tex py3 tr_change_buffer('unix')
        "au BufWritePost firenvimSE_*.tex py3 tr_restore_buffer()
        au TextChangedI firenvimSE_*.tex call Delay_My_Write(2000)
        au TextChanged firenvimSE_*.tex call Delay_My_Write(2000)

        au BufEnter * set nonumber
        "au BufWrite SE_*.tex lua expand_font_macros()
        au BufReadPre /tmp/*.tex let b:translate_tex_unicode = 0
    augroup END

    let g:firenvim_config = {
        \ 'localSettings': {
            \ '.*': {
                \ 'cmdline': 'neovim',
                \ 'content': 'text',
                \ 'priority': 0,
                \ 'selector': 'textarea:not([readonly]), div[role="textbox"]',
                \ 'takeover': 'never',
            \ },
            \ 'mathoverflow.net': {
                \ 'filename': '/tmp/firenvimSE_MO_{pathname%20}_{timestamp%32}.tex',
            \ },
            \ 'math.stackexchange.com': {
                \ 'filename': '/tmp/firenvimSE_MSE_{pathname%20}_{timestamp%32}.tex',
            \ },
            \ 'texnique.xyz': {
                \ 'takeover': 'always',
                \ 'filename': '/tmp/firenvim_texnique_{pathname%20}_{timestamp%32}.tex',
            \ },
        \ }
    \ }
endif
" }}}

" targets.vim {{{
"let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'
" }}}

" enable Alt+Key combinations .... {{{
" ...in 7-bit terminal (apparently everything except xterm)
" https://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim/10216459#10216459
"let c='a'
"while c <= 'z'
"" exec "set <A-".c.">=\e".c
"exec "imap \e".c." <A-".c.">"
"let c = nr2char(1+char2nr(c))
"endw

"" fixes the above when using airline
"" https://www.reddit.com/r/neovim/comments/35h1g1/neovim_slow_to_respond_after_esc/
"if ! has('gui_running')
"augroup FastEscape
    "autocmd!
    "au InsertEnter * set timeoutlen=100
    "au InsertLeave * set timeoutlen=1000
"augroup END
"endif
"" }}}

" set options {{{
set history=10000

set ttimeout ttimeoutlen=3

" backspace at beginning of line
set backspace=indent,eol,start

set mouse=a "mouse mode
set clipboard=unnamed " use system clipboard

set undofile " save undo history

set so=2 " show 2 lines before/after cursor

set showcmd " show commands typed in normal mode
set lazyredraw " don't redraw during macro execution

set splitright " split window appear on right
set hi=1000 " size of command history

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

set number " show line numbers

"" line wrapping
" breakindent can make insert mode slow
set breakindent " Indents word-wrapped lines as much as the 'parent' line
set lbr " word-wrap does not split words

" messages
set shortmess-=F " show file info when opening
set shortmess-=T " don't truncate messages

" show warning when search wraps
set shortmess+=S " this disables the match counter :/

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
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
" prevent Ctrl+U from deleting work https://vim.fandom.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" make Ctrl+R break undo sequence
inoremap <C-R> <C-G>u<C-R>
" Ctrl+R twice to paste default buffer, Ctrl+R-Ctrl+E to paste 0-buffer
inoremap <C-R><C-R> <C-R>"
inoremap <C-R><C-T> <C-R>*
inoremap <C-R><C-E> <C-R>+
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
" press '\a' to show tabs
map <leader>a :set list!<cr>
" press '\f' to show foldcolumn
function! ToggleFoldcolumn()
    if &foldcolumn
        let &l:foldcolumn = 0
    else
        let &l:foldcolumn = 2
    endif
endfunction
" press '\m' to enable folding by markers
map <leader>m :set foldmethod=marker<CR>
"nnoremap <expr> <leader>f ToggleFoldcolumn()
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
" Up/Down/PageUp/PageDown etc. in command mode like in bash
cnoremap <C-p> <PageUp>
cnoremap <C-n> <PageDown>
cnoremap <M-p> <Up>
cnoremap <M-n> <Down>
" <C-.> for quick insertion of %:h (directory of the current file)
cnoremap <C-.> %:h
" Spacebar inserts space in normal mode too
nnoremap <Space> i <Esc>l
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" 'g/' to search for selected text in visual mode
xnoremap g/ "zy/<C-R>z<CR>
" gy to copy the whole buffer into the Ctrl+C clipboard
nnoremap gy gg"+yG``
" C-T to open fzf in normal mode
nnoremap <C-T> :Files ~<CR>

" Don't clutter unnamed register with one-character deletes
"nnoremap x "-x "disable this because I *do* like doing xp
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

" gY to visually select current "line" w.r.t line wrap
nnoremap gV g^vg$

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

" save when file is readonly using sudo
command! WW SudaWrite %|set nomodified

" fugitive shortcuts
command! Gc Git commit % -m .
command! GC Git commit % -m .
command! Gl Git pull
command! GL Git pull
command! Gp Git push
command! GP Git push

command! Rc tabe ~/.config/nvim/init.vim
command! RC tabe ~/.config/nvim/init.vim

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

nnoremap <f5> :set autochdir<bar>:w<bar>make %<cr>
imap <f5> <C-o>:w<bar>make<cr>

nnoremap <F3> :%s//g<Left><Left>
inoremap <F3> <Esc>:%s//g<Left><Left>

nnoremap g/ /\c<left><left>
" }}}

" file type settings {{{
au Filetype C set
            \ cindent

au Filetype python set
            \ softtabstop=4
            \ textwidth=99
            \ expandtab
            \ fileformat=unix

au Filetype vim set
            \ softtabstop=4
            \ expandtab

"autocmd FileType markdown let g:airline#extensions#whitespace#checks = [ 'indent' ]

" vim-commentary
au FileType * let b:commentary_format=&commentstring

" }}}

" customize terminal title
autocmd BufEnter * let &titlestring="nvim:" . expand("%:p")
set title

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

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175 " from :h guicursor
"hi Search ctermfg=15
"hi IncSearch guibg=#30e060
hi WarningMsg guifg=white guibg=red gui=bold "to make search wrapping more obvious
hi SpellBad cterm=undercurl ctermbg=none gui=undercurl guisp=red
hi SpellCap cterm=undercurl ctermbg=none guisp=lightblue
hi SpellLocal cterm=undercurl ctermbg=none guisp=cyan
hi SpellRare cterm=undercurl ctermbg=none guisp=magenta

hi Conceal ctermfg=lightblue ctermbg=none guibg=NONE


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

" briefly highlight yanked text {{{
" https://vimrcfu.com/snippet/254
"function! s:hl_yank() abort
    "let [sl, el, sc, ec] = [line("'["), line("']"), col("'["), col("']")]
    "if sl == el
        "let pos_list = [[sl, sc, ec - sc + 1]]
    "else
        "let pos_list = [[sl, sc, col([sl, "$"]) - sc]] + range(sl + 1, el - 1) + [[el, 1, ec]]
    "endif

    "for chunk in range(0, len(pos_list), 8)
        "call matchaddpos('IncSearch', pos_list[chunk:chunk + 7])
    "endfor
    "redraw!
    "call timer_start(300, {t_id -> clearmatches()})
"endfunction

augroup HlYank
    autocmd!
    "autocmd TextYankPost * if v:event.operator ==# 'y' | call s:hl_yank() | endif
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup END
" }}}


" filetype specific settings {{{

"autocmd User targets#mappings#user call targets#mappings#extend({
            "\ '+': {'pair': [{'o':'+', 'c':'-'}, {'o':'[', 'c':']'}]}
    "\ })
" }}}

"profile start output.log
"profile func *
