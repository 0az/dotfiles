" vim: set tabstop=8 shiftwidth=8:

" Plugin Settings

" quick-scope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_hi_priority = 2

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let g:lightline = {
\}
" XXX: Maybe move to gvimrc
if has('gui_running')
	let g:lightline.colorscheme = 'solarized'
else
	let g:lightline.colorscheme = 'wombat'
	" Wombat has a sensibly neutral look
endif

let s:js_ale_linters = [
	\ 'importjs',
	\ 'prettier',
	\ 'eslint',
	\ 'tsserver',
	\ 'xo',
\ ]
let s:js_ale_fixers = [
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
		"\ 'mypy',
		"\ 'pylint',
		\ 'pyls',
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
		"\ 'isort',
		"\ 'add_blank_lines_for_python_control_statements',
		"\ 'remove_trailing_lines',
		"\ 'trim_whitespace',
	\ ],
\ }

let g:ale_javascript_eslint_options = '--env browser,node --parser-options=ecmaVersion:latest'
let g:ale_javascript_eslint_use_global = 0
let g:ale_python_auto_pipenv = 1
let g:ale_python_pyls_use_global = 1
let s:yaml_lint_options =<< END
--config-data "
indentation:
  space: 2
  indent-sequences: consistent
"
END
let g:ale_yaml_yamllint_options  = join(s:yaml_lint_options)

" Python
let g:black_linelength = 79
let g:black_skip_string_normalization = 1

if use_xdg_data_home
	let g:black_virtualenv = $XDG_DATA_HOME . '/vim/black'
else
	let g:black_virtualenv = '~/.vim/black'
endif

" Javascript
let g:javascript_plugin_jsdoc = 1

" YouCompleteMe
" let g:ycm_server_python_interpreter = '/opt/local/bin/python3'
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
