" vim: set tabstop=8 shiftwidth=8:

" Mappings
let mapleader = '\'
let maplocalleader = '+'

" Move across wrapped lines like regular lines
" noremap 0 ^ " Go to the first non-blank character of a line
" noremap ^ 0 " Just in case you need to go to the very beginning of a line

nmap <D-Bslash> :NERDTreeToggle<CR>
nmap <F2> :ALERename<CR>

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
imap <C-Space> <Plug>(ale_complete)
nmap <F1> <Plug>(ale_hover)
imap <F1> <Plug>(ale_hover)
nmap <S-F1> <Plug>(ale_detail)
imap <S-F1> <Plug>(ale_detail)
nmap <F12> <Plug>(ale_go_to_definition_in_split)
imap <F12> <Plug>(ale_go_to_definition_in_split)
nmap <S-F12> <Plug>(ale_find_references)
imap <S-F12> <Plug>(ale_find_references)

if has("unix")
	let s:uname = system("uname -s")
	if s:uname == "Darwin"
		echo "Setting up Darwin keymaps"
	endif
endif
