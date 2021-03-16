" ==============
" Configuration:
" ==============

let g:cosco_ignore_comment_lines = get(g:, 'cosco_ignore_comment_lines', 0)
let g:cosco_ignore_ft_pattern = get(g:, 'cosco_ignore_ft_pattern', {})

" =================
" Helper functions:
" =================
function! s:hasUnactionableLines()
    " Ignores comment lines, if global option is configured
    if (g:cosco_ignore_comment_lines == 1)
        let l:isComment = synIDattr(synID(line("."),col("."),1),"name") =~ '\ccomment'
        if l:isComment
            return 1
        endif
    endif

    " Ignores empty lines or lines ending with opening ([{
    if (s:strip(cl) == '' || b:currentLineLastChar =~ '[{[(]')
        return 1
    endif

    " Ignores lines if the next one starts with a "{"
    if b:nextLineFirstChar == '{'
        return 1
    endif

    " Ignores custom regex patterns given a file type.
    let s:cur_ft = &filetype
    if has_key(g:cosco_ignore_ft_pattern, s:cur_ft)
      if match(getline(line(".")), g:cosco_ignore_ft_pattern[s:cur_ft]) != -1
        return 1
      endif
    endif
endfunction

function! s:ignoreCurrentFiletype()
    let filetypes = split(&ft, '\.')
    if (exists("g:cosco_filetype_whitelist"))
        for i in g:cosco_filetype_whitelist
            if (index(filetypes, i) > -1)
                return 0
            endif
        endfor

        return 1
    elseif (exists("g:cosco_filetype_blacklist"))
        for i in g:cosco_filetype_blacklist
            if (index(filetypes, i) > -1)
                return 1
            endif
        endfor

        return 0
    endif

    return 0
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

function! cosco#ManualCommaOrSemicolon()
    " Don't run if we're in a readonly buffer:
    if (&readonly == 1)
        return
    endif

    " Dont run if current filetype has been disabled:
    if (s:ignoreCurrentFiletype())
        return
    endif

    let b:wasExtensionExecuted = 0

    let b:originalLineNum = line('.')
    let b:cl = getline(b:originalLineNum)
    let b:currentLineIndentation = indent(b:originalLineNum)

    let b:originalCursorPosition = getpos('.')

    let b:nextLine = s:getNextNonBlankLine(b:originalLineNum)
    let b:prevLine = 'hi'

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
