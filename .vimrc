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

set nu 							"Show line numbers
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

highlight CursorLine ctermbg=DarkGrey
highlight Search cterm=NONE ctermfg=grey ctermbg=DarkBlue
"swap and backup options
"this way Vim's swap files won't clutter the actual directory where the 
"source file is being edited - avoids having to 'ignore' them with 
"CVS.
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" automatically install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'tag': '5.0.0' }
Plug 'fatih/vim-go', { 'tag': 'v1.19' }
Plug 'Townk/vim-autoclose', { 'commit': 'a9a3b7384657bc1f60a963fd6c08c63fc48d61c3' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'commit': '325a1298b0c9d8a4c61388a2f9956a534a9068cd' }
Plug 'airblade/vim-gitgutter', { 'commit': 'c2651aefbd92dca05de1943619df965b848f9b4f' }
Plug 'xolox/vim-easytags', { 'tag': '3.11' }
Plug 'xolox/vim-misc', { 'tag': '1.17.6' }
Plug 'tomtom/tcomment_vim', { 'tag': '3.08.1' }
Plug 'artur-shaik/vim-javacomplete2', { 'tag': '2.3.7' }
call plug#end()

" map omnicompletion keys to the more popular Ctrl-Space combination found
" on most IDEs
:inoremap <C-Space> <C-X><C-O>
if !has("gui_running")
	  " C-@ is a built-in mapping - see :help CTRL-@
		" Mapping C-Space alone doesn't work with vim-ruby for some reason
    inoremap <C-@> <C-X><C-O>
endif

" map C-/ (popular in IDEs) to autocomment a line (with toggle) with tcomment_vim
" you'll have to press C-/ twice each time though
:inoremap <C-/> :TComment<CR>
:nnoremap <C-/> :TComment<CR>

augroup java
	au!
	" vim-javacomplete2
	autocmd Filetype java setlocal omnifunc=javacomplete#Complete
	autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
	autocmd Filetype java nmap <C-I> <Plug>(JavaComplete-Imports-Add)
	autocmd Filetype java nmap <C-S-I> <Plug>(JavaComplete-Imports-RemoveUnused)
	autocmd Filetype java imap <C-S-I> <Plug>(JavaComplete-Imports-RemoveUnused)
augroup END

" VIM-GO
augroup go
	au!
  " gofmt
  :map <C-B><C-G> :execute '% !gofmt -s'<CR>
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
augroup END

" NERDTree
" close vim if the only window left open is a NERDTree
" NERDTree.isTabTree() is not available since dd754c7bc64f8802ab6ff660776e1dee0e0e2761, which
" came AFTER the latest tag 5.0.0
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" open NERDTree automatically when vim starts up
autocmd vimenter * NERDTree
" show dot files
let NERDTreeShowHidden=1
" move cursor to open buffer if a file was provided as arg to vim
autocmd VimEnter * if argc() == 1 | NERDTree | wincmd p | else | NERDTree | endif

" Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

