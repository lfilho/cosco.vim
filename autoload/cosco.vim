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
    " Ignores comment lines, if global option is configured
    if (g:cosco_ignore_comment_lines == 1)
        let l:isComment = synIDattr(synID(line("."),col("."),1),"name") =~ '\ccomment'
        if l:isComment
            return 1
        endif
    endif

    " Ignores empty lines or lines ending with opening ([{
    if (s:strip(b:currentLine) == '' || b:currentLineLastChar =~ '[{[(]')
        return 1
    endif

    " Ignores lines if the next one starts with a "{"
    if b:nextLineFirstChar == '{'
        return 1
    endif
endfunction

" =====================
" Filetypes extensions:
" =====================

function! s:filetypeOverrides()
    try
        exec 'call filetypes#'.&ft.'#parse()'
    catch
        " No filetypes for the current buffer filetype
    endtry
endfunction

" ================================
" Insertion and replace functions:
" ================================

function! cosco#removeCommaOrSemiColon()
    if b:currentLineLastChar =~ '[,;]'
        exec("s/[,;]\\?$//e")
    end
endfunction

function! cosco#makeItASemiColon()
    " Prevent unnecessary buffer change:
    if b:currentLineLastChar == ';'
        return
    endif

    exec("s/[,;]\\?$/;/e")
endfunction

function! cosco#makeItAComma()
    " Prevent unnecessary buffer change:
    if b:currentLineLastChar == ','
        return
    endif

    exec("s/[,;]\\?$/,/e")
endfunction

" ==============
" Main function:
" ==============

function! cosco#commaOrSemiColon()
    " Don't run if we're in a readonly buffer:
    if (&readonly == 1)
        return
    endif

    let b:wasExtensionExecuted = 0

    let b:originalLineNum = line('.')
    let b:currentLine = getline(b:originalLineNum)
    let b:currentLineLastChar = matchstr(b:currentLine, '.$')
    let b:currentLineFirstChar = matchstr(b:currentLine, '^.')
    let b:currentLineIndentation = indent(b:originalLineNum)

    let b:originalCursorPosition = getpos('.')

    let b:nextLine = s:getNextNonBlankLine(b:originalLineNum)
    let b:prevLine = s:getPrevNonBlankLine(b:originalLineNum)

    let b:nextLineIndentation = indent(s:getNextNonBlankLineNum(b:originalLineNum))
    let b:prevLineIndentation = indent(s:getPrevNonBlankLineNum(b:originalLineNum))

    let b:prevLineLastChar = matchstr(b:prevLine, '.$')
    let b:nextLineLastChar = matchstr(b:nextLine, '.$')
    let b:nextLineFirstChar = matchstr(s:strip(b:nextLine), '^.')

    if (s:hasUnactionableLines())
        return
    endif

    call s:filetypeOverrides()

    if (b:wasExtensionExecuted)
        call setpos('.', b:originalCursorPosition)
        return
    endif

    if b:prevLineLastChar == ','
        if b:nextLineLastChar == ','
            call cosco#makeItAComma()
        elseif b:nextLineIndentation < b:currentLineIndentation
            call cosco#makeItASemiColon()
        elseif b:nextLineIndentation == b:currentLineIndentation
            call cosco#makeItAComma()
        endif
    elseif b:prevLineLastChar == ';'
        call cosco#makeItASemiColon()
    elseif b:prevLineLastChar == '{'
        if b:nextLineLastChar == ','
            " TODO idea: externalize this into a "javascript" extension:
            if s:strip(b:nextLine) =~ '^var'
                call cosco#makeItASemiColon()
            endif
            call cosco#makeItAComma()
        " TODO idea: externalize this into a "javascript" extension:
        elseif s:strip(b:prevLine) =~ '^var'
            if b:nextLineFirstChar == '}'
                call cosco#removeCommaOrSemiColon()
            endif
        else
            call cosco#makeItASemiColon()
        endif
    elseif b:prevLineLastChar == '['
        if b:nextLineFirstChar == ']'
            call cosco#removeCommaOrSemiColon()
        elseif b:currentLineLastChar =~ '[}\])]'
            call cosco#makeItASemiColon()
        else
            call cosco#makeItAComma()
        endif
    elseif b:prevLineLastChar == '('
        if b:nextLineFirstChar == ')'
            call cosco#removeCommaOrSemiColon()
        else
            call cosco#makeItAComma()
        endif
    elseif b:nextLineFirstChar == ']'
        call cosco#removeCommaOrSemiColon()
    else
        call cosco#makeItASemiColon()
    endif

    call setpos('.', b:originalCursorPosition)
endfunction
