" Octave behaves like so: we can toggle the semicolon at the end on and off
function! filetypes#matlab#parse()
    let b:wasExtensionExecuted = 1

    if b:currentLineFirstChar == '%'
        " do nothing: it's a comment
    elseif s:strip(b:currentLine) =~ '^function'
        " do nothing: it's a function declaration
    elseif s:strip(b:currentLine) == 'end'
        " do nothing: it's an "end"
    elseif b:currentLineLastChar == ';'
        " toggle semicolon
        exec("s/;$//")
    else
        exec("s/$/;/")
    endif
endfunction
