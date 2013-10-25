" If there isn't one, append a semi colon to the end of the current line.
"
" For programming languages using a semi colon at the end of statement.
autocmd FileType c,cpp,css,java,javascript,perl,php,jade nmap <silent> ,; :call <SID>smartCommaOrSemiColon()<CR>
autocmd FileType c,cpp,css,java,javascript,perl,php,jade inoremap <silent> ,; <ESC>:call <SID>smartCommaOrSemiColon()<CR>a

function! s:smartCommaOrSemiColon()
    let originalLineNum = line('.')
    let currentLine = getline(originalLineNum)
    let currentLineLastChar = matchstr(currentLine, '.$')
    let currentLineIndentation = indent(originalLineNum)

    if (s:strip(currentLine) == '' || currentLineLastChar =~ '[{[(]')
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
        if nextLineLastChar == ','
            exec("s/[,;]\\?$/,/")
        elseif nextLineFirstChar =~ '[}\])]'
            exec("s/[,;]\\?$//")
        elseif nextLineIndentation < currentLineIndentation
            exec("s/[,;]\\?$/;/")
        elseif nextLineIndentation == currentLineIndentation
            exec("s/[,;]\\?$/,/")
        endif
    elseif prevLineLastChar == ';'
        exec("s/[,;]\\?$/;/")
    elseif prevLineLastChar == '{'
        if nextLineLastChar == ','
            if nextLine =~ '^var'
                exec("s/[,;]\\?$/;/")
            endif
            exec("s/[,;]\\?$/,/")
        else
            exec("s/[,;]\\?$/;/")
        endif
    elseif prevLineLastChar == '['
        if nextLineFirstChar == ']'
            exec("s/[,;]\\?$//")
        else
            exec("s/[,;]\\?$/,/")
        endif
    else
        exec("s/[,;]\\?$/;/")
    endif

    call setpos('.', originalCursorPosition)
endfunction

"
" =================
" Helper functions:
" =================
"
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
