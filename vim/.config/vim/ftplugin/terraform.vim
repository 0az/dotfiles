function! s:tf_fmt()
	if &modified || ! &modifiable
		let pos = winsaveview()
		exe 'silent %!terraform fmt --list=false -'
		call winrestview(pos)
	else
		call system('terraform fmt ' .. shellescape(expand('%')))
		checkt
	endif
endfunc

" nnoremap <silent> <buffer> <localleader>b :call <SID>tf_fmt()<CR>
" inoremap <silent> <buffer> <localleader>b <C-o>call <SID>tf_fmt()<CR>
" nnoremap <silent> <buffer> <localleader>b :call terraform#fmt()<CR>
" inoremap <silent> <buffer> <localleader>b <C-o>call terraform#fmt()<CR>
nnoremap <buffer> <localleader>b :call terraform#fmt()<CR>
inoremap <buffer> <localleader>b <C-o>call terraform#fmt()<CR>
