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
" This function is called for some special filetypes
" which are defined in /autoload/filetypes
" where it depends on, if there should be a comma or a semicolon
function! cosco_helpers#FiletypeOverride()
    try
        exec 'call filetypes#'.&ft.'#parse()'
        
    catch
        " no special conditions for the filetype
    endtry
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
function cosco_helpers#ShouldIgnoreLine()

    " Ignores comment lines, if global option is set
    if g:cosco_ignore_comment_lines 
            \ && synIDattr(synID(line("."), col(".") - 1, 1), "name") =~ '\ccomment'
        return 1
    endif

    " Ignores lines if the next one starts with a "{(["
    if b:prevLineLastChar =~ '[\{\[(]' 
                \ && b:nextLineFirstChar =~ '[\}\])]'
                \ && b:nextLineLastChar =~ '[;]'
        call setpos('.', [bufnr(), line('.') + 1, col('.'), 0])
        call cosco_setter#RemoveCommaOrSemicolon()
        call setpos('.', b:originalCursorPosition)
        return 1
    endif
    
    " look if it the content of the line is at least <amount> characters
    if strlen(b:currentLine) < 4
        return 1
    endif

    " look if the filetype is in the whitelist
    if get(g:cosco_whitelist, -1) == -1
        return 1
    endif

    return 0
endfunction

" remove all space characters around the word
function! cosco_helpers#Strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
