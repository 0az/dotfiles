" vim: set tabstop=8 shiftwidth=8:

" Settings

" Gutter
set number

" set list
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵
set splitbelow
set splitright

" Spaces per tab
set tabstop=4
set shiftwidth=4
set smarttab

set modeline
set laststatus=2
set updatetime=400

set history=1000
set tabpagemax=50

if exists('+autoread')
	set autoread
endif

" let $BASH_ENV = "$HOME/.bash_aliases"
