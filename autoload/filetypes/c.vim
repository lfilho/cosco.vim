function filetypes#c#parse(cur_line, prev_line, next_line)

    " skip macros
    if stridx(a:prev_line, '#') == 0
        let b:cosco_ret_extra_conditions = 1
    endif

    let b:cosco_ret_extra_conditions = 1

endfunction 
