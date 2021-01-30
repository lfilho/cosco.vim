" =========================================================
" Filename: cosco_eval.vim
" Author(s) - (date of last changes): 
"   TornaxO7  - 29.01.2021
"   Luiz Gonzaga dos Santos Filho - 07.08.2018
" Version: 1.0
" Usage: 
"     Here are the functions which goes through some
"     conditions. Depending on the conditions it decides,
"     if a semicolon/comma should be added, removed or not
"     even placed.
"
"     Each buffer variable (like b:pln) are declared and
"     initialised in the autoload/cosco.vim main function.
"     If you want to know what they represent, go to the
"     'Gathering information' section of the autoload/cosco.vim
"     file.
"
"     The order of the conditions should be as followed:
"       - Very easy and clear situations should come up first
"         like writing an if condition or a for loop
"       - After that, add the more "complicated" moments,
"         like creating a multiline-argument in a function
"       - And then the more simpler cases, like controlling
"         if there's already a semicolon/comma/double point
"         in the previous line.
"
"     Currently this is the order:
"       1. No content
"       2. Comments
"
" All functions:
"   1. cosco_eval#Decide()
"   2. cosco_eval#Specials()
"   3. cosco_eval#Manual()
" =========================================================

" ===========================
" 1. cosco_eval#Decide()
" ===========================
" Used variables (all initialised in the cosco#CommaOrSemicolon() function):
"   cln = *C*urrent *L*ine *N*umber
"   pln = *P*revious *L*ine *N*umber
"   nln = *N*ext *L*ine *N*umber
"
" Return values:
"   0 => Skip
"   1 => Should add a comma       (,)
"   2 => Should add a semicolon   (;)
"   3 => Should add a doublepoint (:)
"   4 => Remove semicolon/comma of previous line
function cosco_eval#Decide()
    
    " ------------------
    " 1. No content 
    " ------------------
    " skip, if the file is empty currently...
    if b:pln == 0
        if g:cosco_debug
            echom "First line"
        endif
        return 0

    " ------------------------------------
    " 2. Specifique code instructions 
    " ------------------------------------
    " when writing a multiline condition, remove the settet semicolon/comma
    " Example:
    "   if (          while (well_yes &&
    "     val1 &&             but_actually_no ||
    "     |                   |
    "   ) ^             )     ^
    "   Cursor              Cursor
    "
    elseif matchstr(b:cls, '^\(&&\)\|\(||\)') != '' || matchstr(b:pls, '\(&&\)\|\(||\)$') != ''
        if g:cosco_debug
            echom "[Code] multiline conditions"
        endif
        return 4

    " when writing an if/else/while/for statement, don't add a semicolon!
    elseif matchstr(b:pls, '^\(if\)\|\(else\)\|\(while\)\|\(for\)') != ''
        if g:cosco_debug
            echom "[Code] Boolean conditions"
        endif
        return 0

    " case/default statements have a double point
    elseif matchstr(b:pls, '^\(case\)\|\(default\)') != ''
        if g:cosco_debug
            echom "[Code] case/default"
        endif

        return 3

    " ----------------
    " 2. Comments 
    " ----------------
    " This condition checks, if the user is currently in a comment section.
    " How does it find out?
    " Here's am example:
    "   /*
    "    *  Big comment section
    "    */<- Lookup point
    "    |
    "    ^
    "  Cursor
    "
    " It goes one line up (b:pln), goes to the first character (indent(b:pln))
    " and one character further (indent(b:pln) + 1) and looks, if the
    " syntax regex pattern is a comment. So in this case the "lookuppoint"
    " would be the last slash in the last line.
    elseif g:cosco_ignore_comment_lines &&
                \ synIDattr(synID(b:pln, indent(b:pln) + 1, 1), 'name') =~ '\ccomment'
        if g:cosco_debug
            echom "[Comment] Is in comment"
        endif
        return 0

    " -------------------------
    " 3. Curly Brackets {} 
    " -------------------------
    " Case:
    "   If the previous line ends with an open curly bracket like this:
    "     int main() {
    "
    elseif matchstr(b:pls, '{$') != ''
        if g:cosco_debug
            echom "[Curly Bracket] Opened"
        endif
        return 0

    elseif stridx(b:pls, '}') != -1
        if g:cosco_debug
            echom "[Curly Bracket] Closed"
        endif
        return 0

    " --------------------------
    " 4. Square brackets [] 
    " --------------------------
    "  Case:
    "   User wants to create a multiline-list or something like that
    "   => Don't add a comma/semicolon after the open "["
    "
    " Example:
    "   list = [
    "     |
    "   ] ^
    "   Cursor
    elseif matchstr(b:pls, '\[$') != ''
        if g:cosco_debug
            echom "[Square bracket] opened"
        endif
        return 0

    " this elseif condition works the same as the elseif condition in the
    " round brackets section (second one). It's used for example for a 
    " multiline list:
    "   list = [
    "     val1,
    "     val2
    "   ]
    "
    " Pattern of matchstr:
    "   - First pattern:
    "       "\]\s*$"  => Does the current line end with an ending ']'?
    "       "[^\[].*" => Don't let an open '[' be in the same line with
    "                     the ending ']'!
    "   - Second pattern:
    "       "[^,;]$"  => Make sure that there's no comma semicolon yet
    elseif (b:nls[0] == ']' || matchstr(b:cls, '[^\[].*\]\s*$') != '')
                \ && matchstr(b:pls, '[^,;]$') != '' 
        if g:cosco_debug
            echom "[Square bracket] Adding comma"
        endif
        return 1

    " -------------------------
    " 4. Round Brackets () 
    " -------------------------
    " Don't add a semicolon, if the previous line ends with an open
    " bracket.
    " Example:
    "   int test(   int test(
    "     )|            |
    "      ^        )   ^
    "     Cursor      Cursor
    elseif matchstr(b:pls, '(\s*$') != ''
        if g:cosco_debug
            echom "[Round brackets] Open bracket in prev line"
        endif
        return 0

    " Add a comma, if the user is adding elements in a tuple or
    " arguments in a function.
    " Example:
    "   int test(         int test(
    "     int a,            int a,
    "     | <-- Cursor      | <-- Cursor
    "     )                 ) {
    "     (1)               (2)
    " Regex pattern:
    "   ")\s*{\?$" => Look at the next line of the cursor in both cases!
    "
    " This condition is also useful for the following case:
    "   test();
    "   if ()
    " Normally it would add a comma after "test();", but thanks to the last
    " matchstr() condition, this won't happen if there's already a comma/
    " semicolon.
    elseif (b:nls[0] == ')' || matchstr(b:cls, ')\s*{\?$') != '')
                \ && matchstr(b:pl, '[^,;]$') != ''
        if g:cosco_debug
            echom "[Round Bracket] Adding comma"
        endif
        return 1

    " If we've a semicolon after an open round bracket, than we have in general two cases:
    "
    "   int test(     test(var1);
    "     int var1
    "     );
    "
    "       (1)           (2)
    "
    " Both cases are gonna have a semicolon at the end, but in case (1),
    " we've to remove the semicolon if the user adds a curved bracket, except it's
    " a declaration of a function. So we are lookin in our "stridx(b:cls, '{') if the
    " user wants to write a whole function and not a declaration.
    "
    " The commam in the pattern ([,;]) is for the following case:
    "   func1(arg1,
    "         func2(),
    "         |
    "       ) ^
    "       Cursor
    "
    " Without the comma test, it wouldn't go into this elseif clause which would add a semicolon
    " after the comma of func2().
    "
    elseif matchstr(b:pls, ')[,;]$') != '' && stridx(b:cls, '{') != -1
        if g:cosco_debug
            echom "Removing comma"
        endif
        return 4

    " last but not least, look if there's already a semicolon/comma.
    " If yes => Do nothing
    elseif matchstr(b:pls, '[,;]$') != ''
        return 0
    endif

    " if none cases hit, add a semicolon
    return 2
endfunction

" =============================
" 2. cosco_eval#Specials() 
" =============================
" Usage:
"   This functions goes through some special conditions for a
"   specifique language. C procides for example macros which isn't used in
"   javascript. So we put that condition into this function
"   in order so save some performance.
"   It has the same return values as the cosco_eval#Decide()
"   function.
"
" Return values:
"  -1 => Don't know what to do
"   0 => Skip
"   1 => Should add a comma
"   2 => Should add a semicolon
"   3 => Remove semicolon/comma of previous line
function cosco_eval#Specials()
    
    " ------
    " C/C++
    " ------
    if &ft == 'c' || &ft == 'cpp'

        " skip macros
        if b:pls[0] == '#'
            return 0

        " skip declarations like that:
        "   static void
        elseif synIDattr(synID(b:pln, strlen(b:pl) - 1, 1), 'name') =~ '\ctype'
            return 0
        endif

    " ---------------
    " Javascript 
    " ---------------
    elseif &ft == 'javascript'
        " TODO: Add special cases if founded one!
    endif

    return -1
endfunction

" ===========================
" 3. cosco_eval#Manual() 
" ===========================
" Usage:
"   This function is preferred, if you wanna call cosco
"   manually, because the autosetter messes up! This works
"   pretty well for javascript and will be ported probably into the
"   cosco_eval#Specials() function as well into the cosco_eval#Decide()
"   function. This function doesn't has any return values since
"   it already changes the lines.
function cosco_eval#Manual()
    
    " ==========================
    " Gathering information 
    " ==========================
    " (pasted from the cosco_eval#Decide() function)

    " current line
    let b:cln = line('.')                         " cln = *C*urrent *L*ine *N*um
    let b:cl  = getline(b:cln)                    " cl  = *C*urrent *L*ine
    let b:cls = cosco_helpers#Strip(b:cl)         " cls = *C*urrent *L*ine *S*tripped

    " next line
    let b:nln = nextnonblank(b:cln + 1)           " nln = *N*ext *L*ine *N*umber
    let b:nl  = getline(nextnonblank(b:cln + 1))  " nl  = *N*ext *L*ine
    let b:nls = cosco_helpers#Strip(b:nl)         " nls = *N*ext *L*ine *S*tripped
    
    " previous line
    let b:pln = prevnonblank(b:cln - 1)           " pln = *P*revious *L*ine *N*umber
    let b:pl  = getline(prevnonblank(b:cln - 1))  " pl  = *P*revious *L*ine
    let b:pls = cosco_helpers#Strip(b:pl)         " pl  = *P*revious *L*ine

    " ===============
    " Evaluating 
    " ===============
    if b:pls[-1] == ','
        if b:nls[-1] == ','
            call cosco#MakeComma(b:cln)
        elseif indent(b:nln) < indent(b:cln)
            call cosco#MakeSemicolon(b:cln)
        elseif indent(b:nln) == indent(b:cln)
            call cosco#MakeComma(b:cln)
        endif
    elseif b:prevLineLastChar == ';'
        call cosco#MakeSemicolon(b:cln)
    elseif b:prevLineLastChar == '{'
        if b:nextLineLastChar == ','
            " TODO idea: externalize this into a "javascript" extension:
            if s:strip(b:nextLine) =~ '^var'
                call cosco#MakeSemicolon(b:cln)
            endif
            call cosco#MakeComma(b:cln)
        " TODO idea: externalize this into a "javascript" extension:
        elseif s:strip(b:prevLine) =~ '^var'
            if b:nextLineFirstChar == '}'
                call cosco#RemoveCommaOrSemicolon(b:cln)
            endif
        else
            call cosco#MakeSemicolon(b:cln)
        endif
    elseif b:prevLineLastChar == '['
        if b:nextLineFirstChar == ']'
            call cosco#RemoveCommaOrSemicolon(b:cln)
        elseif b:currentLineLastChar =~ '[}\])]'
            call cosco#MakeSemicolon(b:cln)
        else
            call cosco#MakeComma(b:cln)
        endif
    elseif b:prevLineLastChar == '('
        if b:nextLineFirstChar == ')'
            call cosco#RemoveCommaOrSemicolon(b:cln)
        else
            call cosco#MakeComma(b:cln)
        endif
    elseif b:nextLineFirstChar == ']'
        call cosco#RemoveCommaOrSemicolon(b:cln)
    else
        call cosco#MakeSemicolon(b:cln)
    endif

endfunction
