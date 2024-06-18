" vim: set tabstop=8 shiftwidth=8:

" Plugins (Plug)

call plug#begin(g:vim_data_home . '/plugged')

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
Plug 'tpope/vim-sleuth'			" Automatically set buffer options
Plug 'tpope/vim-sensible'		" vim-sensible

" Editor plugins
Plug 'editorconfig/editorconfig-vim'	" Editorconfig support
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
					" Tree explorer
Plug 'tpope/vim-obsession',
	\ { 'on': ['Obsess', 'Obsess!'] }
					" Session manager

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
Plug 'preservim/tagbar'			" Tagbar
Plug 'junegunn/fzf', {
	\ 'do': { -> fzf#install() }
\ }
Plug 'junegunn/fzf.vim'

" Color Scheme
" Plug 'arcticicestudio/nord-vim'		" Nord Theme
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
Plug 'rust-lang/rust.vim'		" Rust support
Plug 'sheerun/vim-polyglot'		" Syntax pack
Plug 'vieira/vim-javascript'		" Better JS syntax
Plug 'herringtondarkholme/yats.vim'	" Better TS syntax
Plug 'vim-pandoc/vim-pandoc'		" Pandoc support
Plug 'vim-pandoc/vim-pandoc-syntax'	" Pandoc syntax
Plug 'ipkiss42/xwiki.vim'		" XWiki syntax

" Completion plugins
Plug 'mattn/emmet-vim', {
	\ 'for': [
		\ 'html',
	\ ],
\ }
VimPlug 'ycm-core/YouCompleteMe', {
	\ 'do': 'python3 ./install.py',
\ }
					" Completion

" Integration plugins:
Plug 'dense-analysis/ale'		" Linting/Fixing, Language Server Protocol
VimPlug 'neoclide/coc.nvim', {
	\ 'branch': 'release',
	\ 'for': [
		\ 'java',
		\ 'javascript',
		\ 'typescript',
	\ ]
\ }
					" Language Server Protocol
Plug 'maximbaz/lightline-ale'		" ALE support for Lightline
Plug 'hashivim/vim-terraform'		" Terraform/HCL
Plug 'lervag/vimtex'			" Tex
Plug 'tpope/vim-fugitive'		" Git porcelain
" Plug 'xolox/vim-easytags'		" Magical ctags support
					" ^ High init time!
Plug 'ludovicchabant/vim-gutentags'	" Better-maintained ctags plugin
Plug 'jeetsukumaran/vim-pythonsense', {
	\ 'for': 'python',
\ }
" Better Python textobjs/motions

NvimPlug 'neovim/nvim-lspconfig'	" Community LSP configs for nvim-lsp
NvimPlug 'nvim-lua/plenary.nvim'
NvimPlug 'mfussenegger/nvim-dap'

NvimPlug 'hrsh7th/nvim-cmp'		" Nvim completion engine with plugins

NvimPlug 'hrsh7th/cmp-buffer'
NvimPlug 'hrsh7th/cmp-cmdline'
NvimPlug 'hrsh7th/cmp-nvim-lsp'
NvimPlug 'hrsh7th/cmp-path'
NvimPlug 'quangnguyen30192/cmp-nvim-ultisnips'

NvimPlug 'mrcjkb/rustaceanvim'	" Rust, Batteries-included
NvimPlug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
					" Treesitter manager

" Formatting Plugins
" Plug 'dimbleby/black.vim'		" Black!
" 					" Pulled from GitHub

" Misc Plugins
Plug 'gerw/vim-hilinktrace'		" Highlight Debug
Plug 'andrewradev/bufferize.vim'	" Send command output to buffer
" Plug 'xolox/vim-misc'			" Required for vim-easytags
					" ^ High init time!
Plug 'dylnmc/synstack.vim'		" Syntax debugging

runtime! local/init-hooks/plug-plugins.vim

" Initialize plugin system
call plug#end()
