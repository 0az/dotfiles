" vim: set tabstop=8 shiftwidth=8:

" Plugins (Plug)

if $VIM_SKIP_PLUGINS
	call plug#begin(g:plug_home)
	call plug#end()
	finish
endif

call plug#begin(g:plug_home)

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

source <sfile>:h/plug/general.vim
source <sfile>:h/plug/editor.vim
source <sfile>:h/plug/interface.vim
source <sfile>:h/plug/text.vim
source <sfile>:h/plug/filetype.vim
source <sfile>:h/plug/integration.vim
source <sfile>:h/plug/misc.vim

runtime! local/init-hooks/plug-plugins.vim

" Initialize plugin system
call plug#end()
