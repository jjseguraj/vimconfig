" Plugins
" ==========================================================================

" Find ctags file from current directory upwards until root
silent set tags=./tags;/

" Pathogen plugin runtimepath manager
execute pathogen#infect()
call pathogen#helptags() " generate helptags for everything in ‘runtimepath’
syntax on
filetype plugin indent on

" Tagbar
"   start on the left
"   find ctags.exe binary
if has('gui_running')
    let tagbar_left = 1
    let g:tagbar_ctags_bin='ctags'
endif

" Look and feel
if has('gui_running')
    colorscheme desert
    set lines=999 columns=999
    set cc=81
    set guifont=Roboto\ Mono\ Medium\ for\ Powerline\ 11
    let g:airline_powerline_fonts = 1
    let g:Powerline_symbols = 'fancy'
else
    colorscheme slate
    if exists("+lines")
        set lines=50
    endif
    if exists("+columns")
        set columns=100
    endif
endif

" Tab behaviour
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

if has('gui_running')
    " NERDtree
    "   enabled by default
    "   close vim if the only remaining window is nerdtree
    autocmd vimenter * NERDTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

    " Open NERDTree + Tagbar + MiniBufExplorer
    function! s:LayoutWindows()
        execute 'NERDTree'
        let nerdtree_buffer = bufnr(t:NERDTreeBufName)
        execute 'wincmd q'
        execute 'TagbarOpen'
        execute 'wincmd h'
        execute '35 wincmd |'
        execute 'split'
        execute 'b' . nerdtree_buffer
        execute ':1'
        execute 'wincmd j'
        execute ':1'

        let mbe_window = bufwinnr("-MiniBufExplorer-")
        if mbe_window != -1
            execute mbe_window . "wincmd w"
            execute 'wincmd K'
        endif
        execute 'resize +17'
        execute 'wincmd ='
        execute 'wincmd l'
    endfunction
    autocmd VimEnter * call<SID>LayoutWindows()
endif

" Custom behavior
" ==========================================================================
" Space bar will remove the search highlight
nnoremap <space> :noh<return>

" Enable folding and always start unfold
set foldmethod=syntax
au BufRead * normal zR

" Enable highlighting and incremental search
set hls is ic

" De-activate line wrapping.
set nowrap

" Set the list of hidden chars to showed when ":set list" is typed
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" Custom plugins map to keys
" ==========================================================================
map <F12> <ESC>:NERDTreeToggle<RETURN>
map <F11> <ESC>:TagbarToggle<RETURN>

" Mappings for CScope
" ==========================================================================
" CTags Key bindings
"   Alt-]   opens a list of all tag locations and allows choosing one
"   Ctrl-'  horizontal split to the tag location
"   Alt-'   vertical split to the tag location
"   Ctrl-\  open a new tab on the tag location
"map <A-]> g<C-]>
"map <C-'> <C-w><C-]>
"map <A-'> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
"map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
let GtagsCscope_Auto_Load = 1
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
set cscopetag

"map Esc to a more convenient shortcut.
imap <S-Space> <Esc>

" Automatic Deactivation of CapsLock
" Execute 'lnoremap x X' and 'lnoremap X x' for each letter a-z.
for c in range(char2nr('A'), char2nr('Z'))
  execute 'lnoremap ' . nr2char(c+32) . ' ' . nr2char(c)
  execute 'lnoremap ' . nr2char(c) . ' ' . nr2char(c+32)
endfor
" Kill the capslock when leaving insert mode.
autocmd InsertLeave * set iminsert=0
