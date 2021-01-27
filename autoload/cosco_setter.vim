" =========================================================
" Filename: setter_remover.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     Here are all functions which set/replace/remove 
"     a semicolon or a comma from a given line.
" =========================================================
function! cosco_setter#MakeSemicolon()
    exec('s/;\?$/;/e')
endfunction

function! cosco_setter#MakeComma()
    exec('s/,\?$/,/e')
endfunction

function! cosco_setter#RemoveCommaOrSemicolon()
    exec('s/[,;]\?$//e')
endfunction
