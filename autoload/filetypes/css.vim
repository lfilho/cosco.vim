function! filetypes#css#parse()
    if (b:prevLineLastChar == '}')
        call cosco#makeItAComma()

    elseif (b:nextLineLastChar == '}')
        call cosco#makeItASemiColon()

    elseif (b:prevLineLastChar == '{')
        call cosco#makeItASemiColon()

    elseif (b:prevLineLastChar == ',')
        call cosco#makeItAComma()

    elseif (b:originalLineNum == 1)
        call cosco#makeItAComma()

    elseif (b:currentLineFirstChar == '}')
        call cosco#makeItASemiColon()

    else
        return 0
    endif

    return 1
endfunction
