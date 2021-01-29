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

" How it general works:
"   1. Get some information of the previous line in order
"     to decide what to do.
"   2. Look if we need to add a semicolon/comma or not. If not => Stop the function
"   3. Otherwise look if there are some special "rules" for the given filetype.
"     If yes, load them. (They are in the for autoload/filetypes)
"   4. Now do the general looking, like is in the *previous line* an assignment or a declaration and so on.
"     It *won't* set the semicolon/comma in the currentline! Only in the previous line!
"
" Return values:
"   0 => Added comma/semicolon; Everything worked fine
"   1 => Didn't add a comma/semicolon; (Probably) Something went wrong
function cosco#CommaOrSemiColon()

    " stop immediately if cosco is not enabled
    if !g:cosco_enable
        return 1
    endif

    " ==========================
    " Gathering information 
    " ==========================

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

    " this variable is set after an extra file set its conditions.
    " Possible values:
    "   0 => Don't check further
    "   1 => Do check further
    let b:cosco_ret_value = 0

    " =============================
    " Evaluating the situation 
    " =============================
    let b:cosco_ret_value = cosco_eval#Specials()

    " if the special cases couldn't find anything
    " => Go through the general conditions
    if b:cosco_ret_value == -1
        let b:cosco_ret_value = cosco_eval#Decide()
    endif

    if b:cosco_ret_value == 1
        "echo "Add a comma"
        call cosco_setter#MakeComma(b:pln)

    elseif b:cosco_ret_value == 2
        "echo "Add a semicolon"
        call cosco_setter#MakeSemicolon(b:pln)

        " now make sure that we have the same indentation as the previous line
        " since vim will move the cursor not back to its identation (as in step
        " 2), if the user uses the enter key to get to the next line
        " (the vertical line should represent the cursor)
        "   Step 1:
        "     short a|
        "
        "   Step 2 (create new line):
        "     short a
        "       |
        "
        "   Step 3 (cosco: add semicolon):
        "     short a;
        "       |
        "
        "   Step 4: (cosco: fix indentation of cursor)
        "     short a;
        "     |
        " Step 4 does this setline here.
        "
        if b:cls == ''
            call setline(b:cln, py3eval("' ' * ". indent(b:pln)))
        endif

    elseif b:cosco_ret_value == 3
        call cosco_setter#RemoveCommaOrSemicolon(b:pln)
    endif

    return 0
endfunction
