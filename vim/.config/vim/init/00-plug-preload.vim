" vim: set tabstop=8 shiftwidth=8:

" Plug Preload

if use_xdg_data_home
	let plug_path = $XDG_DATA_HOME . "/vim/autoload/plug.vim"
else
	let plug_path = '~/.vim/autoload/plug.vim'
endif

if empty(glob(plug_path))
	echo "plug path: " . plug_path
	let plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	" silent execute '!curl -fLo ' . plug_path . ' --create-dirs ' . plug_url
	execute '!curl -fLo ' . plug_path . ' --create-dirs ' . plug_url
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
