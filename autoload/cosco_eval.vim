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
"     Each buffer variable (b:pls, b:nls, ...) are declared and
"     initialised in the autoload/cosco.vim main function.
"     If you want to know what they represent, go to the
"     'Gathering information' section of the autoload/cosco.vim
"     file.
"
"
" All functions:
"   1. cosco_eval#ShouldNotSkip()
"   2. cosco_eval#ShouldAdd()
"   3. cosco_eval#ShouldRemove()
"   4. cosco_eval#Specials()
"   5. cosoc_eval#Manual()
"
" Each function has a little description for more information.
" =========================================================

" ===========================
" 1. cosco_eval#Decide()
" ===========================
" Usage:
"   It goes through some general situation where we wouldn't add a semicolon/comma here.
"
" Return values:
"   0 => No, you can skip
"   1 => Yes, don't skip
function cosco_eval#ShouldNotSkip()
    
    " ==================
    " Obvious cases 
    " ==================
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
    " Make sure that we're not in a multiline condition.
    " Example:
    "   if (          while (well_yes &&
    "     val1 &&             but_actually_no ||
    "     |                   |
    "   ) ^             )     ^
    "   Cursor              Cursor
    "
    elseif stridx(b:cls, '\(&&\)\|\(||\)') != -1 || stridx(b:pls, '\(&&\)\|\(||\)') != -1
        if g:cosco_debug
            echom "[Code] multiline conditions"
        endif
        return 0

    " when writing an if/else/while/for statement, don't add a semicolon!
    elseif matchstr(b:pls, '^\(if\)\|\(else\)\|\(while\)\|\(for\)') != ''
        if g:cosco_debug
            echom "[Code] Boolean conditions"
        endif
        return 0

    " ----------------
    " 3. Comments 
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
     
    " -----------------------------------------
    " 4. There's already a semicolon/comma 
    " -----------------------------------------
    " last but not least, look if there's already a semicolon/comma/double point.
    " If yes => Do nothing
    elseif matchstr(b:pls, '[,;:]$') != ''
        return 0

    " =======================
    " More special cases 
    " =======================
    " -------------------------
    " 5. Curly Brackets {}
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
    endif

    return 1
endfunction

" ===============================
" 2.0 cosco_eval#ShouldAdd() 
" ===============================
" Usage:
"   This function tests, if it can add a semicolon/comma or a double
"   point and returns what to add.
"
"   Since we're mainly using the semicolon character, we'll just need
"   to add conditions for the comma (,) and double point character (:).
"   That's why the function returns (if no conditions hit) 3.
"
" Return values:
"   1 => Add a comma        (,)
"   2 => Add a double point (:)
"   3 => Add a semicolon    (;)
"
" The return values are oriented at the "Add the symbol (if given)" section of the cosco#CommaOrSemicolon function.
function cosco_eval#ShouldAdd()

    " this elseif condition works the same as the elseif condition in the
    " round brackets section (second one). It's used for example for a 
    " multiline list:
    "
    "       list = [
    "         val1,
    "         val2
    "       ]
    "
    " Pattern of matchstr:
    "   - First pattern:
    "       "\]\s*$"  => Does the current line end with an ending ']'?
    "       "[^\[].*" => Don't let an open '[' be in the same line with
    "                     the ending ']'!
    if (b:nls[0] == ']' || matchstr(b:cls, '[^\[].*\]\s*$') != '')
        if g:cosco_debug
            echom "[Square bracket] Adding comma"
        endif
        return 1

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
        if g:cosco_debug
            echom "[Round Bracket] Adding comma"
        endif
        return 1
    
    " --------------------------
    " Switch case statement 
    " --------------------------
    " 'case' and 'default' need a double point in the end
    elseif matchstr(b:pls, '^\(case\)\|\(default\)') != ''
        if g:cosco_debug
            echom "[Code] case/default"
        endif
        return 2
    endif

    return 3

endfunction

" ==================================
" 3.0 cosco_eval#ShouldRemove() 
" ==================================
" Usage:
"   This function looks if it should remove the comma/semicolon/double point
"   from the previous line.
"   In this case, it mainly happens, that it needn't remove a semicolon/comma,
"   so just add conditions, where we have to remove a semicolon!
"
" Return values:
"   0 => No, don't remove anything
"   1 => Yes, remove the semicolon/comma/double points from the given line
"       (general the previous line)
"
function cosco_eval#ShouldRemove()

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
    if matchstr(b:pls, ')[,;]$') != '' && b:cls[0] == '{'
        if g:cosco_debug
            echom "Removing comma"
        endif
        return 1
    endif

    return 0
endfunction

" =============================
" 4.0 cosco_eval#Specials() 
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
"  -1 => Don't know what to do, go through the general conditions!
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
        return -1
    endif

    return -1
endfunction

" ===========================
" 5.0 cosco_eval#Manual() 
" ===========================
" Usage:
"   This function is preferred, if you wanna call cosco
"   manually, for example if the auto-setter messes up! This works
"   pretty well for javascript and will be ported probably into the
"   cosco_eval#Specials() function as well into the cosco_eval#Decide()
"   function. This function doesn't has any return values since
"   it already changes the lines and is called manually.
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
            call cosco#AddComma(b:cln)
        elseif indent(b:nln) < indent(b:cln)
            call cosco#AddSemicolon(b:cln)
        elseif indent(b:nln) == indent(b:cln)
            call cosco#AddComma(b:cln)
        endif
    elseif b:pls[-1] == ';'
        call cosco#AddSemicolon(b:cln)
    elseif b:pls[-1] == '{'
        if b:nls[-1] == ','
            " TODO idea: externalize this into a "javascript" extension:
            if cosco_helpers#Strip(b:nextLine) =~ '^var'
                call cosco#AddSemicolon(b:cln)
            endif
            call cosco#AddComma(b:cln)
        " TODO idea: externalize this into a "javascript" extension:
        elseif cosco_helpers#Strip(b:pls) =~ '^var'
            if b:nls[0] == '}'
                call cosco#RemoveEndCharacter(b:cln)
            endif
        else
            call cosco#AddSemicolon(b:cln)
        endif
    elseif b:pls[-1] == '['
        if b:nls[0] == ']'
            call cosco#RemoveEndCharacter(b:cln)
        elseif b:cls[-1] =~ '[}\])]'
            call cosco#AddSemicolon(b:cln)
        else
            call cosco#AddComma(b:cln)
        endif
    elseif b:pls[-1] == '('
        if b:nls[0] == ')'
            call cosco#RemoveEndCharacter(b:cln)
        else
            call cosco#AddComma(b:cln)
        endif
    elseif b:nls[0] == ']'
        call cosco#RemoveEndCharacter(b:cln)
    else
        call cosco#AddSemicolon(b:cln)
    endif

endfunction
