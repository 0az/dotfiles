augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
	\ if &number && mode() != 'i'
	\ | set relativenumber
	\ | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave *
	\ if &number
	\ | set norelativenumber
	\ | endif
augroup END

augroup autoloader
  autocmd!
  autocmd CursorHold * silent! checktime
augroup END
