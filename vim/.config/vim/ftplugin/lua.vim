function! s:stylua()
	if &modified || ! &modifiable
		let pos = winsaveview()
		exe '%!stylua --quote-style AutoPreferSingle %'
		call winrestview(pos)
	else
		exe 'silent !stylua --quote-style AutoPreferSingle %'
		exe 'redraw!'

	endif
endfunc

nnoremap <silent> <buffer> <localleader>b :call <SID>stylua()<CR>
inoremap <silent> <buffer> <localleader>b <C-o>call <SID>stylua()<CR>
