" -------------- General behaviour -----------------
" not compatible with old vi
set nocp
" normal backspace behaviour
set backspace=indent,eol,start
" mappings for <home> and <end> (for some terminals)
nnoremap <A-a> <C-a>
map <C-A> <Home>
map <C-E> <End>
" enable escape keys (some cursor and function keys)
set esckeys
" make mouse work
set mouse=a
" silent bell
set novisualbell
set t_vb=

" remove swap
set noswapfile

" wrap long lines
set wrap
" ruler can be useful
set ruler
" show incomplete commands
set showcmd
" never make backups (e.g. file~)
set nobackup

" limit number of open tabs to 100
set tabpagemax=100

" search as you type, without highlighting
set incsearch
set nohlsearch
set smartcase

set clipboard^=unnamed

" --------------- Indents and folding --------------
" indentation
set autoindent
set smartindent 
" default tab size = 2
set shiftwidth=2
set tabstop=2
" auto folding
"set foldmethod=indent
set scrolljump=7
set scrolloff=7

set fileencodings=utf-8,cp1251,koi8-r,koi8-u

filetype indent on
filetype plugin on

" ------------------- Syntax -----------------------
syntax enable
" highlight parens but don't highlight background
"hi MatchParen term=bold gui=bold ctermfg=white ctermbg=black guifg=white guibg=black
" highlight very long lines
au BufWinEnter *.go,*.java let w:m2=matchadd('ErrorMsg', '\%>120v.\+', -1)
au BufWinEnter *.c,*.cxx,*.h,*.hxx,*.cpp,*.hpp,*.mkd,*.md let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" -------------------- Hotkeys ---------------------
" <f2> = save
noremap  <F2>    :update<CR>
inoremap <F2>    <C-O>:update<CR>
vnoremap <F2>    <C-C>:update<CR>

nnoremap ; :

" cmdline editing
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Autoclose [, {, "
imap [ []<left>
imap {<cr> {<cr>}<esc>O

"
" Langage-specific options
"
augroup C
	function C() 
		iab <buffer> #i #include
		iab <buffer> #d #define
		let g:clang_format#code_style="llvm"
		let c_no_curly_error=1
	endfun
	au!
	au BufWinEnter *.c,*.cc,*.cxx,*.cpp,*.h,*.hh,*.hxx,*.hpp call C()
augroup END

augroup Java
	function Java()
		iab <buffer> pu public
		iab <buffer> po protected
		iab <buffer> pr private
		iab <buffer> @o @Override
		iab <buffer> st static
		iab <buffer> S  String
		let g:JavaImpPaths = $HOME . "/.vim/bundle/javaimp/android.jmplst"
		let g:JavaImpSortPkgSep = 1
		let g:JavaImpDataDir = $HOME . "/.vim/bundle/javaimp"
		let g:JavaImpJarCache = g:JavaImpDataDir . "/cache" 
		let g:JavaImpClassList = g:JavaImpDataDir . "/JavaImp.txt" 
		nmap \ai :JavaImpSilent<CR>:JavaImpSort<CR>
	endfun
	au!
	au BufWinEnter *.java,*.kt,*.scala call Java()
augroup END

augroup Js
	function JavaScript()
		iab <buffer> fn function
	endfun
	au!
	au BufWinEnter *.js,*.es6 call JavaScript()
augroup END

augroup Markdown
	function Markdown()
		set ft=markdown
		set ai formatoptions=tcroqn2 comments=n:>
		syn spell toplevel
		syn case ignore
		syn sync linebreaks=1
	endfun
	au!
	au BufWinEnter *.md,*.mkd,*.markdown call Markdown()
augroup END

" ------------ Support local vimrc files ------------
function SetLocalOptions(fname)
	let dirname = fnamemodify(a:fname, ":p:h")
	while "/" != dirname
		let lvimrc  = dirname . "/.lvimrc"
		if filereadable(lvimrc)
			execute "source " . lvimrc
			break
		endif
		let dirname = fnamemodify(dirname, ":p:h:h")
	endwhile
endfunction

au BufNewFile,BufRead * call SetLocalOptions(bufname("%"))

if filereadable($HOME . "/.vimrc.local")
  source $HOME/.vimrc.local
endif

"
" Fix insertion
"
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
if has("gui_running")
	set guioptions-=T  " no toolbar, menu, scrollbars
	set guioptions-=m
	set guioptions-=l
	set guioptions-=r
	set guioptions-=b
	colorscheme elflord
	set guifont=Terminus\ 10
endif

silent! call pathogen#infect()

set t_ut= " redraw background in tmux
set background="dark"
silent! colorscheme less

" Use Ctrl-P instad of Command-T
nmap \t :CtrlP<cr>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|gradle)$',
  \ 'file': '\v\.(o|so|class|pyc)$',
  \ }

let g:netrw_banner = 0
let g:netrw_liststyle = 3
nmap <leader>l :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" NerdCommenter toggle comment, _ is a / in vim
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>

" ES6 support
autocmd BufRead,BufNewFile *.es6 setfiletype javascript
let g:javascript_enable_domhtmlcss = 1

" Golang
let g:go_fmt_command="goimports"
" Rust
let g:rustfmt_autosave = 1

nmap <Leader>e :tabedit %:h<CR>
