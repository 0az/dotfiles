" Interface plugins

Plug 'airblade/vim-gitgutter'		" Add git diff info to gutter
" vim-css-color breaks things
" Plug 'ap/vim-css-color'			" ???
Plug 'ctrlpvim/ctrlp.vim'		" Fuzzy finder
Plug 'junegunn/goyo.vim'		" Minimalist mode
Plug 'junegunn/limelight.vim'		" Highlight current paragraph
Plug 'tpope/vim-repeat'			" Repeat plugin maps
Plug 'unblevable/quick-scope'		" Quick character motion
Plug 'preservim/tagbar'			" Tagbar
Plug 'junegunn/fzf', {
	\ 'do': { -> fzf#install() }
\ }
Plug 'junegunn/fzf.vim'

Plug 'itchyny/lightline.vim'		" Lightline
" NvimPlug 'josa42/nvim-lightline-lsp'	" Neovim LSP support for Lightline
NvimPlug '0az/nvim-lightline-lsp'	" Neovim LSP support for Lightline

" Color Scheme
" Plug 'arcticicestudio/nord-vim'		" Nord Theme
Plug 'lifepillar/vim-solarized8'	" Solarized Theme
