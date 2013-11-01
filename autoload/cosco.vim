" ===============================================
" Examples on how to use it (also on the README):
" ===============================================

" autocmd FileType c,cpp,css,java,javascript,perl,php,jade nmap <silent> ,; :call cosco#commaOrSemiColon()<CR>
" autocmd FileType c,cpp,css,java,javascript,perl,php,jade inoremap <silent> ,; <ESC>:call cosco#commaOrSemiColon()"<CR>a
" command! CommaOrSemiColon call cosco#commaOrSemiColon()


" ==============
" Main function:
" ==============

function! cosco#commaOrSemiColon()
    let originalLineNum = line('.')
    let s:currentLine = getline(originalLineNum)
    let s:currentLineLastChar = matchstr(s:currentLine, '.$')
    let s:currentLineIndentation = indent(originalLineNum)

    if (s:hasUnactionableLines())
        return
    endif

    let originalCursorPosition = getpos('.')

    let nextLine = s:getNextNonBlankLine(originalLineNum)
    let prevLine = s:getPrevNonBlankLine(originalLineNum)

    let nextLineIndentation = indent(s:getNextNonBlankLineNum(originalLineNum))
    let prevLineIndentation = indent(s:getPrevNonBlankLineNum(originalLineNum))

    let prevLineLastChar = matchstr(prevLine, '.$')
    let nextLineLastChar = matchstr(nextLine, '.$')
    let nextLineFirstChar = matchstr(s:strip(nextLine), '^.')

    if prevLineLastChar == ','
        if nextLineFirstChar =~ '[}\])]'
            exec("s/[,;]\\?$//")
        elseif nextLineLastChar == ','
            exec("s/[,;]\\?$/,/")
        elseif nextLineIndentation < s:currentLineIndentation
            exec("s/[,;]\\?$/;/")
        elseif nextLineIndentation == s:currentLineIndentation
            exec("s/[,;]\\?$/,/")
        endif
    elseif prevLineLastChar == ';'
        exec("s/[,;]\\?$/;/")
    elseif prevLineLastChar == '{'
        if nextLineLastChar == ','
            " TODO idea: externalize this into a "javascript" extension:
            if s:strip(nextLine) =~ '^var'
                exec("s/[,;]\\?$/;/")
            endif
            exec("s/[,;]\\?$/,/")
        " TODO idea: externalize this into a "javascript" extension:
        elseif s:strip(prevLine) =~ '^var'
            if nextLineFirstChar == '}'
                exec("s/[,;]\\?$//")
            endif
        else
            exec("s/[,;]\\?$/;/")
        endif
    elseif prevLineLastChar == '['
        if nextLineFirstChar == ']'
            exec("s/[,;]\\?$//")
        elseif s:currentLineLastChar =~ '[}\])]'
            exec("s/[,;]\\?$/;/")
        else
            exec("s/[,;]\\?$/,/")
        endif
    elseif prevLineLastChar == '('
        if nextLineFirstChar == ')'
            exec("s/[,;]\\?$//")
        else
            exec("s/[,;]\\?$/,/")
        endif
    elseif nextLineFirstChar == ']'
        exec("s/[,;]\\?$//")
    else
        exec("s/[,;]\\?$/;/")
    endif

    call setpos('.', originalCursorPosition)
endfunction

" =================
" Helper functions:
" =================

function! s:strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:getNextNonBlankLineNum(lineNum)
    return s:getFutureNonBlankLineNum(a:lineNum, 1, line('$'))
endfunction

function! s:getPrevNonBlankLineNum(lineNum)
    return s:getFutureNonBlankLineNum(a:lineNum, -1, 1)
endfunction

function! s:getNextNonBlankLine(lineNum)
    return getline(s:getNextNonBlankLineNum(a:lineNum))
endfunction

function! s:getPrevNonBlankLine(lineNum)
    return getline(s:getPrevNonBlankLineNum(a:lineNum))
endfunction

function! s:getFutureNonBlankLineNum(lineNum, direction, limitLineNum)
    if (a:lineNum == a:limitLineNum)
        return ''
    endif

    let l:futureLineNum = a:lineNum + (1 * a:direction)
    let l:futureLine = s:strip(getline(l:futureLineNum))

    if (l:futureLine == '')
        return s:getFutureNonBlankLineNum(l:futureLineNum, a:direction, a:limitLineNum)
    endif

    return l:futureLineNum
endfunction

function! s:hasUnactionableLines()
    if (s:strip(s:currentLine) == '' || s:currentLineLastChar =~ '[{[(]')
        return 1
    endif
endfunction
