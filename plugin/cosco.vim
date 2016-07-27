" File: plugin/cosco.vim
"
" To activate the AutoCommaOrSemiColon by default
" add the following line to your vimrc:
"   let g:auto_comma_or_semicolon = 1     " Default : 0
"
" For easy toggle you can map it:
"   nmap <leader>; :AutoCommaOrSemiColonToggle<CR>
"
" By default what triggers the auto action is leaving Insert mode.
" This can be changed by adding the desired events to the list:
"   let g:auto_comma_or_semicolon_events = ["InsertLeave"]
"

if !exists("g:auto_comma_or_semicolon")
    let g:auto_comma_or_semicolon = 0
endif

if !exists("g:auto_comma_or_semicolon_events")
    let g:auto_comma_or_semicolon_events = ["InsertLeave"]
endif

augroup auto_comma_or_semicolon
    autocmd!
    for event in g:auto_comma_or_semicolon_events
        execute "au " . event . " * call AutoCommaOrSemiColon()"
    endfor
augroup END

command! AutoCommaOrSemiColonToggle :call AutoCommaOrSemiColonToggle()
function! AutoCommaOrSemiColonToggle()
    if g:auto_comma_or_semicolon >= 1
        let g:auto_comma_or_semicolon = 0
        echo "AutoCommaOrSemiColon is OFF"
    else
        let g:auto_comma_or_semicolon = 1
        echo "AutoCommaOrSemiColon is ON"
    endif
endfunction

command! CommaOrSemiColon call cosco#commaOrSemiColon()
function! AutoCommaOrSemiColon()
    let b:currentLineLastChar = matchstr(getline(line('.')), '.$')
    if g:auto_comma_or_semicolon >= 1
        call cosco#commaOrSemiColon()
    endif
endfunction
