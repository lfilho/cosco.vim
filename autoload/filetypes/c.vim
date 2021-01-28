function filetypes#c#parse()

    " ignore macro lines
    if matchstr(b:currentLine, '^#') != ''
        call cosco_setter#RemoveCommaOrSemicolon(line('.'))
        let b:cosco_ret_extra_conditions = 1
    endif

    return 0
endfunction 
