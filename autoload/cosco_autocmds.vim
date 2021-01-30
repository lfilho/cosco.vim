" =========================================================
" Filename: cosco_autocmds.vim
" Author(s) - (date of last changes): 
"   TornaxO7  - 29.01.2021
"   Luiz Gonzaga dos Santos Filho - 07.08.2018
" Version: 1.0
" Usage: 
"     Here is the function which sets up all autocmds
"     which are needed for the cosco plugin. In general
"     the autocmds are used to do the autoplacing of the
"     commas and secmicolons.
" =========================================================

" this function is (in general) called, if the user entered a new buffer
" (see plugin/cosco.vim => 2. Autocommands)
"
" It will set the autocommand for the new buffer to add automatically 
" (if it's enabled) the commas and semicolons.
function cosco_autocmds#RefreshAutocmds()

    " set for each event in the g:cosco_auto_comma_or_semicolon_events
    augroup cosco_auto_comma_semicolon
        autocmd!
    
        " 0 => Current filetype is not in the whitelist
        " 1 => Current filetype is in the whitelist
        let b:ft_is_in_whitelist = 0
    
        " look if the current filetype is in the whitelist
        for b:enabled_ft in g:cosco_whitelist
            if b:enabled_ft == &ft
                let b:ft_is_in_whitelist = 1
                break
            endif
        endfor
    
        " enable for each event the auto comma/semicolon placer
        if b:ft_is_in_whitelist
            for event in g:cosco_auto_comma_or_semicolon_events
                execute "autocmd " .event. " <buffer> call cosco#CommaOrSemiColon()"
            endfor
        endif
    augroup END
endfunction

" This will stop all autocmds to add the commas
" and semicolons automatically
function cosco_autocmds#StopAutocmds()
    augroup cosco_auto_comma_semicolon
        autocmd!
    augroup END
endfunction
