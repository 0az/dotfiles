" black.vim

if v:version < 700 || !has('python3')
    func! __BLACK_MISSING()
        echo "The black.vim plugin requires vim7.0+ with Python 3.6 support."
    endfunc
    command! Black :call __BLACK_MISSING()
    command! BlackUpgrade :call __BLACK_MISSING()
    command! BlackVersion :call __BLACK_MISSING()
    finish
endif

command! Black call black#Black()
command! BlackUpgrade call black#BlackUpgrade()
command! BlackVersion call black#BlackVersion()

nnoremap <Plug>(python-black) :Black<Return>
