" vim: set tabstop=8 shiftwidth=8:

if !exists('g:tidybufs_loaded')
	let g:tidybufs_loaded = 1
endif

function! tidybufs#TidyBufs() abort
	let l:all_bufs = getbufinfo({'buflisted': 1})
	let l:cwd = getcwd()
	let l:unwanted_bufs = []
	for l:info in l:all_bufs
		if empty(l:info.name) || l:info.hidden || l:info.loaded
			continue
		endif
		if l:info.name[0 : len(l:cwd) - 1] == l:cwd && (l:info.changed || filereadable(l:info.name))
			continue
		endif
		call add(l:unwanted_bufs, l:info.bufnr)
	endfor
	if !empty(l:unwanted_bufs)
		execute 'bdelete' join(l:unwanted_bufs)
	endif
endfunction
