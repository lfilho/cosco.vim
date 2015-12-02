function! filetypes#css#parse()
    let b:wasExtensionExecuted = 1

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
        let b:wasExtensionExecuted = 0
    endif
endfunction
