" vim: set tabstop=8 shiftwidth=8:

if !exists('g:shortlinkify_loaded')
	let g:shortlinkify_loaded = 1
endif


let g:shortlinkify_patterns = get(g:, 'shortlinkify_patterns', {})
let g:shortlinkify_link_format = get(g:, 'shortlinkify_link_format', {})

let g:shortlinkify_link_format[''] = get(g:shortlinkify_link_format, '', '[%2$s](%1$s)')
let g:shortlinkify_link_format['markdown'] = get(g:shortlinkify_link_format, 'markdown', '[%2$s](%1$s)')
let g:shortlinkify_link_format['pandoc'] = get(g:shortlinkify_link_format, 'pandoc', '[%2$s](%1$s)')


function! s:TransformPattern(pattern)
	return '\C' .. '\%(^\|\s\|\%([(<[{]\)\@<!\)' .. '\%(://[^ ]*/\?\)\@<!' .. '\<\zs' .. a:pattern .. '\ze\>\%(\%([)>\]}]\)\@!\|\s\|$\)'
endfunction

function! s:Shortlinkify(text)
	let l:line = a:text

	for [l:pattern, l:replacement] in items(g:shortlinkify_patterns)
		let l:pattern = s:TransformPattern(l:pattern)
		let l:link_replacement = get(g:shortlinkify_link_format, &filetype, '')
		let l:link_replacement = get(b:, 'shortlinkify_link_format', l:link_replacement)

		if l:link_replacement != '' && l:link_replacement != '%1$s'
			let l:replacement = printf(l:link_replacement, l:replacement, '&')
		endif

		let l:line = substitute(l:line, l:pattern, l:replacement, 'g')
	endfor

	return l:line
endfunction

function! shortlinkify#Shortlinkify(...) range
	let l:bang = a:0 > 0 && a:1 == '!' ? 1 : 0

	let l:firstline = a:firstline
	let l:lastline = a:lastline

	if l:bang && l:firstline == l:lastline
		let l:firstline = 1
		let l:lastline = line('$')
	endif

	let &g:undolevels = &g:undolevels
	let l:changed = 0

	for l:ln in range(l:firstline, l:lastline)
		let l:line = getline(l:ln)
		let l:original_line = l:line

		let l:line = s:Shortlinkify(l:line)

		if l:line != l:original_line
			call setline(l:ln, l:line)
			let l:changed = 1
		endif
	endfor

	if l:changed
		let &g:undolevels = &g:undolevels
	endif
endfunction
