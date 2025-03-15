" vim: set tabstop=8 shiftwidth=8:

" Plug Preload

let g:plug_home = g:common_data_home . '/plugged'
let s:plug_path = g:common_data_home . '/autoload/plug.vim'

if !filereadable(s:plug_path)
	echom "plug path: " . s:plug_path
	let plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	execute '!curl -fLo ' . s:plug_path . ' --create-dirs ' . plug_url
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let s:plug = function('plug#')

function s:VimPlug(...)
	if g:not_nvim
		call call(s:plug, a:000)
	else
		call call(s:plug, [a:1, {'on': []}])
	endif
endfunc

function s:NvimPlug(...)
	if g:has_nvim
		call call(s:plug, a:000)
	else
		call call(s:plug, [a:1, {'on': []}])
	endif
endfunc

command! -nargs=+ -bar VimPlug call s:VimPlug(<args>)
command! -nargs=+ -bar NvimPlug call s:NvimPlug(<args>)
