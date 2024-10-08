" vim: set tabstop=8 shiftwidth=8:

" Plugin Preload Configuration

" let g:ale_completion_enabled = 1
" let g:ale_cursor_detail = 1
let g:ale_set_balloons = 1
let g:coc_config_home = g:vim_config_home
let g:ycm_key_list_stop_completion = ['<C-e>']

" let s:python_dll_script = ''
" set pythonthreehome=system(python_dll_script)

let g:tex_flavor = 'latex'

if executable('fd')
	let g:ctrlp_user_command = 'command fd -HL -E .git -E .venv -E "*.app" -E node_modules -E /dev -E /sys -E /proc'
endif

let g:pandoc#filetypes#pandoc_markdown = 0

let g:polyglot_disabled = [
	\ 'sensible',
	\ 'javascript.plugin',
	\ 'typescript.plugin',
	\ 'python',
	\ 'rust',
	\ 'terraform',
\]

let g:no_synstack_maps = 0
if has('popupwin')
	let g:synstack_popup = 1
endif

if $COLORTERM == 'truecolor'
	set termguicolors
endif
