" =========================================================
" Filename: cosco.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     This is the main file of the cosco plugin.
"     Here is the core function and some preparations
"     of the plugin.
" =========================================================

" =================
" Preparations 
" =================
" disable cosco if:
"   1. The current file is only readable
"   2. The current file isn't in the whitelist
if &readonly || get(g:cosco_whitelist, &ft, -1) == -1
    let g:cosco_enable = 0
endif

" ############################
"       Main function
" ############################

" Return values:
"   0 => Added comma/semicolon; Everything worked fine
"   1 => Didn't add a comma/semicolon; (Probably) Something went wrong
function cosco#CommaOrSemiColon()

    " --------------------------
    " Gathering information 
    " --------------------------
    let b:originalLineNum = line('.')
    " also remove all beginning/ending white spaces
    let b:currentLine = cosco_helpers#Strip(getline(b:originalLineNum))
    let b:currentLineLastChar = matchstr(b:currentLine, '.$')
    let b:currentLineFirstChar = matchstr(b:currentLine, '^.')
    let b:currentLineIndentation = indent(b:originalLineNum)

    let b:originalCursorPosition = getcurpos()

    let b:nextLine = getline(nextnonblank(b:originalLineNum) + 1)
    let b:prevLine = getline(prevnonblank(b:originalLineNum) - 1)

    let b:nextLineIndentation = indent(nextnonblank(b:originalLineNum) + 1)
    let b:prevLineIndentation = indent(prevnonblank(b:originalLineNum) - 1)

    let b:prevLineLastChar = matchstr(b:prevLine, '.$')
    let b:nextLineLastChar = matchstr(b:nextLine, '.$')
    let b:nextLineFirstChar = matchstr(cosco_helpers#Strip(b:nextLine), '^.')

    " this variable is set after an extra file set its conditions.
    " Possible values:
    "   0 => Don't check further
    "   1 => Do check further
    let b:cosco_ret_extra_conditions = 0

    " --------------
    " Filtering 
    " --------------
    " does the line need a comma/semicolon?
    if !g:cosco_enable || cosco_helpers#ShouldIgnoreLine() " is it 'worth' it to put a semicolon/comma?

        " if the comma/semicolon is the last character of the line => remove it!
        if b:currentLine[0] =~ '[,;]'
            call cosco_setter#RemoveCommaOrSemicolon(line('.'))
        endif

        return 1
    endif
    
    " ---------------
    " Overriding 
    " ---------------
    " apply the comma/semicolon for some special filetypes which don't
    " suit with the general setter
    call cosco_helpers#FiletypeOverride()
    if b:cosco_ret_extra_conditions
        return 0
    endif

    " =================================
    " Place/Remove comma/semicolon 
    " =================================
    " --------------
    " Remove it 
    " --------------
    " in case if there are multiple semicolons/commas at the end of the line.
    " Example:
    "   int rofl;;
    if matchstr(b:currentLine, '[,;]\{2,}$') != ''
        call cosco_setter#RemoveCommaOrSemicolon(line('.'))

    " -------------
    " Place it 
    " -------------
    "if b:prevLineLastChar == ','
    "    if b:nextLineLastChar == ','
    "        call cosco_setter#MakeComma()
    "    elseif b:nextLineIndentation < b:currentLineIndentation
    "        call cosco_setter#MakeSemicolon(b:currentLine)
    "    elseif b:nextLineIndentation == b:currentLineIndentation
    "        call cosco_setter#MakeComma()
    "    endif

    elseif b:prevLineLastChar == '['
        if b:nextLineFirstChar == ']'
            call cosco_setter#RemoveCommaOrSemicolon(line('.'))
        elseif b:currentLineLastChar =~ '[}\])]'
            call cosco_setter#MakeSemicolon(line('.'))
        else
            call cosco_setter#MakeComma(line('.'))
        endif

    elseif b:nextLineFirstChar == ']'
        call cosco_setter#RemoveCommaOrSemicolon(line('.'))

    else
        call cosco_setter#MakeSemicolon(line('.'))
    endif

    call setpos('.', b:originalCursorPosition)
endfunction
