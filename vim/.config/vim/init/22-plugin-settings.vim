" vim: set tabstop=8 shiftwidth=8:

" Plugin Settings

" quick-scope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_hi_priority = 2

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let s:lightline_default_active_left = [['mode', 'paste'], ['readonly', 'filename', 'modified']]
let s:lightline_default_active_right = [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]

let g:lightline = {
	\ 'active': {},
	\ 'component_expand': {},
	\ 'component_function': {},
	\ 'component_type': {},
\ }

if g:has_nvim
	let s:lightline_left = deepcopy(s:lightline_default_active_left)

	if has_key(g:plugs, 'nvim-lightline-lsp')
		let s:lightline_lsp = [
			\ ['lsp_errors', 'lsp_warnings'],
		\ ]
		call extend(s:lightline_left, s:lightline_lsp)

		let s:lightline_lsp_component_expand = {
			\ 'lsp_errors': 'lightline#lsp#errors',
			\ 'lsp_warnings': 'lightline#lsp#warnings',
			\ 'lsp_status': 'lightline#lsp#status',
		\ }
		call extend(g:lightline.component_expand, s:lightline_lsp_component_expand)

		let s:lightline_lsp_component_type = {
			\ 'lsp_errors': 'left',
			\ 'lsp_hints': 'hints',
			\ 'lsp_info': 'info',
			\ 'lsp_ok': 'left',
			\ 'lsp_warnings': 'left',
		\ }
		call extend(g:lightline.component_type, s:lightline_lsp_component_type)
	endif

	let g:lightline.active.left = s:lightline_left
endif

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

let g:ale_history_log_output = 0

let s:js_ale_linters = g:has_nvim ? [
	\ 'prettier',
	\ 'eslint',
\ ] : [
	\ 'importjs',
	\ 'prettier',
	\ 'eslint',
	\ 'tsserver',
	\ 'xo',
\ ]
let s:js_ale_fixers = g:has_nvim ? [
	\ 'prettier',
	\ 'eslint',
\ ] : [
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
	\ 'javascript': s:js_ale_linters,
	\ 'javascriptreact': s:js_ale_linters,
	\ 'typescript': s:js_ale_linters,
	\ 'typescriptreact': s:js_ale_linters,
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

let g:ale_linters_ignore = {
	\ 'ruby': [
		\ 'standardrb',
	\ ],
	\ 'swift': [
		\ 'apple-swift-format',
	\ ],
\ }

let s:c_ale_linters_ignore = ['clangcheck', 'clangtidy', 'cppcheck']
if g:has_nvim
	let s:c_ale_linters_ignore += ['cc', 'ccls', 'clangd']
	let g:ale_linters_ignore['c'] = s:c_ale_linters_ignore
	let g:ale_linters_ignore['cpp'] = s:c_ale_linters_ignore
endif

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
	\ 'ruby': [
		\ 'rubocop',
		"\ 'rufo',
		\ 'remove_trailing_lines',
		\ 'trim_whitespace',
	\ ],
	\ 'rust': [
		\ 'rustfmt',
	\ ],
	\ 'swift': [
		\ 'swiftformat',
	\ ],
\ }

let g:ale_javascript_eslint_options = '--env browser,node --parser-options=ecmaVersion:latest'

let g:ale_javascript_eslint_use_global = 0
if executable('eslint_d')
	let g:ale_javascript_eslint_use_global = 1
	let g:ale_javascript_eslint_executable = 'eslint_d'
endif

let g:ale_python_auto_pipenv = 1
let g:ale_python_auto_poetry = 1
let g:ale_python_mypy_ignore_invalid_syntax = 1
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

let g:black_virtualenv = g:common_cache_home . '/black.venv'

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
let g:easytags_file = g:common_cache_home . '/tags'

" Gutentags
let g:gutentags_cache_dir = g:common_cache_home . '/gutentags'

set statusline+=%{gutentags#statusline()}
