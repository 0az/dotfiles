" vim: set expandtab ts=2 sw=2 sts=2:

" black.vim
" Author: Łukasz Langa
" Created: Mon Mar 26 23:27:53 2018 -0700
" Requires: Vim Ver7.0+
" Version:  1.1
"
" Documentation:
"   This plugin formats Python files.
"
" History:
"  1.0:
"    - initial version
"  1.1:
"    - restore cursor/window position after formatting

" License: MIT
" SPDX-License-Identifier: MIT

" Extracted from GH:psf/black@2989dc1bf822b1b2a6bd250cea37bbf20c237764
" Modified to use autoloading and an external Python file.

if exists("g:load_black")
   finish
endif

let g:load_black = "py1.0"
if !exists("g:black_virtualenv")
  if has("nvim")
    let g:black_virtualenv = "~/.local/share/nvim/black"
  else
    let g:black_virtualenv = "~/.vim/black"
  endif
endif
if !exists("g:black_fast")
  let g:black_fast = 0
endif
if !exists("g:black_linelength")
  let g:black_linelength = 88
endif
if !exists("g:black_string_normalization")
  if exists("g:black_skip_string_normalization")
    let g:black_string_normalization = !g:black_skip_string_normalization
  else
    let g:black_string_normalization = 1
  endif
endif
if !exists("g:black_quiet")
  let g:black_quiet = 0
endif

python3 << EndPython3
EndPython3
py3file <sfile>:h/vim_black.py

function! black#Black()
python3 << EndPy3
try:
    Black()
except NameError:
    print('Error: Black not loaded')
EndPy3
endfunc

func! black#BlackUpgrade()
    py3 BlackUpgrade()
endfunc

func! black#BlackVersion()
    py3 BlackVersion()
endfunc
