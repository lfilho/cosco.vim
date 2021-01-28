" =========================================================
" Filename: cosco.vim
" Author: TornaxO7
" Last changes: 27.01.21
" Version: 1.0
" Usage: 
"     Here are all values which are loaded first for the
"     cosco plugin. It has the following structure:
"       1. Variables
"         1.1 Configurable Variables
"         1.2 Core variables (shouldn't be configured directly
"           from the user).
"       2. Autocommands.
"       3. Available commands for the user.
"         3.1 Commandline commands
"         3.2 <Plug> commands
" =========================================================

" =================
" 1. Variables 
" =================
" ---------------------------
" 1.1 Configurable variables 
" ---------------------------
" should cosco set the semicolons/commas automatically?
" Possible Vales:
"   0 => Don't set commas/semicolons automatically
"   1 => Set commas/semicolons automatically
if !exists("g:cosco_auto_comma_or_semicolon")
    let g:cosco_auto_comma_or_semicolon = 0
endif

" all events where cosco should set comments/semicolons automatically
" see :h autocmd-events to get all possible events
if !exists("g:cosco_auto_comma_or_semicolon_events")
    let g:cosco_auto_comma_or_semicolon_events = ["InsertLeave"]
endif

" should cosco add semicolons/commas in comments as well?
" Possible Values:
"   0 => No
"   1 => Yes
if !exists("g:cosco_ignore_comment_lines")
    let g:cosco_ignore_comments = 1
endif

" should we use *only* the whitelist of the user or
" should we add it to our default list?
" If the whitelist of the user is empty, than this will
" variable will be disabled
" Possible Values:
"   0 => Don't include it
"   1 => Yes include it
if !exists("g:cosco_include_default_whitelist")
    let g:cosco_include_default_whitelist = 0
endif

" which filetypes should be added?
if !exists("g:cosco_custom_whitelist")
    let g:cosco_custom_whitelist = []
    let g:cosco_include_default_whitelist = -1
endif

" Possible values:
"   0 => Disable cosco :(
"   1 => Enable cosco :)
if !exists("g:cosco_enable")
    let g:cosco_enable = 1
endif

" -------------------
" 1.2 Core variables 
" -------------------
let g:cosco_whitelist = [
    \ "c",
    \ "cpp",
    \ "javascript",
    \ "css",
    \ "matlab",
    \ "octave"
    \]

" ====================
" 2. Autocommands 
" ====================

" set for each event in the g:cosco_auto_comma_or_semicolon_events
" the function to add a semicolon or a comma
augroup auto_comma_or_semicolon
    autocmd!

    if g:cosco_auto_comma_or_semicolon >= 1
        " all filetypes in the following string "style" (as an example):
        "   *.c,*.cpp,*.js
        let b:enabled_filetypes = "*." . g:cosco_whitelist[0]
        for enabled_filetype in g:cosco_whitelist[-1:]
            let b:enabled_filetypes = b:enabled_filetypes . ",*." . enabled_filetype
        endfor

        " set for each event and the enabled filetypes the function
        " to add the commas/semicolons
        for event in g:auto_comma_or_semicolon_events
            execute "autocmd " .event. " " .b:enabled_filetypes. " call cosco#CommaOrSemiColon()"
        endfor
    endif
augroup END

" ================
" 3. Commands 
" ================
" -------------------------
" 3.1 Commandline commands 
" -------------------------
command! CommaOrSemiColon call cosco#commaOrSemiColon()
command! AutoCommaOrSemiColonToggle :call cosco_helpers#AutoCommaOrSemiColonToggle()

" --------------------
" 3.2 <Plug> Commands 
" --------------------
nnoremap <silent> <nowait> <Plug>(cosco-commaOrSemiColon)
    \ :<C-u>silent! call cosco#commaOrSemiColon()<Bar>
    \ silent! call repeat#set("\<Plug>(cosco-commaOrSemiColon)")<CR>
