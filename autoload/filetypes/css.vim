function! filetypes#css#parse()
    let b:wasExtensionExecuted = 1

    if (b:prevLineLastChar == '}')
        exec("s/[,;]\\?$/,/e")
    elseif (b:nextLineLastChar == '}')
        exec("s/[,;]\\?$/;/e")
    elseif (b:prevLineLastChar == '{')
        exec("s/[,;]\\?$/;/e")
    elseif (b:prevLineLastChar == ',')
        exec("s/[,;]\\?$/,/e")
    elseif (b:originalLineNum == 1)
        exec("s/[,;]\\?$/,/e")
    elseif (b:currentLineFirstChar == '}')
        echom 'yow'
        exec("s/[,;]\\?$//e")
    else
        let b:wasExtensionExecuted = 0
    endif
endfunction
