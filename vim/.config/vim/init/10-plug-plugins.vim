" vim: set tabstop=8 shiftwidth=8:

" Plugins (Plug)

if use_xdg_data_home
	call plug#begin($XDG_DATA_HOME . '/vim/plugged')
else
	call plug#begin('~/.vim/plugged')
endif

" Plug help:
" | PlugInstall [name ...] [#threads]	| Install plugins
" | PlugUpdate [name ...] [#threads]	| Install or update plugins
" | PlugClean[!]			| Remove unused directories (bang version will clean without prompt)
" | PlugUpgrade				| Upgrade vim-plug itself
" | PlugStatus				| Check the status of plugins
" | PlugDiff				| Examine changes from the previous update and the pending changes
" | PlugSnapshot[!] [output path]	| Generate script for restoring the current snapshot of the plugins
"
" More plugins:
" | https://vimawesome.com/

" General Plugins
Plug 'tpope/vim-sensible'		" vim-sensible

" Editor plugins
Plug 'editorconfig/editorconfig-vim'	" Editorconfig support
Plug 'scrooloose/nerdtree'		" Tree explorer

" Interface plugins
Plug 'airblade/vim-gitgutter'		" Add git diff info to gutter
" vim-css-color breaks things
" Plug 'ap/vim-css-color'			" ???
Plug 'ctrlpvim/ctrlp.vim'		" Fuzzy finder
Plug 'itchyny/lightline.vim'		" Lightline
Plug 'junegunn/goyo.vim'		" Minimalist mode
Plug 'junegunn/limelight.vim'		" Highlight current paragraph
Plug 'tpope/vim-repeat'			" Repeat plugin maps
Plug 'unblevable/quick-scope'		" Quick character motion

" Color Scheme
Plug 'arcticicestudio/nord-vim'		" Nord Theme
Plug 'lifepillar/vim-solarized8'	" Solarized Theme

" Text plugins
Plug 'tpope/vim-surround'		" Quotes/Parens/Brackets
" Plug 'scrooloose/nerdcommenter'	" Commenting
" Plug 'tpope/vim-commentary'		" Commenting
Plug 'sirver/ultisnips'			" Snippets
Plug 'wellle/targets.vim'		" Extra text objects

" Code plugins
" Plug 'GutenYe/json5.vim'		" JSON5 syntax
" Plug 'cespare/vim-toml'		" TOML
" Plug 'keith/swift.vim'		" Swift syntax
" Plug 'scrooloose/syntastic'		" Syntax checking
" Plug 'udalov/kotlin-vim'		" Kotlin syntax
Plug 'sheerun/vim-polyglot'		" Syntax pack
Plug 'vieira/vim-javascript'		" Better JS syntax
Plug 'vim-pandoc/vim-pandoc'		" Pandoc support
Plug 'vim-pandoc/vim-pandoc-syntax'	" Pandoc syntax

" Completion plugins
Plug 'mattn/emmet-vim'			" Emmet
Plug 'ycm-core/YouCompleteMe', {
	\ 'do': 'python3 ./install.py',
\ }
					" Completion

" Integration plugins:
Plug 'dense-analysis/ale'		" Linting/Fixing, Language Server Protocol
Plug 'neoclide/coc.nvim', {
	\ 'branch': 'release',
	\ 'for': [
		\ 'javascript',
		\ 'typescript'
	\ ]
\ }
					" Language Server Protocol
Plug 'maximbaz/lightline-ale'		" ALE support for Lightline
Plug 'hashivim/vim-terraform'		" Terraform/HCL
Plug 'lervag/vimtex'			" Tex
Plug 'tpope/vim-fugitive'		" Git porcelain

" Formatting Plugins
" Plug 'dimbleby/black.vim'		" Black!
" 					" Pulled from GitHub

" Misc Plugins
Plug 'gerw/vim-hilinktrace'		" Highlight Debug
Plug 'andrewradev/bufferize.vim'	" Send command output to buffer

" Initialize plugin system
call plug#end()
