" =========================================================
" Filename: setter_remover.vim
" Author(s) - (date of last changes): 
"   TornaxO7  - 29.01.2021
"   Luiz Gonzaga dos Santos Filho - 07.08.2018
" Version: 1.0
" Usage: 
"     Here are all functions which set/replace/remove 
"     a semicolon or a comma from a given line.
" =========================================================
function! cosco_setter#MakeSemicolon(linenum)
    " add a semicolon at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '$', ';', 'e'))
endfunction

function! cosco_setter#MakeComma(linenum)
    " add a comma at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '$', ',', 'e'))
endfunction

function! cosco_setter#MakeDoublePoints(linenum)
    " add a double point at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '$', ':', 'e'))
endfunction

function! cosco_setter#RemoveCommaOrSemicolon(linenum)
    " remove the comma or semicolon at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '[,;]$', '', 'e'))
endfunction
