" cpp behaves like so: if current line include a header, do nothing
function! filetypes#cpp#parse()
    if b:currentLine =~ "^#"
        let b:wasExtensionExecuted = 1
        return
    endif
endfunction
