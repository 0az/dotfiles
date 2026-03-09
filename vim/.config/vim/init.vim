" Load, install, and test the try_require global
lua require('initcore.try-require').try_require('initcore.try-require')
lua try_require('initcore.try-require')

source <sfile>:h/init.before.lua
source <sfile>:h:h/vim/vimrc
