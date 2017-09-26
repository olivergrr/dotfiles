"VIM Congfigs"

set t_Co=256
" ================ Search ===========================
"Gary 
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
" If a file is changed outside of vim, automatically reload it without asking
set autoread
" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
"set re=1

set incsearch       " Find the next match as we type the search

let mapleader=","

" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>x :w\|!%<CR>
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
let old_name = expand('%')
let new_name = input('New file name: ', expand('%'), 'file')
if new_name != '' && new_name != old_name
exec ':saveas ' . new_name
exec ':silent !rm ' . old_name
redraw!
endif
endfunction
map <leader>n :call RenameFile()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INLINE VARIABLE (SKETCHY)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InlineVariable()
" Copy the variable under the cursor into the 'a' register
:let l:tmp_a = @a
:normal "ayiw
" Delete variable and equals sign
:normal 2daW
" Delete the expression into the 'b' register
:let l:tmp_b = @b
:normal "bd$
" Delete the remnants of the line
:normal dd
" Go to the end of the previous line so we can start our search for the
" usage of the variable to replace. Doing '0' instead of 'k$' doesn't
" work; I'm not sure why.
normal k$
" Find the next occurence of the variable
exec '/\<' . @a . '\>'
" Replace that occurence with the text we yanked
exec ':.s/\<' . @a . '\>/' . escape(@b, "/")
:let @a = l:tmp_a
:let @b = l:tmp_b
endfunction
nnoremap <leader>ri :call InlineVariable()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RemoveFancyCharacters COMMAND
" Remove smart quotes, etc.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RemoveFancyCharacters()
let typo = {}
let typo["“"] = '"'
let typo["”"] = '"'
let typo["‘"] = "'"
let typo["’"] = "'"
let typo["–"] = '--'
let typo["—"] = '---'
let typo["…"] = '...'
:exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

set number
" Required to be able to use keypad keys and map missed escape sequences
set esckeys
" changes special characters in search patterns (default)
set magic

"Roberto settings
"set nowrap
set nocompatible

syntax on
set visualbell
autocmd BufRead,BufNewFile *.gsf set ft=ruby
let b:verilog_indent_modules = 1


set hlsearch

if has('gui_win32')
    		set guifont=Courier:h15:cANSI
  	else
   		set guifont=Courier\ 15
 	endif

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Linebreak on 500 characters
"set lbr
"set tw=500

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

"set nowrap       "Don't wrap lines
set wrap          "Wrap lines
set linebreak     "Wrap lines at convenient points
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Custom Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Print  stats
set ruler
"move in the same column
set nostartofline
"Window pane resizing
nnoremap <silent> <Leader>[ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>] :exe "resize " . (winheight(0) * 2/3)<CR>

"ctrl p
set runtimepath^=~/.vim/bundle/ctrlp.vim

"nerdtree
set runtimepath^=~/.vim/bundle/nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
