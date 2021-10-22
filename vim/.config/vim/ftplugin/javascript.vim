setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80
setlocal wrap

function! s:prettier()
	if &modified || ! &modifiable
		let pos = winsaveview()
		exe '%!pnpm -- prettier --stdin-filepath %'
		call winrestview(pos)
	else
		" call system('silent !pnpm -- prettier --write %')
		exe 'silent !pnpm -- prettier --write %'
		exe 'redraw!'

	endif
endfunc

nnoremap <silent> <buffer> <localleader>b :call <SID>prettier()<CR>
inoremap <silent> <buffer> <localleader>b <C-o>call <SID>prettier()<CR>
