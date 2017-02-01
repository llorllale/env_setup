set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
" behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

set nu! "Enables line numbers
set guioptions-=m
set guioptions-=T
filetype indent off " Disable filetype-based indentation settings
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set cursorline


" tab navigation like firefox
:nmap <C-p> :tabprevious<CR>
:nmap <C-n> :tabnext<CR>
:map <C-p> :tabprevious<CR>
:map <C-n> :tabnext<CR>
:imap <C-p> <Esc>:tabprevious<CR>i
:imap <C-n> <Esc>:tabnext<CR>i
:nmap <C-t> :tabnew<CR>
:imap <C-t> <Esc>:tabnew<CR>

"PrettyPrintXml
"sudo apt install xmlstarlet
:map <C-B><C-X> :execute '% !xmlstarlet format -s 2'<CR>

"mapping omnicompletion keys to the more popular Ctrl-Space combination found
"on most IDEs
:inoremap <C-Space> <C-X><C-O>

highlight CursorLine ctermfg=White ctermbg=DarkGrey
"swap and backup options
"this way Vim's swap files won't clutter the actual directory where the 
"source file is being edited - avoids having to 'ignore' them with 
"CVS.
set backupdir=/home/llorllale/.vim/backup//
set directory=/home/llorllale/.vim/swap//
set undodir=/home/llorllale/.vim/undo//
