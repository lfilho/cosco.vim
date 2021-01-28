" TODO: put comma in method properties, like so:
" method: function() {
" bla
" }<comma here>
"
" another: property,
function filetypes#js#parse()

    if b:prevLineLastChar == '{'
        if b:nextLineLastChar == ','
            if cosco_helpers#Strip(b:nextLine) =~ '^var'
                call cosco_setter#MakeSemicolon(b:currentLine)
            endif
            call cosco_setter#MakeComma()

        elseif cosco_helpers#Strip(b:prevLine) =~ '^var'
            if b:nextLineFirstChar == '}'
                call cosco_setter#RemoveCommaOrSemicolon(line('.'))
            endif
endfunction
