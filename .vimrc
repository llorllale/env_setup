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

set nu 							"Enables line numbers
highlight LineNr ctermfg=yellow
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

" pretty print xml
:map <C-B><C-X> :execute '% !xmlstarlet format -s 2'<CR>
" pretty print json
:map <C-B><C-J> :execute '% !python -m json.tool'<CR>

"mapping omnicompletion keys to the more popular Ctrl-Space combination found
"on most IDEs
:inoremap <C-Space> <C-X><C-O>

highlight CursorLine ctermfg=White ctermbg=DarkGrey
"swap and backup options
"this way Vim's swap files won't clutter the actual directory where the 
"source file is being edited - avoids having to 'ignore' them with 
"CVS.
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" VIM-GO
let g:go_list_type = "quickfix"                     	" make all lists of type quickfix
let g:go_fmt_command = "goimports"										" runs goimports when we save a file
" let g:go_metalinter_autosave = 1											" runs GoMetaLinter on every save
let g:go_highlight_types = 1													" syntax highlighting for types
let g:go_highlight_fields = 1													" syntax highlighting for fields
let g:go_highlight_functions = 1											" syntax highlighting for functions
let g:go_guru_scope = ["..."]
let g:go_gocode_unimported_packages = 0
let g:go_gocode_autobuild = 1
set autowrite 																				" Automatically save before :next, :make etc.
map <C-j> :cnext<CR>			  													" Cycle next through quicklist
map <C-k> :cprevious<CR>    													" Cycle previous through quicklist
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>r :GoRun<CR>
autocmd FileType go nmap <leader>t :GoTest<CR>
autocmd FileType go nmap <leader>l :GoMetaLinter<CR> 	" Run :GoMetaLinter
autocmd FileType go nmap <C-g> :GoDeclsDir<CR>
autocmd FileType go imap <C-g> <esc>:<C-u>GoDeclsDir<CR>
autocmd FileType go nmap <Leader>d :GoDoc<CR>
autocmd FileType go nmap <Leader>i :GoInfo<CR>
autocmd FileType go nmap <C-r> :GoRename 
autocmd FileType go imap <C-r> <ESC>:GoRename 
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
" autocmd FileType go set laststatus=2
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=2 shiftwidth=2

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
	if l:file =~# '^\f\+_test\.go$'
		call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
	  call go#cmd#Build(0)
	endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>c :GoCoverageToggle<CR>
autocmd FileType go set updatetime=100
autocmd FileType go set completeopt=longest,menuone
autocmd FileType go inoremap <Nul> <C-x><C-o>
autocmd FileType go highlight Pmenu ctermbg=black ctermfg=blue

