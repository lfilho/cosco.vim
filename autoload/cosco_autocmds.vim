" =========================================================
" Filename: cosco_autocmds.vim
" Usage: 
"     Here is the function which sets up all autocmds
"     which are needed for the cosco plugin. In general
"     the autocmds are used to do the autoplacing of the
"     commas and secmicolons.
" =========================================================

" this function is (in general) called, if the user entered a new buffer
" (see plugin/cosco.vim => 2. Autocommands)
function cosco_autocmds#ActivateCoscoEvents()
    echom "Yes"
    augroup cosco_auto_comma_semicolon
        autocmd!

        " enable for each event the auto comma/semicolon placer
        "for event in g:cosco_auto_setter_events
        "    "execute "autocmd " .event. " <buffer> call cosco#AdaptCode()"
        "    "
        "endfor
        autocmd TextChangedI call cosco#AdaptCode()
    augroup END
endfunction

" This will stop all autocmds to add the commas
" and semicolons automatically
function cosco_autocmds#StopAutocmds()
    augroup cosco_auto_comma_semicolon
        autocmd!
    augroup END
endfunction
