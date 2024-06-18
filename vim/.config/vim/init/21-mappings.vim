" vim: set tabstop=8 shiftwidth=8:

" Mappings
let mapleader = '\'
let maplocalleader = '+'

map <C-Tab> :tabnext<CR>
" imap <C-Tab> <Esc>:tabnext<CR>i

map <C-S-Tab> :tabprevious<CR>
nmap <C-S-Tab> :tabprevious<CR>
inoremap <M-BS> <C-O>b<C-O>dw
nnoremap <C-S> :%s/
inoremap <C-S> <C-O>:%s/

" imap <C-S-Tab> <Esc>:tabprevious<CR>i

" Move across wrapped lines like regular lines
" noremap 0 ^ " Go to the first non-blank character of a line
" noremap ^ 0 " Just in case you need to go to the very beginning of a line

if g:has_nvim
	silent! unmap Y
	noremap <ScrollWheelUp> <Up>
	noremap <ScrollWheelDown> <Down>
endif

if exists('loaded_ale') || exists('plugs') && has_key(g:plugs, 'ale')
	nmap <silent> <C-k> <Plug>(ale_previous_wrap)
	nmap <silent> <C-j> <Plug>(ale_next_wrap)
	nmap <leader>b <Plug>(ale_fix)
	nmap <leader>f <Plug>(ale_fix)
	nmap <localleader>f <Plug>(ale_fix)
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
endif

nnoremap <silent> <F8> :TagbarToggle<CR>

if g:has_mac
	nnoremap <D-Bslash> :NERDTreeToggle<CR>
	inoremap <D-Bslash> <C-O>:NERDTreeToggle<CR>
	inoremap <D-BS> ^<C-O>d$

	" NOTE: These mappings are case seensitive
	nnoremap <D-s> :w<CR>
	inoremap <D-s> <C-O>:w<CR>
endif

" Emacs mappings in the command line, from `:h emacs-keys`
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>
cnoremap <C-E> <End>
" cnoremap <C-F> <Right>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap <M-B> <S-Left>
cnoremap <M-F> <S-Right>

function CmdLineKillToEnd()
	let l:pos = getcmdpos()

	return l:pos == 1 ? "" : getcmdline()[:l:pos-2]
endfunction

cnoremap <C-K> <C-\>eCmdLineKillToEnd()<CR>
