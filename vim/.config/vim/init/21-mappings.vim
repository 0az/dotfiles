" vim: set tabstop=8 shiftwidth=8:

" Mappings
let mapleader = '\'
let maplocalleader = '+'

" Move across wrapped lines like regular lines
" noremap 0 ^ " Go to the first non-blank character of a line
" noremap ^ 0 " Just in case you need to go to the very beginning of a line

nmap <D-Bslash> :NERDTreeToggle<CR>
nmap <F2> :ALERename<CR>

if has("unix")
	let s:uname = system("uname -s")
	if s:uname == "Darwin"
		echo "Setting up Darwin keymaps"
	endif
endif
