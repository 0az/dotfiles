" Vim syntax support file
" This applies customizations after $VIMRUNTIME/syntax/syncolor.vim

if &background == "dark"
	hi Comment	term=italic cterm=italic ctermfg=Gray ctermbg=NONE gui=NONE guifg=#80a0ff guibg=NONE
else
	hi Comment	term=italic cterm=italic ctermfg=DarkGray ctermbg=NONE gui=NONE guifg=Blue guibg=NONE
endif
