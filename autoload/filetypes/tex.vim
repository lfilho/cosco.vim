function! filetypes#tex#parse()
    let b:wasExtensionExecuted = 1

    if b:currentLineFirstChar == '%'
        " do nothing: it's a comment
    elseif b:currentLineLastChar == '%'
        " toggle percent sign
        exec("s/%$//")
    else
        " append percent sign
        exec("s/$/%/")
    endif
endfunction
