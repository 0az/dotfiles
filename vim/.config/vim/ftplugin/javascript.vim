setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80
setlocal wrap

if g:has_nvim
	let b:ale_enabled = 0
endif

function! s:prettier()
	if ! &modifiable
		return
	endif

	if &modified
		let l:pos = winsaveview()
		exe '%!prettier --stdin-filepath %'
		call winrestview(l:pos)
	else
		exe 'silent !prettier --write %'
		exe 'redraw!'

	endif
endfunc

nnoremap <silent> <buffer> <localleader>b :call <SID>prettier()<CR>
inoremap <silent> <buffer> <localleader>b <C-o>call <SID>prettier()<CR>

if g:not_nvim
	nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
	nmap <silent> <C-j> <Plug>(coc-diagnostic-next)
	nmap <silent> <F12> <Plug>(coc-definition)
	nmap <silent> <M-F12> <Plug>(coc-type-definition)
	nmap <silent> <C-F12> <Plug>(coc-implementation)
	nmap <silent> <S-F12> <Plug>(coc-references)

	nmap <F2> <Plug>(coc-rename)
endif
