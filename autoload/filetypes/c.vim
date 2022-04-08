" c behaves like so:  if it's pre-processing, do nothing
function! filetypes#c#parse()
    if b:currentLine =~ "#"
        let b:wasExtensionExecuted = 1
        return
    endif
endfunction
