" =========================================================
" Filename: cosco_helpers.vim
" Usage: 
"     Here are all intern functions which are used in
"     the cosco plugin.
"     All functions are sorted after their name (for each section).
" =========================================================

" toggle the state between when setting the commas/semicolons
" automatically or not.
function! cosco_helpers#AutoSetterToggle()
    if g:cosco_auto_setter >= 1
        let g:cosco_auto_setter = 0
        echo "[Cosco] AutoAdapatCode is OFF"

        " disable the autocommands
        call cosco_autocmds#StopAutocmds()
    else
        let g:cosco_auto_setter = 1
        echo "[Cosco] AutoAdaptCode is ON"

        " enable the autocomds
        call cosco_autocmds#RefreshAutocmds()
    endif
endfunction

" Look if cosco should be enabled for the current filetype
" Return values:
"   0 => Current filetype is not in the whitelist
"   1 => Current filetype is in the whitelist
function cosco_helpers#FiletypeInWhitelist()

    " look if the current filetype is in the whitelist
    for b:enabled_ft in g:cosco_whitelist
        if b:enabled_ft == &ft
            return 1
        endif
    endfor

    return 0
endfunction

" This function tries to map the cosco#AdaptCode() function to the <CR>
" key (if the user set the setting), otherwise it will call the function
" for each event in the list.
function cosco_helpers#ActivateCosco() 

    if cosco_helpers#FiletypeInWhitelist() 

        " if the user wants to map cosco to CR
        if g:cosco_map_cr
            imap <CR> <CR><CMD>call cosco#AdaptCode()<CR>

        " otherwise use the given events in the list to enable cosco
        else
            call cosco_autocmds#ActivateCoscoEvents()
        endif
    endif
endfunction

" --------------------
" Strip functions 
" --------------------
" Step 1: Remove all spaces on the left
"   Example:
"     "  int rofl;    " => "int rofl;     "
"
" Step 2: Remove all comments and space on the right
"   Example:
"     "int rofl; // hello there    " => "int rofl;"
function! cosco_helpers#Strip(string)
    let l:stripped_string = cosco_helpers#StripLeft(a:string)
    return cosco_helpers#StripRight(l:stripped_string)
endfunction

" Remove all beginning space characters
function! cosco_helpers#StripLeft(string)
    return substitute(a:string, '^\s*', '', 'e')
endfunction

" Remove all ending space characters and as well comment lines.
" Example:
"   "int rofl;     // useless comment, LOL" => "int rofl;"
function! cosco_helpers#StripRight(string)
    return substitute(a:string, '\s*\(//.*\)\?$', '', 'e')
endfunction
