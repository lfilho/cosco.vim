function filetypes#c#parse()

    " ignore macro lines
    if strlen(matchstr(b:currentLine, '^#')) > 0
        let b:cosco_ret_extra_conditions = 1

    return 0

endfunction 
