" vim: set tabstop=8 shiftwidth=8:

" Settings

" Gutter
set number
if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
endif

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

let $BASH_ENV = "$HOME/.bash_aliases"
