" File: plugin/cosco.vim

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
    if g:auto_comma_or_semicolon >= 1
        call cosco#commaOrSemiColon()
    endif
endfunction
