" vim: set tabstop=8 shiftwidth=8:

" Mappings
let mapleader = '\'
let maplocalleader = '+'

" Move across wrapped lines like regular lines
" noremap 0 ^ " Go to the first non-blank character of a line
" noremap ^ 0 " Just in case you need to go to the very beginning of a line

nmap <D-Bslash> :NERDTreeToggle<CR>
imap <D-Bslash> <C-O>:NERDTreeToggle<CR>

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <leader>b <Plug>(ale_fix)
imap <C-Space> <C-\><C-O><Plug>(ale_complete)
nmap <F1> <Plug>(ale_hover)
imap <F1> <C-\><C-O><Plug>(ale_hover)
nmap <S-F1> <Plug>(ale_detail)
imap <S-F1> <C-\><C-O><Plug>(ale_detail)
nmap <silent> <F2> <Plug>(ale_rename)
imap <silent> <F2> <C-\><C-O><Plug>(ale_rename)
nmap <F12> <Plug>(ale_go_to_definition_in_split)
imap <F12> <C-\><C-O><Plug>(ale_go_to_definition_in_split)
nmap <S-F12> <Plug>(ale_find_references)
imap <S-F12> <C-\><C-O><Plug>(ale_find_references)

if has("unix")
	let s:uname = system("uname -s")
	if s:uname == "Darwin"
		echo "Setting up Darwin keymaps"
	endif
endif
