" =========================================================
" Filename: cosco_helpers.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     Here are all intern functions which are used in
"     the cosco plugin.
"     All functions are sorted after their name (for each section).
" =========================================================

" toggle the state between when setting the commas/semicolons
" automatically or not.
function! cosco_helpers#AutoCommaOrSemiColonToggle()
    if g:cosco_auto_comma_or_semicolon >= 1
        let g:cosco_auto_comma_or_semicolon = 0
        echo "[Cosco] AutoCommaOrSemiColon is OFF"

        " disable the autocommands
        call cosco_autocmds#StopAutocmds()
    else
        let g:cosco_auto_comma_or_semicolon = 1
        echo "[Cosco] AutoCommaOrSemiColon is ON"

        " enable the autocomds
        call cosco_autocmds#RefreshAutocmds()
    endif
endfunction

" =========
" Rest 
" =========
" --------------------
" Strip functions 
" --------------------
" 1. Remove all spaces on the left and on the right
"   Example:
"     "  int rofl;    " => "int rofl;     "
"
" 2. Remove all comments and space on the right
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

" Remove all ending space characters, as well comment lines.
" Example:
"   "int rofl;     // useless comment, LOL" => "int rofl;"
function! cosco_helpers#StripRight(string)
    return substitute(a:string, '\s*\(//.*\)\?$', '', 'e')
endfunction
