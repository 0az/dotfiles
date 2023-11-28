" vim: set tabstop=8 shiftwidth=8:

" Plugin Settings

" quick-scope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_hi_priority = 2

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let g:lightline = {
\}

if ! has('gui_running') || ! exists('g:colors_name')
	" Wombat has a sensibly neutral look
	let g:lightline.colorscheme = 'wombat'
elseif g:colors_name =~? '\v.*solarized.*'
	let g:lightline.colorscheme = 'solarized'
	" let g:lightline.colorscheme = 'wombat'
endif

augroup LightlineColorscheme
	autocmd!
	autocmd ColorScheme * call s:lightline_update()
augroup END
function! s:lightline_update()
	if !exists('g:loaded_lightline')
		return
	endif
	try
		if g:colors_name =~# '\vwombat|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
			let g:lightline.colorscheme =
			\ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
			call lightline#init()
			call lightline#colorscheme()
			call lightline#update()
		endif
	catch
	endtry
endfunction

let s:js_ale_linters = g:has_nvim ? [] : [
	\ 'importjs',
	\ 'prettier',
	\ 'eslint',
	\ 'tsserver',
	\ 'xo',
\ ]
let s:js_ale_fixers = g:has_nvim ? [] : [
	\ 'importjs',
	\ 'prettier',
	\ 'eslint',
	\ 'xo',
\ ]

let g:ale_linters = {
	\ 'java': [
		\ 'checkstyle',
		"\ 'eclipselsp',
		\ 'javac',
		"\ 'javalsp',
		"\ 'pmd',
	\ ],
	"\ 'javascript': s:js_ale_linters,
	"\ 'javascriptreact': s:js_ale_linters,
	"\ 'typescript': s:js_ale_linters,
	"\ 'typescriptreact': s:js_ale_linters,
	\ 'go': [
		\ 'gopls'
	\ ],
	\ 'python': [
		"\ 'flake8',
		\ 'mypy',
		"\ 'pylint',
		"\ 'pyls',
		"\ 'pyright',
		\ 'jedils',
		\ 'ruff',
	\ ],
	\ 'rust': [
		\ 'analyzer',
		\ 'clippy',
	\ ],
\ }

let g:ale_fixers = {
	\ 'java': [
		\ 'google_java_format',
	\ ],
	\ 'javascript': s:js_ale_fixers,
	\ 'javascriptreact': s:js_ale_fixers,
	\ 'typescript': s:js_ale_fixers,
	\ 'typescriptreact': s:js_ale_fixers,
	\ 'go': [
		\ 'gofmt',
		\ 'goimports'
	\ ],
	\ 'python': [
		\ 'add_blank_lines_for_python_control_statements',
		\ 'remove_trailing_lines',
		\ 'trim_whitespace',
		\ 'isort',
		\ 'ruff',
		\ 'black',
	\ ],
	\ 'rust': [
		\ 'rustfmt',
	\ ],
\ }

let g:ale_javascript_eslint_options = '--env browser,node --parser-options=ecmaVersion:latest'
let g:ale_javascript_eslint_use_global = 0
let g:ale_python_auto_pipenv = 1
let g:ale_python_auto_poetry = 1
let g:ale_python_pyls_use_global = 1
let g:ale_sh_shellcheck_options = '-x'

if g:has_nvim
	let g:ale_use_neovim_diagnostics_api = 1
endif

let s:yaml_lint_options =<< END
--config-data "
indentation:
  space: 2
  indent-sequences: consistent
"
END
let g:ale_yaml_yamllint_options  = join(s:yaml_lint_options)

" Python
let g:black_linelength = 80
let g:black_skip_string_normalization = 1

if use_xdg_data_home
	let g:black_virtualenv = $XDG_DATA_HOME . '/vim/black'
else
	let g:black_virtualenv = '~/.vim/black'
endif

" Javascript
let g:javascript_plugin_jsdoc = 1

" YouCompleteMe
let g:ycm_python_interpreter_path = exepath('python3')

let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
	\ 'g:ycm_python_interpreter_path',
	\ 'g:ycm_python_sys_path'
\]
let g:ycm_global_ycm_extra_conf = g:vim_config_home . '/ycm_global_extra_conf.py'

let g:ycm_filter_diagnostics = {
	\ "javascript": {
		\ "regex": [
			\ ".*Cannot find Module.*"
		\ ]
	\ }
\ }
let g:ycm_filetype_blacklist = {
	\ "javascript": 1,
	\ "typescript": 1,
	\ "javascriptreact": 1,
	\ "typescriptreact": 1,
	\ "rust": 1,
\ }

" Syntastic
" let g:syntastic_swift_swiftlint_use_defaults = 1 
" let g:syntastic_swift_checkers = ['swiftlint', 'swiftpm'] 

" UltiSnips
let g:UltiSnipsExpandTrigger = '<c-j>'
" let g:UltiSnipsJumpForwardTrigger = '<tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<s-tab>' 

" Tex
let g:vimtex_compiler_method = 'latexmk'

" Markdown
let g:vim_markdown_new_list_item_indent = 0

" EasyTags
let g:easytags_file = g:vim_data_home . '/tags'
