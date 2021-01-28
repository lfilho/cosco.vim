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

    " --------------------------
    " Gathering information 
    " --------------------------
    echo 'cosco#CommaOrSemiColon()'

    " current line
    let b:cln = line('.')                         " cln = *C*urrent *L*ine *N*um
    let b:cl  = getline(b:cln)                    " cl  = *C*urrent *L*ine
    let b:cls = cosco_helpers#Strip(b:cln)        " cls = *C*urrent *L*ine *S*tripped

    " next line
    let b:nln = nextnonblank(b:cln + 1)           " nln = *N*ext *L*ine *N*umber
    let b:nl  =  getline(nextnonblank(b:cln + 1)) " nl  = *N*ext *L*ine
    
    " previous line
    let b:pln = prevnonblank(b:cln - 1)           " pln = *P*revious *L*ine *N*umber
    let b:pl  = getline(prevnonblank(b:cln - 1))  " pl  = *P*revious *L*ine

    " this variable is set after an extra file set its conditions.
    " Possible values:
    "   0 => Don't check further
    "   1 => Do check further
    let b:cosco_ret_extra_conditions = 0

    " -------------
    " Skipping 
    " -------------
    " does the line need a comma/semicolon?
    if !g:cosco_enable || cosco_helpers#ShouldIgnoreLine(b:pln) " is it 'worth' it to put a semicolon/comma?

        " if the comma/semicolon is the last character of the line => remove it!
        if matchstr(b:cl, '^[,;]') != ''
            call cosco_setter#RemoveCommaOrSemicolon(line('.'))
        endif

        return 1
    endif
    
    " ------------------------
    " Filetype specifique 
    " ------------------------
    " some filetypes needs some special "rules" since their syntax might
    " have some special formats. The following function is for each
    " filetype which goes through some extra conditions
    if cosco_helpers#ExtraConditions(b:cln, b:pln, b:nln)
        echo "b:cosco_ret_extra_conditions"
        return 0
    endif

    " =================================
    " Place/Remove comma/semicolon 
    " =================================
    " --------------
    " Remove it 
    " --------------
    " in case if there are multiple semicolons/commas at the end of the line or
    " if the semicolon is the last character in the line.
    " Examples:
    "   int rofl;;    ;         while (a < b)
    "                               ;
    "      (1)       (2)           (3)
    "
    " Case (3) is an exception: In this case the semicolon won't be removed!
    "
    " Regex patterns (in order of the condition-tests)
    "   - "[,;]\{2,}$"  => If there are at least 2 commas or semicolons at the end
    "                     of the line, remove one (case 1)
    "   - "^[,;]$"      => If the line hash only a semicolon/comma, remove it
    " 
    " The third "matchstr" makes sure, that we don't have a condition here! If it's
    " like in case (3), don't remove it!
    if matchstr(b:pl, '[,;]\{2,}$') != '' 
                \ || (
                \       matchstr(b:pl, '^[,;]$') != ''
                \       &&
                \       matchstr(getline(b:pln - 1), '(.*)') == ''
                \ )
        call cosco_setter#RemoveCommaOrSemicolon(b:pln)
    endif

    echo 'cosco#CommaOrSemiColon()'
    " -------------
    " Place it 
    " -------------
    " are we inside a list or something like that?
    " Examples:
    "   list = [    int test(     int test2(
    "     1,            int a,        int a,
    "     2,            int b         int b)
    "   ]             ) {           {
    "                 }             }
    "
    "     (1)           (2)           (3)
    " The steps, how it decides what to do:
    "   - Look if the previous line has a comma as well
    "   - Look if an open )]} is:
    "     - the first character in the next line (case 2)
    "     - the last character of the current line (case 3)
    "
    " Regex Pattern (in order of the conditions):
    "   - ",\s*$"   => Look, if the line above has a comma
    "   - "^\s*[\}\])]"   => Is there an open brace in the next line?           (case 2)
    "   - "[\}\])]$"      => Is a brace in the current line the last character? (case 3)
    "   - "[(\[\{]$"      => The previous line isn't the open brace => Make sure current line isn't the first value
    if matchstr(getline(b:pln - 1), ',\s*$') != ''
                \ || ((matchstr(b:nl, '^\s*[\}\])]') != '' || matchstr(b:cl, '[\}\])]$') != '') && matchstr(b:pl, '[(\[\{]$') == '')
        call cosco_setter#MakeComma(b:pln)

    " add a semicolon IF there's not already one!
    elseif matchstr(b:pl, '[,;]$') == ''
        call cosco_setter#MakeSemicolon(b:pln)
        
        echo "cosco_setter#MakeComma(b:pln)"
        " now make sure that we have the same indentation as
        " the previous line!
        call setline(b:cln, py3eval("' ' * ". indent(b:pln)))
    endif
endfunction
