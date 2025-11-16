" Integration plugins:
Plug 'dense-analysis/ale'		" Linting/Fixing, Language Server Protocol
VimPlug 'neoclide/coc.nvim', {
	\ 'branch': 'release',
	\ 'for': [
		\ 'java',
		\ 'javascript',
		\ 'typescript',
		\ 'javascriptreact',
		\ 'typescriptreact',
	\ ]
\ }
					" Language Server Protocol
Plug 'hashivim/vim-terraform'		" Terraform/HCL
Plug 'lervag/vimtex'			" Tex
Plug 'tpope/vim-fugitive'		" Git porcelain
" Plug 'xolox/vim-easytags'		" Magical ctags support
					" ^ High init time!
" Plug 'ludovicchabant/vim-gutentags'	" Better-maintained ctags plugin
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

" Formatting Plugins
" Plug 'dimbleby/black.vim'		" Black!
" 					" Pulled from GitHub
