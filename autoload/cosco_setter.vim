" =========================================================
" Filename: setter_remover.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     Here are all functions which set/replace/remove 
"     a semicolon or a comma from a given line.
" =========================================================
function! cosco_setter#MakeSemicolon(linenum)
    " make sure that there's not already a semicolon
    if matchstr(getline(a:linenum), ';$') == ''
        " add a semicolon at the end of the line
        call setline(a:linenum, substitute(getline(a:linenum), '$', ';', 'e'))
    endif
endfunction

function! cosco_setter#MakeComma(linenum)
    " make sure that there's not already a comma
    if matchstr(getline(a:linenum), ',$') == ''
        " add a comma at the end of the line
        call setline(a:linenum, substitute(getline(a:linenum), '$', ',', 'e'))
    endif
endfunction

function! cosco_setter#RemoveCommaOrSemicolon(linenum)
    " remove the comma or semicolon at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '[,;]$', '', 'e'))
endfunction
