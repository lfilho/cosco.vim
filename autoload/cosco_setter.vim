" =========================================================
" Filename: setter_remover.vim
" Author(s) - (date of last changes): 
"   TornaxO7  - 29.01.2021
"   Luiz Gonzaga dos Santos Filho - 07.08.2018
" Version: 1.0
" Usage: 
"     Here are all functions which set/replace/remove 
"     a semicolon or a comma from a given line.
"
"     Before they change the line, they need to look first, if
"     the line ends with a comment like this:
"
"         int b   // b is used for something
"
"     So it should add the semicolon after b, not after the comment!
"
" =========================================================
function! cosco_setter#AddSemicolon(linenum)

    " add a semicolon at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '$', ';', 'e'))
endfunction

function! cosco_setter#AddComma(linenum)
    " add a comma at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '$', ',', 'e'))
endfunction

function! cosco_setter#AddDoublePoints(linenum)
    " add a double point at the end of the line
    call setline(a:linenum, substitute(getline(a:linenum), '$', ':', 'e'))
endfunction

function! cosco_setter#RemoveEndCharacter(linenum)
    " remove the comma or semicolon at the end of the line
    " we don't need to look after double points since there's no
    " case yet to remove them
    call setline(a:linenum, substitute(getline(a:linenum), '[,;]$', '', 'e'))
endfunction
