" Based on https://github.com/vim/vim/blob/master/runtime/indent/yaml.vim

function! GetYAMLIndent(lnum)
    if a:lnum == 1 || !prevnonblank(a:lnum-1)
        return 0
    endif

    let prevlnum = prevnonblank(a:lnum-1)
    let previndent = indent(prevlnum)

    let line = getline(a:lnum)
	echomsg line
	echomsg line =~# '^\s*#'
	echomsg line =~# '^\s*#\s*\S+'
	echomsg line =~# '^\s*#\s*\S+'
    if line =~# '^\s*#' && getline(a:lnum-1) =~# '^\s*#'
        " Comment blocks should have identical indent
        return previndent
    elseif line =~# '^\s*#\s*\S\+'
        " Do not re-indent if commenting out an existing line
		echomsg "indent" indent(a:lnum)
        return indent(a:lnum)
    elseif line =~# '^\s*[\]}]'
        " Lines containing only closing braces should have previous indent
        return indent(s:FindPrevLessIndentedLine(a:lnum))
    endif

    " Ignore comment lines when calculating indent
    while getline(prevlnum) =~# '^\s*#'
        let prevlnum = prevnonblank(prevlnum-1)
        if !prevlnum
            return previndent
        endif
    endwhile

    let prevline = getline(prevlnum)
    let previndent = indent(prevlnum)

    " Any examples below assume that shiftwidth=2
    if prevline =~# '\v[{[:]$|[:-]\ [|>][+\-]?%(\s+\#.*|\s*)$'
        " Mapping key:
        "     nested mapping: ...
        "
        " - {
        "     key: [
        "         list value
        "     ]
        " }
        "
        " - |-
        "     Block scalar without indentation indicator
        return previndent+shiftwidth()
    elseif prevline =~# '\v[:-]\ [|>]%(\d+[+\-]?|[+\-]?\d+)%(\#.*|\s*)$'
        " - |+2
        "   block scalar with indentation indicator
        "#^^ indent+2, not indent+shiftwidth
        return previndent + str2nr(matchstr(prevline,
                    \'\v([:-]\ [|>])@<=[+\-]?\d+%([+\-]?%(\s+\#.*|\s*)$)@='))
    elseif prevline =~# '\v\"%([^"\\]|\\.)*\\$'
        "    "Multiline string \
        "     with escaped end"
        let qidx = match(prevline, '\v\"%([^"\\]|\\.)*\\')
        return virtcol([prevlnum, qidx+1])
    elseif line =~# s:liststartregex
        " List line should have indent equal to previous list line unless it was 
        " caught by one of the previous rules
        return indent(s:FindPrevLEIndentedLineMatchingRegex(a:lnum,
                    \                                       s:liststartregex))
    elseif line =~# s:mapkeyregex
        " Same for line containing mapping key
        let prevmapline = s:FindPrevLEIndentedLineMatchingRegex(a:lnum,
                    \                                           s:mapkeyregex)
        if getline(prevmapline) =~# '^\s*- '
            return indent(prevmapline) + 2
        else
            return indent(prevmapline)
        endif
    elseif prevline =~# '^\s*- '
        " - List with
        "   multiline scalar
        return previndent+2
    elseif prevline =~# s:mapkeyregex . '\v\s*%(%('.s:c_ns_tag_property.
                \                              '\v|'.s:c_ns_anchor_property.
                \                              '\v|'.s:block_scalar_header.
                \                             '\v)%(\s+|\s*%(\#.*)?$))*'
        " Mapping with: value
        "     that is multiline scalar
        return previndent+shiftwidth()
    endif
    return previndent
endfunction
