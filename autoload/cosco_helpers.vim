" =========================================================
" Filename: cosco_helpers.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     Here are all intern functions which are used in
"     the cosco plugin.
"     All functions are sorted after their name (for each section).
" =========================================================

" =====================
" Filetypes extensions
" =====================

" What does it do?
"   Here are all extra conditions which have to be checked as well for the given
"   filetpye, in order to decide better wether to add a comma/semicolon or not
"
" Hint:
"   Commas and semicolons are added *after* hitting the return
"   key! So we've to look at the previous line (in general) since our cursor
"   is one line under the line where we've written stuff.
"
" When is it mainly called?
"   In general it should be *only* called in the cosco#CommaOrSemiColon() function
"   when we check first if we can skip the previous line.
function! cosco_helpers#ExtraConditions(cur_line, prev_line, next_line)
    
    " ------
    " C 
    " ------
    if &ft =~ 'c'
        " skip macros
        if stridx(a:prev_line, '#') == 0
            return 1
        endif
    endif

    " Everything went well
    return 0
endfunction

function! cosco_helpers#AutoCommaOrSemiColonToggle()
    if g:auto_comma_or_semicolon >= 1
        let g:auto_comma_or_semicolon = 0
        echo "AutoCommaOrSemiColon is OFF"
    else
        let g:auto_comma_or_semicolon = 1
        echo "AutoCommaOrSemiColon is ON"
    endif
endfunction

" =========
" Rest 
" =========
" What does it do?
"	It goes through some cases to look if it should add a semicolon/comma
"	or not.
"
" Arguments:
"   pln = **P**revious **L**ine **N**umber
"
" Return values:
"   0 => Probably need to add a comma/semicolon. (at least no test cases thought that)
"   1 => Yes, we can skip the previous line. No need to add a semicolon/comma here.
function cosco_helpers#ShouldIgnoreLine(pln)

    " skip, if the file is empty currently...
    if a:pln == 0
        return 1
    endif

    " Ignores comment lines if global option is set.
    " This line looks probably a little bit irritating:
    "
    "   strlen(getline(a:line_num)) / 2,
    "
    " It goes to the middle of the line and checks there if it's a comment or not.
    " For example:
    "     // this is a commentline in some languages
    "     |                  ^
    "     ^
    "   Cursor
    "
    " It'll go to about to the middle of the line and checks, according to the syntax
    " if it's a comment.
    "
    " The last two lines (with the stridx function) are just checking, if
    " the previous line isn't a big comment block
    "   /*
    "    * Big comment section
    "    */
    if g:cosco_ignore_comment_lines 
            \ && synIDattr(
            \     synID(a:pln,
            \     strlen(getline(a:pln)) / 2,
            \     1)
            \   , "name") =~ '\ccomment' 
            \ || stridx(cosco_helpers#Strip(getline(a:pln)), '/*') != -1
            \ || stridx(cosco_helpers#Strip(getline(a:pln)), '*/') != -1
        return 1
    endif

    " Test if the previous line ends with an open ([{
    " Example:
    "   int main() {
    " 
    " In this example, there won't be any semicolon/comma added in this line
    if matchstr(getline(a:pln), '[(\[\{]\s*$') != ''
        return 1
    endif

    " Test if the next line is an open )]}
    " Example:
    "   int test(
    "     int a,
    "     int b|
    "   )      ^
    "     here's you cursor
    if matchstr(getline(a:pln), '^\s*[)\}\]]') != ''
        return 1
    endif

    return 0
endfunction

" remove all space characters around the word
function! cosco_helpers#Strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
